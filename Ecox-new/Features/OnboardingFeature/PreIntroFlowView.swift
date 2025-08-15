import SwiftUI

struct PreIntroFlowView: View {
    public init(onBegin: @escaping () -> Void) { self.onBegin = onBegin }
    private let onBegin: () -> Void
    private enum M {
        static let ecoGreen = Color(red: 85/255, green: 183/255, blue: 107/255)

        // Bottom curve metrics (in % of screen height from the mock 393×932)
        static let edgeYFactor: CGFloat    = 630.5 / 932.0   // left/right edge Y of the green area
        static let controlYFactor: CGFloat = 700.5 / 932.0   // control point to get center Y ≈ 654

        // ECOX label center Y (exactly mid-height in the mock)
        static let titleCenterYFactor: CGFloat = 466.0 / 932.0

        // Button metrics from the mock
        static let buttonWidthFactor: CGFloat  = 337.0 / 393.0
        static let buttonHeightFactor: CGFloat = 50.0  / 932.0
        static let buttonCenterYFactor: CGFloat = 879.0 / 932.0
    }
    
    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width
            let H = geo.size.height
            let s = W / 383.0   // scale based on mock width

            ZStack {
                Color.white.ignoresSafeArea()

                // Top curved green shape
                CurvedHeader(edgeYFactor: M.edgeYFactor, controlYFactor: M.controlYFactor)
                    .fill(M.ecoGreen)
                    .ignoresSafeArea()

                // ECOX title
                Text("ECOX")
                    .font(.system(size: 42 * s, weight: .heavy, design: .default))
                    .foregroundColor(.white)
                    .position(x: W / 2, y: H * M.titleCenterYFactor)

                // Get Started button
                RoundedRectangle(cornerRadius: 20 * s, style: .continuous)
                    .fill(M.ecoGreen)
                    .frame(width: W * M.buttonWidthFactor,
                           height: H * M.buttonHeightFactor)
                    .overlay(
                        Text("Get Started")
                            .font(.system(size: 14 * s, weight: .semibold))
                            .foregroundColor(.white)
                    )
                    .position(x: W / 2, y: H * M.buttonCenterYFactor)
                    .onTapGesture {
                        onBegin()
                    }
            }
        }
    }
}

// MARK: - Curved header shape (rectangle with a symmetric quadratic bulge)
struct CurvedHeader: Shape {
    let edgeYFactor: CGFloat
    let controlYFactor: CGFloat

    func path(in rect: CGRect) -> Path {
        let yEdge = rect.height * edgeYFactor        // ~630.5 on 932h
        let yCtrl = rect.height * controlYFactor     // ~677.5 on 932h

        var p = Path()
        p.move(to: .zero)
        p.addLine(to: CGPoint(x: rect.maxX, y: 0))
        p.addLine(to: CGPoint(x: rect.maxX, y: yEdge))
        // symmetric curve left → right with center bulging downward
        p.addQuadCurve(to: CGPoint(x: 0, y: yEdge),
                       control: CGPoint(x: rect.midX, y: yCtrl))
        p.closeSubpath()
        return p
    }
}
