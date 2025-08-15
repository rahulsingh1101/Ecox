import SwiftUI

// MARK: - AuthClient environment key

private struct AuthClientKey: EnvironmentKey {
    static let defaultValue: any AuthClient = AuthClientStub()
}

public extension EnvironmentValues {
    var authClient: any AuthClient {
        get { self[AuthClientKey.self] }
        set { self[AuthClientKey.self] = newValue }
    }
}
