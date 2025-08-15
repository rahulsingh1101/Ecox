import SwiftUI

public struct SignInFlowView: View {
    public init(onOtpVerified: @escaping (AuthToken) -> Void,
                onGoogleSuccess: @escaping (AuthToken) -> Void) {
        self.onOtpVerified = onOtpVerified
        self.onGoogleSuccess = onGoogleSuccess
    }
    private let onOtpVerified: (AuthToken) -> Void
    private let onGoogleSuccess: (AuthToken) -> Void

    @Environment(\.authClient) private var auth
    @State private var path = NavigationPath()

    public var body: some View {
        NavigationStack(path: $path) {
            SignInForm(
                onStartOtp: { phone in path.append(Route.otp(phone)) },
                onGoogle: { url in
                    Task {
                        if let token = await auth.handleGoogleCallback(url) {
                            onGoogleSuccess(token)
                        }
                    }
                }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .otp(let phone):
                    OtpView(phone: phone) { code in
                        // TODO: verify with backend
                        onOtpVerified(AuthToken("server-token"))
                    }
                }
            }
            .navigationTitle("Sign In")
        }
    }

    enum Route: Hashable { case otp(String) }
}

struct SignInForm: View {
    let onStartOtp: (String) -> Void
    let onGoogle: (URL) -> Void

    @State private var phone = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Sign In").font(.largeTitle).bold()
            TextField("Phone or Email", text: $phone).textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password).textFieldStyle(.roundedBorder)

            Button("Continue") { onStartOtp(phone) }
                .buttonStyle(.borderedProminent)

            Divider().padding(.vertical, 8)
            Button("Continue with Google") {
                onGoogle(URL(string: "app://google-callback")!)
            }
        }
        .padding()
    }
}

struct OtpView: View {
    let phone: String
    let onVerify: (String) -> Void
    @State private var code = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("OTP Verification").font(.title2).bold()
            Text("Sent to \(phone)")
            TextField("Enter 6-digit code", text: $code)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            Button("Verify") { onVerify(code) }
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
