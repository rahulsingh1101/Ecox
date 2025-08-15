import Foundation

public protocol KeychainClient: Sendable {
    func readToken() throws -> String?
    func writeToken(_ token: String) throws
    func deleteToken() throws
}

// Minimal no-op live implementation placeholder.
// Replace with proper Keychain logic (SecItemAdd/CopyMatching/Update/Delete).
public struct KeychainClientLive: KeychainClient {
    public init() {}
    private static var inMemory: String?

    public func readToken() throws -> String? { Self.inMemory }
    public func writeToken(_ token: String) throws { Self.inMemory = token }
    public func deleteToken() throws { Self.inMemory = nil }
}
