import SwiftUI

@MainActor
final class AppRouter: ObservableObject {
    enum AppFlow: Equatable { case preIntro, intro, signIn, home }
    enum AppPhase: Equatable { case launching, running(AppFlow) }

    @Published var phase: AppPhase = .launching

    @AppStorage("hasSeenPreIntro") private var hasSeenPreIntro = false
    @AppStorage("hasSeenIntro")    private var hasSeenIntro = false

    @Published private(set) var hasValidToken = false

    func start(with auth: any AuthClient) {
        Task {
            let ok = await auth.hasValidToken()
            await MainActor.run {
                self.hasValidToken = ok
                self.phase = .running(self.initialFlow(tokenOK: ok))
            }
            // Optional: guarantee splash is visible a minimum time:
            try? await Task.sleep(nanoseconds: 500_000_000)
        }
    }

    private func initialFlow(tokenOK: Bool) -> AppFlow {
        if tokenOK { return .home }
        if !hasSeenPreIntro { return .preIntro }
        if !hasSeenIntro { return .intro }
        return .signIn
    }

    func go(_ f: AppFlow) { phase = .running(f) }

    func markPreIntroSeen() { hasSeenPreIntro = true }
    func markIntroSeen()    { hasSeenIntro = true }
}
