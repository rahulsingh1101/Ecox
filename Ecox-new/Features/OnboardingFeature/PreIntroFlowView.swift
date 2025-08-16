import SwiftUI

struct PreIntroFlowView: View {
    init(onBegin: @escaping () -> Void) { self.onBegin = onBegin }
    private let onBegin: () -> Void

    // MARK: - Metrics (derived from your mock; scale-safe)
    private enum M {
        static let ecoGreen = Color(red: 85/255, green: 183/255, blue: 107/255)

        // Final curve geometry as fractions of screen height (from your 393×932 mock)
        static let edgeYFactor: CGFloat    = 630.5 / 932.0   // left/right edge Y where the green stops
        static let controlYFactor: CGFloat = 700.5 / 932.0   // deeper control point to form the bulge

        // Start (off-screen) overshoots so both curve + button begin below the display
        static let startEdgeOvershoot: CGFloat    = 120
        static let startControlOvershoot: CGFloat = 160

        // Button layout
        static let buttonWidthFactor: CGFloat = 0.86
        static let buttonHeight: CGFloat = 45
        static let buttonCorner: CGFloat = 22

        // Keep a FIXED gap between the curve’s lowest point and the top of the button.
        // Gap derived from mock: ~154 on a 932-pt screen → 0.165 factor.
        static let buttonGapFactor: CGFloat = 154.0 / 932.0

        // ECOX label placement (center Y from mock)
        static let titleCenterYFactor: CGFloat = 466.0 / 932.0
    }

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var progress: CGFloat = 0     // 0 → all green; 1 → final resting shape
    @State private var printedOnce = false

    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width
            let H = geo.size.height

            // Off-screen start
            let edgeY0 = H + M.startEdgeOvershoot
            let ctlY0  = H + M.startControlOvershoot

            // Final targets (scaled to screen)
            let edgeY1 = M.edgeYFactor * H
            let ctlY1  = M.controlYFactor * H

            // Interpolate (both ride up together)
            let edgeY = edgeY0 + (edgeY1 - edgeY0) * progress
            let ctlY  = ctlY0  + (ctlY1  - ctlY0)  * progress

            // Lowest midpoint of the bulge (for a symmetric cubic Bézier)
            let bulgeY = (edgeY + 3 * ctlY) / 4

            // Button geometry tied to the curve’s bulge with a fixed gap
            let gap = M.buttonGapFactor * H
            let buttonTopY = bulgeY + gap
            let buttonCenterY = buttonTopY + M.buttonHeight / 2
            let buttonWidth = M.buttonWidthFactor * W

            ZStack(alignment: .top) {
                Color.white.ignoresSafeArea()

                // Green panel with animated bulging bottom
                BulgedPanel(edgeY: edgeY, controlY: ctlY)
                    .fill(M.ecoGreen)
                    .ignoresSafeArea()

                // ECOX title (stays put)
                Text("ECOX")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .position(x: W/2, y: M.titleCenterYFactor * H)

                // Get Started button that rides the curve with a constant gap
                Button(action: onBegin) {
                    Text("Get Started")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: buttonWidth, height: M.buttonHeight)
                .background(M.ecoGreen)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: M.buttonCorner, style: .continuous))
                .shadow(radius: 8, y: 2)
                .position(x: W/2, y: buttonCenterY)
                .opacity(opacityFor(progress))        // fades in as it rises
            }
            .onAppear {
                if reduceMotion {
                    progress = 1
                } else {
                    withAnimation(.spring(response: 0.9, dampingFraction: 0.9)) {
                        progress = 1
                    }
                }
            }
            .onChange(of: progress) { newValue in
                // Fire exactly once when we reach (or effectively reach) the end
                if !printedOnce && newValue >= 0.999 {
                    printedOnce = true
                    print("animation completed pre intro flow view")
                }
            }
        }
    }

    private func opacityFor(_ p: CGFloat) -> Double {
        // ease the button in over the early portion of the rise
        let t = max(0, min(1, (p - 0.15) / 0.6))
        return Double(t)
    }
}

/// The green top panel; its bottom edge is a symmetric cubic Bézier bulge.
/// `edgeY` is the Y of the left/right ends; `controlY` is deeper to create the bulge.
private struct BulgedPanel: Shape {
    var edgeY: CGFloat
    var controlY: CGFloat

    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(edgeY, controlY) }
        set {
            edgeY = newValue.first
            controlY = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: .zero)
        p.addLine(to: CGPoint(x: rect.width, y: 0))
        p.addLine(to: CGPoint(x: rect.width, y: edgeY))
        p.addCurve(
            to: CGPoint(x: 0, y: edgeY),
            control1: CGPoint(x: rect.width * 0.65, y: controlY),
            control2: CGPoint(x: rect.width * 0.35, y: controlY)
        )
        p.closeSubpath()
        return p
    }
}
