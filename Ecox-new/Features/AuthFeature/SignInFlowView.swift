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
