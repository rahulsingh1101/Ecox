import SwiftUI

// MARK: - Data Model

fileprivate struct IntroPage {
    let imageName: String
    let title: String
    let text: String
}

// MARK: - Main Onboarding View

struct IntroView: View {
    public init(onFinish: @escaping () -> Void, onSkip: @escaping () -> Void) {
        self.onFinish = onFinish
        self.onSkip = onSkip
    }
    
    private let onFinish: () -> Void
    private let onSkip: () -> Void
    @State private var path = NavigationPath()

    @State private var pageIndex = 0

    private let pages: [IntroPage] = [
        .init(
            imageName: "intro1",
            title: "Introduction",
            text: "Gorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
        ),
        .init(
            imageName: "intro2",
            title: "Introduction",
            text: "Gorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
        ),
        .init(
            imageName: "intro3",
            title: "Introduction",
            text: "Gorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
        )
    ]

    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geo in
                ZStack {
                    Color(red: 141/255, green: 243/255, blue: 164/255)
                        .ignoresSafeArea()

                    decorativeShapes(in: geo.size)

                    VStack(spacing: 24) {
                        Spacer().frame(height: geo.safeAreaInsets.top + 20)

                        Image(pages[pageIndex].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: geo.size.height * 0.40)

                        VStack(alignment: .leading, spacing: 12) {
                            Text(pages[pageIndex].title)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                            Text(pages[pageIndex].text)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 16)

                        Spacer()

                        HStack {
                            // Skip or Back
                            if pageIndex == 0 {
                                Button("Skip") {
                                    withAnimation {
                                        onSkip()
                                    }
                                }
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            } else {
                                Button {
                                    withAnimation { pageIndex -= 1 }
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.black)
                                        .frame(width: 40, height: 40)
                                        .background(Color.black.opacity(0.1))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }

                            Spacer()

                            // Forward or Done
                            Button {
                                withAnimation {
                                    if pageIndex < pages.count - 1 {
                                        pageIndex += 1
                                    } else {
                                        onFinish()
                                    }
                                }
                            } label: {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, geo.safeAreaInsets.bottom + 16)
                    }
                }
            }
        }
    }
    
    // MARK: - Decorative Shapes
    
    @ViewBuilder
    private func decorativeShapes(in size: CGSize) -> some View {
        // Adjust these offsets/sizes exactly to your design mockups:
        // Triangle (dark green)
        Path { p in
            p.move(to: CGPoint(x: size.width * 0.15, y: size.height * 0.05))
            p.addLine(to: CGPoint(x: size.width * 0.25, y: size.height * 0.15))
            p.addLine(to: CGPoint(x: size.width * 0.10, y: size.height * 0.20))
            p.closeSubpath()
        }
        .fill(Color(red: 57/255, green: 206/255, blue: 81/255))
        
        // Semi-circle arc (light)
        Circle()
            .trim(from: 0.0, to: 0.25)
            .rotation(Angle(degrees: -45))
            .stroke(lineWidth: 20)
            .frame(width: 120, height: 120)
            .foregroundColor(Color(red: 183/255, green: 255/255, blue: 183/255))
            .offset(x: size.width * 0.75, y: size.height * 0.10)
        
        // Grey ring
        Circle()
            .stroke(Color.gray.opacity(0.5), lineWidth: 12)
            .frame(width: 60, height: 60)
            .offset(x: -30, y: size.height * 0.50)
        
        // Black dots
        Group {
            Circle().frame(width: 12, height: 12).foregroundColor(.black)
            Circle().frame(width: 12, height: 12).foregroundColor(.black)
        }
        .offset(x: size.width * 0.80, y: size.height * 0.50)
        .offset(x: -50, y: -200)
    }
}
