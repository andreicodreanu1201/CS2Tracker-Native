//
//  UIComponents.swift
//  CS2TacticalTracker
//
//  Created by Andrei Codreanu on 25.04.2026.
//

import SwiftUI

// Această componentă randează câmpurile de text conform DESIGN.md
struct CustomInputField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.custom("Inter-Bold", size: 10))
                .tracking(1.5)
                .foregroundColor(Color(hex: "#acabaa"))
            
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Color.white.opacity(0.2)))
                .foregroundColor(.white)
                .font(.custom("Inter-Medium", size: 14))
                .padding(.vertical, 12)
                .overlay(Rectangle().frame(height: 1).foregroundColor(Color(hex: "#484848")), alignment: .bottom)
        }
    }
}

struct CustomSecureField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.custom("Inter-Bold", size: 10))
                .tracking(1.5)
                .foregroundColor(Color(hex: "#acabaa"))
            
            SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(Color.white.opacity(0.2)))
                .foregroundColor(.white)
                .font(.custom("Inter-Medium", size: 14))
                .padding(.vertical, 12)
                .overlay(Rectangle().frame(height: 1).foregroundColor(Color(hex: "#484848")), alignment: .bottom)
        }
    }
}
