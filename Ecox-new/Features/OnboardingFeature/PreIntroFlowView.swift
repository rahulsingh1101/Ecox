import SwiftUI

public struct PreIntroFlowView: View {
    public init(onBegin: @escaping () -> Void) { self.onBegin = onBegin }
    private let onBegin: () -> Void

    public var body: some View {
        VStack(spacing: 16) {
            Text("Welcome").font(.largeTitle).bold()
            Text("Tap Begin to get started.")
                .foregroundStyle(.secondary)
            Button("Begin", action: onBegin).buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
