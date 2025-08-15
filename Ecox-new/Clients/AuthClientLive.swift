import Foundation

public final class AuthClientLive: AuthClient {
    private let keychain: KeychainClient
    public init(keychain: KeychainClient = KeychainClientLive()) { self.keychain = keychain }

    public func hasValidToken() async -> Bool {
        (try? keychain.readToken()) != nil
    }

    public func store(token: AuthToken) async {
        try? keychain.writeToken(token.raw)
    }

    public func clearToken() async {
        try? keychain.deleteToken()
    }

    public func handleGoogleCallback(_ url: URL) async -> AuthToken? {
        // Parse + exchange for server token
        // Return token on success
        return AuthToken("demo-token")
    }
}
