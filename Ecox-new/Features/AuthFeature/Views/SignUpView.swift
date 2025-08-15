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
    @State private var mobileNumber: String = ""
    let onStartOtp: (String) -> Void
    let popOne: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
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
            .background(
                // code goes here
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
    
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
                
                // Mobile Number Field
                inputField(
                    title: "Mobile Number",
                    placeholder: "Enter Mobile Number",
                    text: $mobileNumber
                )
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
        guard !name.isEmpty, !emailID.isEmpty, !mobileNumber.isEmpty else {
            print("Please fill all fields")
            return
        }
        
        // Implement OTP sending logic
        print("Sending OTP to: \(emailID)")
        
        // Navigate to OTP screen
        onStartOtp(mobileNumber)
    }
    
    private func signUpWithGoogle() {
        // Implement Google sign up logic
        print("Sign up with Google")
    }
}
