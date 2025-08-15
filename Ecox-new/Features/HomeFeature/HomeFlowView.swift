import SwiftUI

public struct HomeFlowView: View {
    public init(onSignOut: @escaping () -> Void) { self.onSignOut = onSignOut }
    private let onSignOut: () -> Void
    @State private var path = NavigationPath()

    public var body: some View {
        NavigationStack(path: $path) {
            List {
                NavigationLink("Details") { Text("Details") }
                Button("Sign out", action: onSignOut)
            }
            .navigationTitle("Home")
        }
    }
}
