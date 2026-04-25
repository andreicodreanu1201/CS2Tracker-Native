//
//  RegisterView.swift
//  CS2TacticalTracker
//
//  Created by Andrei Codreanu on 25.04.2026.
//

import SwiftUI


import SwiftUI

struct RegisterView: View {
    @State private var fullName: String = ""
    @State private var operatorID: String = ""
    @State private var accessKey: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "#0e0e0e").ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 10) {
                    Text("ESTABLISH REGISTRY")
                        .font(.custom("SpaceGrotesk-Bold", size: 20))
                        .tracking(3)
                        .foregroundColor(.white)
                    Text("SECURE ENROLLMENT PROTOCOL")
                        .font(.system(size: 10))
                        .opacity(0.5)
                        .foregroundColor(.white)
                }

                VStack(spacing: 25) {
                    CustomInputField(label: "FULL NAME", text: $fullName, placeholder: "Operator Name")
                    CustomInputField(label: "ASSIGNED EMAIL", text: $operatorID, placeholder: "email@domain.com")
                    CustomSecureField(label: "SECURITY KEY", text: $accessKey, placeholder: "••••••••")
                }

                Button(action: { dismiss() }) {
                    Text("CREATE OPERATOR ACCOUNT")
                        .font(.system(size: 12, weight: .bold))
                        .tracking(2)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(hex: "#00e639"))
                        .foregroundColor(.black)
                }
                
                Button("ABORT AND RETURN") { dismiss() }
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
            }
            .padding(30)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    RegisterView()
}
