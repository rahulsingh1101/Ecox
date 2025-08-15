//
//  OtpView.swift
//  Ecox-new
//
//  Created by Rahul Singh on 15/08/25.
//

import SwiftUI

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
