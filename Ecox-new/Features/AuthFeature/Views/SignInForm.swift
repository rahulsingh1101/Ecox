//
//  SignInForm.swift
//  Ecox-new
//
//  Created by Rahul Singh on 15/08/25.
//

import SwiftUI

struct SignInForm: View {
    let onStartOtp: (String) -> Void
    let onSignupClick: () -> Void
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
            Divider().padding(.vertical, 8)
            Button("Sign-up") {
                onSignupClick()
            }
        }
        .padding()
    }
}
