//
//  LoginView.swift
//  CS2TacticalTracker
//
//  Created by Andrei Codreanu on 25.04.2026.
//

import SwiftUI

struct LoginView: View {
    @State private var operatorID: String = ""
    @State private var accessKey : String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "#0e0e0e").ignoresSafeArea()
            
            VStack(spacing: 0){
                
                Color.clear.frame(height: 80)
                
                VStack(spacing:48){
                    
                    VStack(spacing: 24) {
                        Rectangle()
                            .stroke(Color(hex: "#00e639"), lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .overlay(Text("CS2").font(.headline).foregroundColor(Color(hex: "#00e639")))
                        
                        VStack(spacing: 8){
                            Text("TACTICAL COMMAND CENTER")
                                .font(.custom("SpaceGrotesk-Bold", size: 14))
                                .tracking(4)
                                .foregroundColor(.white)
                            Text("AUTHENTICATION REQUIRED")
                                .font(.system(size: 10, weight: .bold))
                                .opacity(0.5)
                                .foregroundColor(.white)
                        }
                    }
                    
                    VStack(spacing: 32){
                        CustomInputField(label: "OPERATOR ID", text: $operatorID, placeholder:"name@command.int")
                        CustomInputField(label: "ACCESS KEY", text: $accessKey, placeholder: "*******")
                    }
                    
                    VStack(spacing: 24) {
                        Button(action: {isLoggedIn = true}) {
                            Text("INITIALIZE CONNECTION")
                                .font(.system(size: 12, weight: .bold))
                                .tracking(2)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color(hex: "#00e639"))
                                .foregroundColor(.black)
                        }
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("NEW OPERATOR? ESTABLISH REGISTRY")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(hex: "#00e639"))
                        }
                    }
                    
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}


#Preview {
    LoginView()
}
