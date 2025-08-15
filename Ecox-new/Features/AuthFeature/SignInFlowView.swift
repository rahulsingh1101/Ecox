//
//  SignInForm.swift
//  Ecox-new
//
//  Created by Rahul Singh on 15/08/25.
//

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
            LoginViaOTPView(
                onStartOtp: { phone in path.append(Route.otp(phone)) },
                onSignupClick: {
                    path.append(Route.signup)
                },
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
                    OtpView(
                        phone: phone,
                        onVerify: {code in
                            onOtpVerified(AuthToken(code))
                        }, popOne: {
                            path.removeLast()
                        }
                    )
                case .signup:
                    SignUpView(
                        onStartOtp: {phone in
                            path.append(Route.otp(phone))
                        },
                        popOne: {
                            path.removeLast()
                        }
                    )
                }
            }
            .navigationTitle("Sign In")
        }
    }

    enum Route: Hashable {
        case otp(String)
        case signup
    }
}
