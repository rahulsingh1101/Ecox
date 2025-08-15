import SwiftUI

struct EcoxAnimatingView: View {
    // Size of the starting circle in frame 1
    let onAnimationCompleted: () -> Void
    private let startDiameter: CGFloat = 270

    @State private var reveal = false

    var body: some View {
        GeometryReader { proxy in
            let size   = proxy.size
            let insets = proxy.safeAreaInsets

            // Center of the mask: EXACT middle of the screen (your requirement)
            let centerLocal = CGPoint(x: size.width / 2, y: size.height / 2)

            // Coverage math in EXTENDED space (includes safe areas)
            let extendedW = size.width  + insets.leading + insets.trailing
            let extendedH = size.height + insets.top     + insets.bottom
            let centerExt = CGPoint(x: centerLocal.x + insets.leading,
                                    y: centerLocal.y + insets.top)

            // Farthest corner distance from the center
            let corners: [CGPoint] = [
                .init(x: 0, y: 0),
                .init(x: extendedW, y: 0),
                .init(x: 0, y: extendedH),
                .init(x: extendedW, y: extendedH)
            ]
            let maxCorner = corners.map { hypot($0.x - centerExt.x, $0.y - centerExt.y) }.max() ?? 0

            // Scale so radius >= farthest corner (+5% cushion for absolute coverage)
            let targetScale = (maxCorner * 2 / startDiameter) * 1.05

            ZStack {
                Color.white.ignoresSafeArea()   // frame 1 background

                // Full-screen green layer + fixed logo (no move/scale)
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
                        .position(x: centerLocal.x, y: centerLocal.y) // center-based reveal
                        .scaleEffect(reveal ? targetScale : 1, anchor: .center)
                        .onAnimationCompleted(for: reveal ? targetScale : 1) {
                            print("animation completed")
                        }
                )
                .animation(.easeOut(duration: 0.70), value: reveal) // smooth radial reveal
            }
            .task {
                try? await Task.sleep(nanoseconds: 250_000_000)
                reveal = true
            }
            .onTapGesture {
                // replay while testing
                reveal = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { reveal = true }
            }
        }
    }

    private var ecoGreen: Color { Color(red: 0.33, green: 0.71, blue: 0.46) }
}

// MARK: - Animation completion helper
private struct AnimationCompletionObserver<Value: VectorArithmetic>: AnimatableModifier {
    var targetValue: Value
    var onComplete: () -> Void

    var animatableData: Value {
        didSet {
            // Use tolerance because floats interpolate
            let diff = animatableData - targetValue
            if diff.magnitudeSquared < 0.0001 {
                // Copy the closure so the escaping block doesn't capture `self`
                let completion = onComplete
                DispatchQueue.main.async { completion() }   // prints: "animation completed"
            }
        }
    }

    init(observedValue: Value, onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        self.animatableData = observedValue
        self.targetValue = observedValue
    }

    func body(content: Content) -> some View { content }
}

private extension View {
    func onAnimationCompleted<Value: VectorArithmetic>(
        for value: Value,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(AnimationCompletionObserver(observedValue: value, onComplete: action))
    }
}
