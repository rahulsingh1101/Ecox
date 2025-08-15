import SwiftUI

public struct IntroFlowView: View {
    public init(onFinish: @escaping () -> Void, onSkip: @escaping () -> Void) {
        self.onFinish = onFinish
        self.onSkip = onSkip
    }
    private let onFinish: () -> Void
    private let onSkip: () -> Void

    @State private var path = NavigationPath()

    public var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 16) {
                Text("Intro Slide 1").font(.title)
                Button("Next") { path.append(1) }
            }
            .navigationDestination(for: Int.self) { step in
                if step == 1 {
                    VStack(spacing: 16) {
                        Text("Intro Slide 2")
                        HStack {
                            Button("Skip", action: onSkip)
                            Button("Finish", action: onFinish).buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Skip", action: onSkip) } }
            .navigationTitle("Intro")
        }
    }
}
