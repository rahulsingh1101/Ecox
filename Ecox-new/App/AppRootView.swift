import SwiftUI

@main
struct ModularSwiftUIApp: App {
    @StateObject private var router = AppRouter()
    // Swap stub for live when ready:
    private let auth: any AuthClient = AuthClientLive()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(router)
                .environment(\.authClient, auth)
                .task { router.start(with: auth) }
        }
    }
}

struct AppRootView: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.authClient) private var auth

    var body: some View {
        ZStack {
            switch router.phase {
            case .launching:
                EcoxAnimatingView(onAnimationCompleted: {
                    router.animationCompleted()
                })
            case .running(let flow):
                switch flow {
                case .preIntro:
                    PreIntroFlowView {
                        router.markPreIntroSeen()
                        router.go(.intro)
                    }
                case .intro:
                    IntroView(
                        onFinish: {
                            router.markIntroSeen()
                            router.go(.signIn)
                        },
                        onSkip: {
                            router.markIntroSeen()
                            router.go(.signIn)
                        }
                    )
                case .signIn:
                    SignInFlowView(
                        onOtpVerified: { token in
                            Task {
                                await auth.store(token: token)
                                await MainActor.run { router.go(.home) }
                            }
                        },
                        onGoogleSuccess: { token in
                            Task {
                                await auth.store(token: token)
                                await MainActor.run { router.go(.home) }
                            }
                        }
                    )
                case .home:
                    HomeFlowView {
                        Task {
                            await auth.clearToken()
                            await MainActor.run { router.go(.signIn) }
                        }
                    }
                }
            }
        }
        .animation(.easeInOut, value: String(describing: router.phase))
    }
}
