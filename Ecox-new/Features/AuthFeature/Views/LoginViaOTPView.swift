//
//  SignInForm.swift
//  Ecox-new
//
//  Created by Rahul Singh on 15/08/25.
//

import SwiftUI

struct LoginViaOTPView: View {
    // Reference metrics from the design @430×932
    private enum M {
        static let hInset: CGFloat = 27
        static let illustrationTop: CGFloat = 75
        static let illustrationHeight: CGFloat = 252
        static let gapAfterIllustration: CGFloat = 23
        static let gapTitleToLabel: CGFloat = 22
        static let gapLabelToField: CGFloat = 14
        static let fieldHeight: CGFloat = 40
        static let gapFieldToSend: CGFloat = 24
        static let sendHeight: CGFloat = 40
        static let gapSendToOrTop: CGFloat = 15
        static let orLinesGap: CGFloat = 16
        static let googleHeight: CGFloat = 40
        static let gapGoogleToSignup: CGFloat = 12
        static let signupHeight: CGFloat = 40
        static let fieldCorner: CGFloat = 8
        static let ctaCorner: CGFloat = 22
    }
    
    @State private var phone: String = ""
    let onStartOtp: (String) -> Void
    let onSignupClick: () -> Void
    let onGoogle: (URL) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                // Illustration
                Image("login_illustration") // ← placeholder; add your asset
                    .resizable()
                    .scaledToFit()
                    .frame(height: M.illustrationHeight)
                    .padding(.top, M.illustrationTop)
                    .padding(.bottom, M.gapAfterIllustration)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Title
                Text("Login via OTP")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, M.hInset)
                
                Spacer().frame(height: M.gapTitleToLabel)
                
                // Label
                Text("Mobile Number")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.black.opacity(0.75))
                    .padding(.horizontal, M.hInset)
                
                Spacer().frame(height: M.gapLabelToField)
                
                // Text Field (outlined)
                ZStack {
                    RoundedRectangle(cornerRadius: M.fieldCorner)
                        .stroke(Color(white: 0.88), lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: M.fieldCorner).fill(Color.white))
                    HStack {
                        TextField("", text: $phone, prompt: Text("Enter Mobile Number")
                            .foregroundColor(Color.gray.opacity(0.9))
                        )
                        .keyboardType(.phonePad)
                        .font(.system(size: 16))
                        .padding(.horizontal, 16)
                    }
                }
                .frame(height: M.fieldHeight)
                .padding(.horizontal, M.hInset)
                
                Spacer().frame(height: M.gapFieldToSend)
                
                // Send OTP button
                Button(action: {onStartOtp(phone)}) {
                    Text("Send Otp")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: M.sendHeight)
                .background(Color(red: 0.25, green: 0.73, blue: 0.44)) // the green in mock
                .clipShape(RoundedRectangle(cornerRadius: M.ctaCorner))
                .padding(.horizontal, M.hInset)
                
                Spacer().frame(height: M.gapSendToOrTop)
                
                // OR separator (two thin lines with "Or" centered)
                HStack(spacing: 10) {
                    DividerLine()
                    Text("Or")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color.gray.opacity(0.8))
                    DividerLine()
                }
                .padding(.horizontal, M.hInset)
                
                // the second line sits M.orLinesGap below the first
                Spacer().frame(height: M.orLinesGap)
                
                // Google button (outlined)
                Button(action: {onGoogle(URL(string: "https://google.com")!)}) {
                    HStack(spacing: 12) {
                        // Placeholder Google "G" mark
                        Circle().fill(Color.clear).frame(width: 20, height: 20)
                            .overlay(Text("G").font(.system(size: 16, weight: .bold)).foregroundColor(.black.opacity(0.8)))
                        Spacer()
                        Text("Login with Google")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black.opacity(0.75))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: M.googleHeight)
                    .overlay(RoundedRectangle(cornerRadius: M.ctaCorner)
                        .stroke(Color(white: 0.80), lineWidth: 1))
                }
                .padding(.horizontal, M.hInset)
                
                Spacer().frame(height: M.gapGoogleToSignup)
                
                // Sign-up pill
                HStack(spacing: 4) {
                    Spacer()
                    Text("New User ?")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.gray.opacity(0.9))
                    Text("Sign Up")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(red: 0.25, green: 0.73, blue: 0.44))
                        .onTapGesture {
                            onSignupClick()
                        }
                    Spacer()
                }
                .frame(height: M.signupHeight)
                .background(Color(white: 0.95))
                .clipShape(RoundedRectangle(cornerRadius: M.ctaCorner))
                .padding(.horizontal, M.hInset)
                
                Spacer(minLength: 24) // bottom breathing room
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private struct DividerLine: View {
        var body: some View {
            Rectangle()
                .fill(Color(white: 0.86))
                .frame(height: 1)
        }
    }
}
