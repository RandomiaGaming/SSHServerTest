/*
 *  Copyright 2024 The OpenSSL Project Authors. All Rights Reserved.
 *
 *  Licensed under the Apache License 2.0 (the "License").  You may not use
 *  this file except in compliance with the License.  You can obtain a copy
 *  in the file LICENSE in the source distribution or at
 *  https://www.openssl.org/source/license.html
 */

/*
 * NB: Changes to this file should also be reflected in
 * doc/man7/ossl-guide-tls-server-block.pod
 */

#include <string.h>

/* Include the appropriate header file for SOCK_STREAM */
#ifdef _WIN32 /* Windows */
# include <stdarg.h>
# include <winsock2.h>
#else /* Linux/Unix */
# include <err.h>
# include <sys/socket.h>
# include <sys/select.h>
#endif

#include <openssl/bio.h>
#include <openssl/ssl.h>
#include <openssl/err.h>

static const char cache_id[] = "OpenSSL Demo Server";

#ifdef _WIN32
static const char *progname;

static void vwarnx(const char *fmt, va_list ap)
{
    if (progname != NULL)
        fprintf(stderr, "%s: ", progname);
    vfprintf(stderr, fmt, ap);
    putc('\n', stderr);
}

static void errx(int status, const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vwarnx(fmt, ap);
    va_end(ap);
    exit(status);
}

static void warnx(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vwarnx(fmt, ap);
    va_end(ap);
}
#endif

/* Minimal TLS echo server. */
int main(int argc, char *argv[])
{
    int res = EXIT_FAILURE;
    long opts;
    const char *hostport;
    SSL_CTX *ctx = NULL;
    BIO *acceptor_bio;

#ifdef _WIN32
    progname = argv[0];
#endif

    if (argc != 2)
        errx(res, "Usage: %s [host:]port", argv[0]);
    hostport = argv[1];

    /*
     * An SSL_CTX holds shared configuration information for multiple
     * subsequent per-client SSL connections.
     */
    ctx = SSL_CTX_new(TLS_server_method());
    if (ctx == NULL) {
        ERR_print_errors_fp(stderr);
        errx(res, "Failed to create server SSL_CTX");
    }

    /*
     * TLS versions older than TLS 1.2 are deprecated by IETF and SHOULD
     * be avoided if possible.
     */
    if (!SSL_CTX_set_min_proto_version(ctx, TLS1_2_VERSION)) {
        SSL_CTX_free(ctx);
        ERR_print_errors_fp(stderr);
        errx(res, "Failed to set the minimum TLS protocol version");
    }

#if 0
    /*
     * In applications (e.g. SMTP) where most clients are performing
     * unauthenticated opportunistic TLS it may make sense to set the security
     * level to 0, allowing weaker encryption parameters, which are still
     * stronger than a potential cleartext fallback.
     *
     * The default security level is 2 (as of OpenSSL 3.2), which is roughly
     * equivalent to that of 112 bit symmetric keys, or 2048-bit RSA or
     * finite-field Diffie-Hellman keys.  Notably, non-zero security levels no
     * longer allow the use of SHA-1 in certificate signatures, key exchange
     * or in the TLS 1.[01] PRF (so TLS 1.0 and 1.1 require security level 0).
     */
    SSL_CTX_set_security_level(ctx, 0);
#endif

    /*
     * Tolerate clients hanging up without a TLS "shutdown".  Appropriate in all
     * application protocols which perform their own message "framing", and
     * don't rely on TLS to defend against "truncation" attacks.
     */
    opts = SSL_OP_IGNORE_UNEXPECTED_EOF;

    /*
     * Block potential CPU-exhaustion attacks by clients that request frequent
     * renegotiation.  This is of course only effective if there are existing
     * limits on initial full TLS handshake or connection rates.
     */
    opts |= SSL_OP_NO_RENEGOTIATION;

    /*
     * Most servers elect to use their own cipher preference rather than that of
     * the client.
     */
    opts |= SSL_OP_CIPHER_SERVER_PREFERENCE;

    /* Apply the selection options */
    SSL_CTX_set_options(ctx, opts);

    /*
     * Load the server's certificate *chain* file (PEM format), which includes
     * not only the leaf (end-entity) server certificate, but also any
     * intermediate issuer-CA certificates.  The leaf certificate must be the
     * first certificate in the file.
     *
     * In advanced use-cases this can be called multiple times, once per public
     * key algorithm for which the server has a corresponding certificate.
     * However, the corresponding private key (see below) must be loaded first,
     * *before* moving on to the next chain file.
     *
     * The requisite files "chain.pem" and "pkey.pem" can be generated by running
     * "make chain" in this directory.  If the server will be executed from some
     * other directory, move or copy the files there.
     */
    if (SSL_CTX_use_certificate_chain_file(ctx, "chain.pem") <= 0) {
        SSL_CTX_free(ctx);
        ERR_print_errors_fp(stderr);
        errx(res, "Failed to load the server certificate chain file");
    }

    /*
     * Load the corresponding private key, this also checks that the private
     * key matches the just loaded end-entity certificate.  It does not check
     * whether the certificate chain is valid, the certificates could be
     * expired, or may otherwise fail to form a chain that a client can validate.
     */
    if (SSL_CTX_use_PrivateKey_file(ctx, "pkey.pem", SSL_FILETYPE_PEM) <= 0) {
        SSL_CTX_free(ctx);
        ERR_print_errors_fp(stderr);
        errx(res, "Error loading the server private key file, "
                  "possible key/cert mismatch???");
    }

    /*
     * Servers that want to enable session resumption must specify a cache id
     * byte array, that identifies the server application, and reduces the
     * chance of inappropriate cache sharing.
     */
    SSL_CTX_set_session_id_context(ctx, (void *)cache_id, sizeof(cache_id));
    SSL_CTX_set_session_cache_mode(ctx, SSL_SESS_CACHE_SERVER);

    /*
     * How many client TLS sessions to cache.  The default is
     * SSL_SESSION_CACHE_MAX_SIZE_DEFAULT (20k in recent OpenSSL versions),
     * which may be too small or too large.
     */
    SSL_CTX_sess_set_cache_size(ctx, 1024);

    /*
     * Sessions older than this are considered a cache miss even if still in
     * the cache.  The default is two hours.  Busy servers whose clients make
     * many connections in a short burst may want a shorter timeout, on lightly
     * loaded servers with sporadic connections from any given client, a longer
     * time may be appropriate.
     */
    SSL_CTX_set_timeout(ctx, 3600);

    /*
     * Clients rarely employ certificate-based authentication, and so we don't
     * require "mutual" TLS authentication (indeed there's no way to know
     * whether or how the client authenticated the server, so the term "mutual"
     * is potentially misleading).
     *
     * Since we're not soliciting or processing client certificates, we don't
     * need to configure a trusted-certificate store, so no call to
     * SSL_CTX_set_default_verify_paths() is needed.  The server's own
     * certificate chain is assumed valid.
     */
    SSL_CTX_set_verify(ctx, SSL_VERIFY_NONE, NULL);

    /*
     * Create a listener socket wrapped in a BIO.
     * The first call to BIO_do_accept() initialises the socket
     */
    acceptor_bio = BIO_new_accept(hostport);
    if (acceptor_bio == NULL) {
        SSL_CTX_free(ctx);
        ERR_print_errors_fp(stderr);
        errx(res, "Error creating acceptor bio");
    }

    BIO_set_bind_mode(acceptor_bio, BIO_BIND_REUSEADDR);
    if (BIO_do_accept(acceptor_bio) <= 0) {
        SSL_CTX_free(ctx);
        ERR_print_errors_fp(stderr);
        errx(res, "Error setting up acceptor socket");
    }

    /* Wait for incoming connection */
    for (;;) {
        BIO *client_bio;
        SSL *ssl;
        unsigned char buf[8192];
        size_t nread;
        size_t nwritten;
        size_t total = 0;

        /* Pristine error stack for each new connection */
        ERR_clear_error();

        /* Wait for the next client to connect */
        if (BIO_do_accept(acceptor_bio) <= 0) {
            /* Client went away before we accepted the connection */
            continue;
        }

        /* Pop the client connection from the BIO chain */
        client_bio = BIO_pop(acceptor_bio);
        fprintf(stderr, "New client connection accepted\n");

        /* Associate a new SSL handle with the new connection */
        if ((ssl = SSL_new(ctx)) == NULL) {
            ERR_print_errors_fp(stderr);
            warnx("Error creating SSL handle for new connection");
            BIO_free(client_bio);
            continue;
        }
        SSL_set_bio(ssl, client_bio, client_bio);

        /* Attempt an SSL handshake with the client */
        if (SSL_accept(ssl) <= 0) {
            ERR_print_errors_fp(stderr);
            warnx("Error performing SSL handshake with client");
            SSL_free(ssl);
            continue;
        }

        while (SSL_read_ex(ssl, buf, sizeof(buf), &nread) > 0) {
            if (SSL_write_ex(ssl, buf, nread, &nwritten) > 0 &&
                nwritten == nread) {
                total += nwritten;
                continue;
            }
            warnx("Error echoing client input");
            break;
        }
        fprintf(stderr, "Client connection closed, %zu bytes sent\n", total);
        SSL_free(ssl);
    }

    /*
     * Unreachable placeholder cleanup code, the above loop runs forever.
     */
    SSL_CTX_free(ctx);
    return EXIT_SUCCESS;
}
