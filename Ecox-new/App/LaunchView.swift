import SwiftUI

struct LaunchView: View {
    let onAnimationCompleted: () -> Void

    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            VStack(spacing: 12) {
                Image(systemName: "sparkles").font(.system(size: 56, weight: .bold))
                Text("ModularSwiftUIApp").font(.system(.largeTitle, design: .rounded)).bold()
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) { scale = 1.0 }
            withAnimation(.easeIn(duration: 0.25)) { opacity = 1.0 }

            // Fire completion after the longest animation (0.7s here)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                onAnimationCompleted()
            }
        }
    }
}
