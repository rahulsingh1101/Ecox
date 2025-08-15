import SwiftUI

struct EcoxAnimatingView: View {
    let onAnimationCompleted: () -> Void
    // MARK: – Tunables
    private let startDiameter: CGFloat = 270
    private let animDuration: Double = 0.70   // must match the .easeOut duration
    private let overfill: CGFloat = 1.05      // make sure we cover safe areas fully

    // MARK: – State
    @State private var reveal = false
    @State private var cycle = 0              // increments each time we play

    var body: some View {
        GeometryReader { proxy in
            let size   = proxy.size
            let insets = proxy.safeAreaInsets

            // Center-based reveal (as you requested)
            let center = CGPoint(x: size.width / 2, y: size.height / 2)

            // Coverage in extended space (safe areas included)
            let extW = size.width  + insets.leading + insets.trailing
            let extH = size.height + insets.top     + insets.bottom
            let centerExt = CGPoint(x: center.x + insets.leading,
                                    y: center.y + insets.top)

            let corners: [CGPoint] = [
                .init(x: 0, y: 0),
                .init(x: extW, y: 0),
                .init(x: 0, y: extH),
                .init(x: extW, y: extH)
            ]
            let maxCorner = corners.map { hypot($0.x - centerExt.x, $0.y - centerExt.y) }.max() ?? 0
            let targetScale = (maxCorner * 2 / startDiameter) * overfill

            ZStack {
                Color.white.ignoresSafeArea()   // frame 1

                // Full-screen green + fixed logo
                ZStack {
                    ecoGreen.ignoresSafeArea()
                    Text("ECOX")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .kerning(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .mask(
                    Circle()
                        .frame(width: startDiameter, height: startDiameter)
                        .position(x: center.x, y: center.y)
                        .scaleEffect(reveal ? targetScale : 1)
                )
                // keep the animation definition in one place
                .animation(.easeOut(duration: animDuration), value: reveal)
            }
            .task {
                // initial play after a small delay so you can see frame 1
                try? await Task.sleep(nanoseconds: 250_000_000)
                playOnce()
            }
            .onTapGesture {
                // tap to replay during testing
                reveal = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    playOnce()
                }
            }
        }
    }

    private var ecoGreen: Color { Color(red: 0.33, green: 0.71, blue: 0.46) }

    /// Plays the reveal and prints exactly once when it completes.
    private func playOnce() {
        cycle += 1
        let myCycle = cycle

        // trigger the animation
        reveal = true

        // fire completion once per cycle after the known duration
        Task {
            // small buffer for rendering variance
            let buffer: Double = 0.03
            try? await Task.sleep(nanoseconds: UInt64((animDuration + buffer) * 1_000_000_000))
            if myCycle == cycle && reveal {
                print("animation completed")
                onAnimationCompleted()
            }
        }
    }
}
