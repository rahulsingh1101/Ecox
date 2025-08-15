//
//  OtpView.swift
//  Ecox-new
//
//  Created by Rahul Singh on 15/08/25.
//

import SwiftUI

struct OtpView: View {
    // MARK: - State Variables
    @State private var otpDigits: [String] = ["", "", "", ""]
    @State private var isError: Bool = false
    @State private var focusedIndex: Int = 0

    let phone: String
    let onVerify: (String) -> Void
    let popOne: () -> Void
    
    // Email from previous screen (would be passed as parameter)
    @State private var email: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar
            navigationBar
            
            ScrollView {
                VStack(spacing: 32) {
                    // MARK: - Header Illustration
                    headerIllustrationView
                        .padding(.top, 40)
                    
                    // MARK: - Content
                    contentView
                        .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HStack {
            Button(action: {
                popOne()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .background(Color.white)
    }
    
    // MARK: - Header Illustration View
    private var headerIllustrationView: some View {
        Image("otp_image")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 200)
    }
    
    // MARK: - Content View
    private var contentView: some View {
        VStack(spacing: 24) {
            // Title and Description
            VStack(spacing: 12) {
                Text("Enter Otp Verification Code")
                    .font(.custom("SF Pro Display", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 4) {
                    Text("We have send a 4 digit verification code")
                        .font(.system(size: 16))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Text("to your email \(maskedEmail)")
                        .font(.system(size: 16))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            
            // OTP Input Fields
            otpInputView
                .padding(.top, 16)
            
            // Error Message (if error state)
            if isError {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.errorRed)
                    
                    Text("Oops! Incorrect Code")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.errorRed)
                }
                .padding(.top, 8)
            }
            
            // Resend OTP
            HStack(spacing: 4) {
                Text("Didn't Received OTP ?")
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryText)
                
                Button(action: {
                    resendOTP()
                }) {
                    Text("RESEND OTP")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primaryGreen)
                }
            }
            .padding(.top, 16)
            
            // Verify Code Button
            Button(action: {
                verifyOTP()
            }) {
                Text("Verify Code")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.primaryGreen)
                    .cornerRadius(25)
            }
            .padding(.top, 24)
        }
    }
    
    // MARK: - OTP Input View
    private var otpInputView: some View {
        HStack(spacing: 16) {
            ForEach(0..<4, id: \.self) { index in
                OTPDigitField(
                    text: $otpDigits[index],
                    isError: isError,
                    isFocused: focusedIndex == index,
                    onTextChange: { newValue in
                        handleOTPInput(at: index, value: newValue)
                    },
                    onFocusChange: { isFocused in
                        if isFocused {
                            focusedIndex = index
                        }
                    },
                    onBackspacePressed: {
                        handleBackspace(at: index)
                    }
                )
            }
        }
    }
    
    // MARK: - Computed Properties
    private var maskedEmail: String {
        let components = email.components(separatedBy: "@")
        guard components.count == 2 else { return email }
        
        let username = components[0]
        let domain = components[1]
        
        if username.count > 3 {
            let prefix = String(username.prefix(3))
            return "\(prefix).......@\(domain)"
        }
        return email
    }
    
    private var otpCode: String {
        return otpDigits.joined()
    }
    
    // MARK: - Actions
    private func handleOTPInput(at index: Int, value: String) {
        // Clear error state when user starts typing
        if isError {
            isError = false
        }
        
        // Handle input - only allow single digit numbers
        let filteredValue = value.filter { $0.isNumber }
        
        if filteredValue.count <= 1 {
            otpDigits[index] = filteredValue
            
            // Forward navigation: Move to next field if current field is filled
            if !filteredValue.isEmpty && index < 3 {
                focusedIndex = index + 1
            }
        }
    }
    
    private func handleBackspace(at index: Int) {
        if !otpDigits[index].isEmpty {
            // If current field has content, just clear it
            otpDigits[index] = ""
        } else if index > 0 {
            // If current field is empty, move to previous field and clear it
            otpDigits[index - 1] = ""
            focusedIndex = index - 1
        }
    }
    
    private func verifyOTP() {
        let enteredOTP = otpCode
        
        // Check if all fields are filled
        guard enteredOTP.count == 4 else {
            print("Please enter complete OTP")
            return
        }
        
        // Simulate OTP verification
        // For demo purposes, "1234" is incorrect, everything else is correct
        if enteredOTP == "1234" {
            // Show error state for incorrect code
            withAnimation(.easeInOut(duration: 0.3)) {
                isError = true
            }
            
            // Clear OTP fields after showing error
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                clearOTPFields()
            }
        } else {
            // All other codes are correct - navigate to next screen
            navigateToNextScreen()
        }
    }
    
    private func resendOTP() {
        // Implement resend OTP logic
        print("Resending OTP to: \(email)")
        
        // Clear current OTP and error state
        clearOTPFields()
        isError = false
        
        // Show confirmation (you can add a toast or alert here)
    }
    
    private func clearOTPFields() {
        otpDigits = ["", "", "", ""]
        focusedIndex = 0
    }
    
    private func navigateToNextScreen() {
        // This would navigate to the next screen in your app
        print("OTP Verified Successfully! Navigating to next screen...")
        // For now, just dismiss back to signup
        print("OTP entered ::\(otpCode)")
        onVerify(otpCode)
    }
}

struct OTPDigitField: View {
    @Binding var text: String
    let isError: Bool
    let isFocused: Bool
    let onTextChange: (String) -> Void
    let onFocusChange: (Bool) -> Void
    let onBackspacePressed: () -> Void
    
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        TextField("", text: $text)
            .font(.system(size: 24, weight: .semibold))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .frame(width: 60, height: 60)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(12)
            .keyboardType(.numberPad)
            .focused($isFieldFocused)
            .onChange(of: text) { oldValue, newValue in
                // Only allow single digit numbers
                let filtered = newValue.filter { $0.isNumber }
                if filtered.count > 1 {
                    text = String(filtered.last ?? Character(""))
                } else {
                    text = filtered
                }
                onTextChange(text)
            }
            .onChange(of: isFieldFocused) { oldValue, newValue in
                onFocusChange(newValue)
            }
            .onChange(of: isFocused) { oldValue, newValue in
                if newValue {
                    isFieldFocused = true
                }
            }
            .onTapGesture {
                isFieldFocused = true
            }
            .onKeyPress(.delete) {
                if text.isEmpty {
                    // Call the callback to move to previous field
                    onBackspacePressed()
                    return .handled
                }
                return .ignored
            }
    }
    
    private var borderColor: Color {
        if isError {
            return .errorRed
        } else if isFocused || !text.isEmpty {
            return .primaryGreen
        } else {
            return .inputBorder
        }
    }
}
