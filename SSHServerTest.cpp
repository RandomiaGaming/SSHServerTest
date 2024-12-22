#include <libssh/libssh.h>
#include <libssh/server.h>
#include <iostream>
#include <string>
#include <thread>
#include <unordered_map>

#pragma comment(lib, "ssh.lib")

// Example user database
std::unordered_map<std::string, std::string> valid_users = {
    {"user1", "password123"},
    {"admin", "supersecret"}
};

// Check public key authentication
bool check_public_key(ssh_session session, ssh_message message) {
    if (ssh_message_subtype(message) != SSH_AUTH_METHOD_PUBLICKEY)
        return false;

    ssh_key key = ssh_message_auth_pubkey(message);
    if (ssh_userauth_try_publickey(session, ssh_message_auth_user(message), key) == SSH_AUTH_SUCCESS) {
        ssh_message_auth_reply_success(message, 0);
        std::cout << "Public key authentication succeeded\n";
        ssh_message_free(message);
        return true;
    }
    ssh_message_reply_default(message);
    ssh_message_free(message);
    return false;
}

// Check password authentication
bool check_password(ssh_session session, ssh_message message) {
    if (ssh_message_subtype(message) != SSH_AUTH_METHOD_PASSWORD)
        return false;

    std::string user = ssh_message_auth_user(message);
    std::string password = ssh_message_auth_password(message);

    if (valid_users.find(user) != valid_users.end() && valid_users[user] == password) {
        ssh_message_auth_reply_success(message, 0);
        std::cout << "Password authentication succeeded for user: " << user << std::endl;
        ssh_message_free(message);
        return true;
    }

    ssh_message_reply_default(message);
    ssh_message_free(message);
    return false;
}

// Handle authentication
bool authenticate_user(ssh_session session) {
    if (ssh_handle_key_exchange(session) != SSH_OK) {
        std::cerr << "Key exchange failed: " << ssh_get_error(session) << std::endl;
        return false;
    }

    ssh_message message;
    while ((message = ssh_message_get(session)) != nullptr) {
        if (ssh_message_type(message) == SSH_REQUEST_AUTH) {
            if (check_public_key(session, message) || check_password(session, message))
                return true;
        }
        ssh_message_reply_default(message);
        ssh_message_free(message);
    }
    std::cerr << "Authentication failed\n";
    return false;
}

// Handle incoming SSH client
void handle_client(ssh_session session) {
    if (!authenticate_user(session)) {
        ssh_disconnect(session);
        ssh_free(session);
        return;
    }

    ssh_channel channel = ssh_channel_new(session);
    if (ssh_channel_open_session(channel) != SSH_OK) {
        std::cerr << "Failed to open session\n";
        ssh_free(session);
        return;
    }

    char buffer[256];
    while (true) {
        int nbytes = ssh_channel_read(channel, buffer, sizeof(buffer), 0);
        if (nbytes <= 0) break;
        std::cout << "Received: " << std::string(buffer, nbytes) << std::endl;
    }

    ssh_channel_close(channel);
    ssh_channel_free(channel);
    ssh_disconnect(session);
    ssh_free(session);
}

// Main function
int main() {
    ssh_bind sshbind = ssh_bind_new();
    ssh_bind_options_set(sshbind, SSH_BIND_OPTIONS_BINDADDR, "0.0.0.0");
    ssh_bind_options_set(sshbind, SSH_BIND_OPTIONS_BINDPORT, "2222");
    ssh_bind_options_set(sshbind, SSH_BIND_OPTIONS_HOSTKEY, "ssh-rsa");
    ssh_bind_options_set(sshbind, SSH_BIND_OPTIONS_RSAKEY, "ssh_host_rsa_key");

    if (ssh_bind_listen(sshbind) < 0) {
        std::cerr << "Error listening: " << ssh_get_error(sshbind) << std::endl;
        return -1;
    }

    std::cout << "SSH Server running on port 2222...\n";

    while (true) {
        ssh_session session = ssh_new();
        if (ssh_bind_accept(sshbind, session) == SSH_ERROR) {
            std::cerr << "Error accepting connection: " << ssh_get_error(sshbind) << std::endl;
            ssh_free(session);
            continue;
        }

        std::thread(handle_client, session).detach();
    }

    ssh_bind_free(sshbind);
    ssh_finalize();
    return 0;
}