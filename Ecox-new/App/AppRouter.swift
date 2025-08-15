import SwiftUI

@MainActor
final class AppRouter: ObservableObject {
    enum AppFlow: Equatable { case preIntro, intro, signIn, home }
    enum AppPhase: Equatable { case launching, running(AppFlow) }

    @Published var phase: AppPhase = .launching
    
    private var bootstrapTarget: AppFlow? = nil
    private var launchAnimationDone = false

    @AppStorage("hasSeenPreIntro") private var hasSeenPreIntro = false
    @AppStorage("hasSeenIntro")    private var hasSeenIntro = false
    @Published private(set) var hasValidToken = false

    func start(with auth: any AuthClient) {
        Task {
            let ok = await auth.hasValidToken()
            await MainActor.run {
                self.hasValidToken = ok
                self.bootstrapTarget = self.initialFlow(tokenOK: ok)
                self.tryFinishLaunching()
            }
        }
    }

    // Called by the LaunchView when its animation completes
    func animationCompleted() {
        launchAnimationDone = true
        tryFinishLaunching()
    }

    private func tryFinishLaunching() {
        guard launchAnimationDone, let next = bootstrapTarget else { return }
        phase = .running(next)
        // clear the gate so we don’t re-enter
        bootstrapTarget = nil
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
