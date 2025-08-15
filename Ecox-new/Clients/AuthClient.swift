import Foundation

public struct AuthToken: Equatable, Sendable {
    public let raw: String
    public init(_ raw: String) { self.raw = raw }
}

public protocol AuthClient: Sendable {
    func hasValidToken() async -> Bool
    func store(token: AuthToken) async
    func clearToken() async
    func handleGoogleCallback(_ url: URL) async -> AuthToken?
}

// Default stub used unless you inject a live client in MyApp.
public struct AuthClientStub: AuthClient {
    public init() {}
    public func hasValidToken() async -> Bool { false }
    public func store(token: AuthToken) async {}
    public func clearToken() async {}
    public func handleGoogleCallback(_ url: URL) async -> AuthToken? { AuthToken("demo-token") }
}
