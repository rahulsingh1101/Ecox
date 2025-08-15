//
//  SignupView.swift
//  Ecox-new
//
//  Created by Rahul Singh on 15/08/25.
//

import SwiftUI

struct SignUpView: View {
    // MARK: - State Variables
    @State private var name: String = ""
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var isSecureTextEntry: Bool = true
    @State private var navigateToOTP: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: - Header Illustration
                    headerIllustrationView
                        .padding(.top, 60)
                        .padding(.bottom, 40)
                    
                    // MARK: - Sign Up Form
                    signUpFormView
                        .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color.white)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationBarHidden(true)
            .background(
//                NavigationLink(
//                    destination: OTPVerificationView(email: emailID),
//                    isActive: $navigateToOTP
//                ) {
//                    EmptyView()
//                }
//                .hidden()
            )
        }
    }
    
    // MARK: - Header Illustration View
    private var headerIllustrationView: some View {
        Image("signup_image")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 220)
            .clipped()
    }
    
    // MARK: - Sign Up Form View
    private var signUpFormView: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Title
            Text("Sign Up")
                .font(.custom("SF Pro Display", size: 28))
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            // Form Fields
            VStack(spacing: 16) {
                // Name Field
                inputField(
                    title: "Name",
                    placeholder: "Enter Name",
                    text: $name
                )
                
                // Email Field
                inputField(
                    title: "Email ID",
                    placeholder: "Enter Email ID",
                    text: $emailID
                )
                
                // Password Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                    
                    HStack {
                        if isSecureTextEntry {
                            SecureField("Enter Password", text: $password)
                                .textInputStyle()
                        } else {
                            TextField("Enter Password", text: $password)
                                .textInputStyle()
                        }
                        
                        Button(action: {
                            isSecureTextEntry.toggle()
                        }) {
                            Image(systemName: isSecureTextEntry ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                        }
                    }
                    .inputFieldStyle()
                }
            }
            
            // Verification Message
            VStack(alignment: .leading, spacing: 4) {
                Text("We have send a 4 digit verification code")
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryText)
                
                Text("to your email 123.......gmail.com")
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryText)
            }
            .padding(.top, 8)
            
            // Send OTP Button
            Button(action: {
                // Handle send OTP action
                sendOTP()
            }) {
                Text("Send Otp")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.primaryGreen)
                    .cornerRadius(25)
            }
            .padding(.top, 16)
            
            // Or Divider
            HStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                Text("Or")
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryText)
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.vertical, 20)
            
            // Google Sign Up Button
            Button(action: {
                // Handle Google sign up
                signUpWithGoogle()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "globe")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                    
                    Text("Sign Up with Google")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(25)
            }
        }
    }
    
    // MARK: - Input Field Helper
    private func inputField(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            
            TextField(placeholder, text: text)
                .textInputStyle()
                .inputFieldStyle()
        }
    }
    
    // MARK: - Actions
    private func sendOTP() {
        // Validate form fields
        guard !name.isEmpty, !emailID.isEmpty, !password.isEmpty else {
            print("Please fill all fields")
            return
        }
        
        // Implement OTP sending logic
        print("Sending OTP to: \(emailID)")
        
        // Navigate to OTP screen
        navigateToOTP = true
    }
    
    private func signUpWithGoogle() {
        // Implement Google sign up logic
        print("Sign up with Google")
    }
}
