//
//  View+Extension.swift
//  Ecox-new
//
//  Created by Rahul Singh on 15/08/25.
//

import SwiftUI

extension View {
    func inputFieldStyle() -> some View {
        self
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.inputBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.inputBorder, lineWidth: 1)
            )
    }
    
    func textInputStyle() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(.black)
    }
}
