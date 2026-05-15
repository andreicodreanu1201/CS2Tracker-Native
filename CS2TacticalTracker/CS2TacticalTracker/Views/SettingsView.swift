//
//  SettingsView.swift
//  CS2TacticalTracker
//
//  Created by Andrei Codreanu on 09.05.2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    
    @State private var password = ""
    @State private var isUpdating = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color(hex: "#111111").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // HEADER
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "terminal")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#00e639"))
                        Text("Situation Report // Overview")
                            .font(.system(size: 10, weight: .bold))
                            .tracking(2)
                            .textCase(.uppercase)
                            .foregroundColor(Color(hex: "#00e639"))
                    }
                    Spacer()
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#00e639"))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .padding(.top, 56) // Similar to pt-14
                .background(Color.black.opacity(0.5))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.white.opacity(0.05)),
                    alignment: .bottom
                )
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // MAIN TITLE
                        HStack(alignment: .top, spacing: 16) {
                            Text("SEC_LVL_04")
                                .font(.system(size: 10, weight: .bold))
                                .tracking(2)
                                .foregroundColor(Color(hex: "#00e639"))
                                .padding(.top, 8)
                            
                            Text("System\nConfiguration")
                                .font(.system(size: 30, weight: .black))
                                .tracking(2)
                                .textCase(.uppercase)
                                .foregroundColor(.white)
                                .lineSpacing(4)
                        }
                        .padding(.top, 16)
                        
                        // SECTION: COMM-LINK PROTOCOL (Password)
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 8) {
                                Image(systemName: "network")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "#00e639"))
                                Text("Security Protocol")
                                    .font(.system(size: 11, weight: .bold))
                                    .tracking(2)
                                    .textCase(.uppercase)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color(hex: "#00e639"))
                                    .frame(width: 2)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Operator Access Key")
                                        .font(.system(size: 9, weight: .bold))
                                        .tracking(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(.gray)
                                    
                                    HStack {
                                        SecureField("Enter new access key...", text: $password)
                                            .font(.system(size: 12, design: .monospaced))
                                            .foregroundColor(.white)
                                            .autocapitalization(.none)
                                        
                                        Spacer()
                                        
                                        Button(action: handleUpdatePassword) {
                                            if isUpdating {
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#00e639")))
                                                    .scaleEffect(0.8)
                                            } else {
                                                Image(systemName: "checkmark.circle")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(Color(hex: "#00e639"))
                                            }
                                        }
                                        .disabled(isUpdating)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 12)
                                    .background(Color(hex: "#0a0a0a"))
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                                    
                                    Button(action: handleUpdatePassword) {
                                        Text(isUpdating ? "UPDATING..." : "CONFIRM NEW KEY")
                                            .font(.system(size: 10, weight: .bold))
                                            .tracking(2)
                                            .textCase(.uppercase)
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color(hex: "#00e639"))
                                    }
                                    .disabled(isUpdating)
                                    
                                    Text("Update primary channel key for mission-critical access.")
                                        .font(.system(size: 10))
                                        .italic()
                                        .foregroundColor(Color(hex: "#666666"))
                                }
                                .padding(16)
                                .background(Color(hex: "#161616"))
                            }
                        }
                        
                        // SECTION: DEPLOYMENT REGION
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 8) {
                                Image(systemName: "globe")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "#eab308"))
                                Text("Deployment Region")
                                    .font(.system(size: 11, weight: .bold))
                                    .tracking(2)
                                    .textCase(.uppercase)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color(hex: "#eab308"))
                                    .frame(width: 2)
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Active Trading Sector")
                                        .font(.system(size: 9, weight: .bold))
                                        .tracking(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(.gray)
                                    
                                    HStack {
                                        Text("EUROPE - CORE SECTOR")
                                            .font(.system(size: 12, weight: .bold))
                                            .tracking(2)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "waveform.path.ecg")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color(hex: "#eab308"))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 12)
                                    .background(Color(hex: "#0a0a0a"))
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                                    
                                    HStack(spacing: 8) {
                                        StatBox(label: "Latency", value: "14ms", valueColor: Color(hex: "#00e639"))
                                        StatBox(label: "Uptime", value: "99.98%", valueColor: Color(hex: "#00e639"))
                                        StatBox(label: "Nodes", value: "128", valueColor: .white)
                                    }
                                }
                                .padding(16)
                                .background(Color(hex: "#161616"))
                            }
                        }
                        
                        // SECTION: SYSTEM MAINTENANCE
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 8) {
                                Image(systemName: "wrench.and.screwdriver")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "#ef4444"))
                                Text("System Maintenance")
                                    .font(.system(size: 11, weight: .bold))
                                    .tracking(2)
                                    .textCase(.uppercase)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color(hex: "#ef4444"))
                                    .frame(width: 2)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    // WIPE CACHE
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("LOCAL STORAGE INTEGRITY")
                                            .font(.system(size: 11, weight: .bold))
                                            .tracking(2)
                                            .foregroundColor(.white)
                                        Text("Purge all session logs, temporary caches, and local telemetry data.")
                                            .font(.system(size: 10))
                                            .lineSpacing(2)
                                            .foregroundColor(.gray)
                                            .padding(.bottom, 8)
                                        
                                        Button(action: { /* Add Wipe Cache Action here */ }) {
                                            Text("Wipe Local Cache")
                                                .font(.system(size: 10, weight: .bold))
                                                .tracking(2)
                                                .textCase(.uppercase)
                                                .foregroundColor(Color(hex: "#eab308"))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(Color(hex: "#202020"))
                                        }
                                    }
                                    .padding(16)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(Color.white.opacity(0.05)),
                                        alignment: .bottom
                                    )
                                    
                                    // TERMINATION
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("CRITICAL TERMINATION")
                                            .font(.system(size: 11, weight: .bold))
                                            .tracking(2)
                                            .foregroundColor(Color(hex: "#ef4444"))
                                        Text("Sever current operator link and encrypt local terminal access.")
                                            .font(.system(size: 10))
                                            .lineSpacing(2)
                                            .foregroundColor(.gray)
                                            .padding(.bottom, 8)
                                        
                                        Button(action: handleSignOut) {
                                            Text("Disconnect Operator")
                                                .font(.system(size: 10, weight: .black))
                                                .tracking(2)
                                                .textCase(.uppercase)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 12)
                                                .background(Color(hex: "#ff6b6b"))
                                        }
                                    }
                                    .padding(16)
                                    
                                    // FIRMWARE
                                    HStack {
                                        Text("Firmware: V4.2.0-STABLE")
                                            .font(.system(size: 9, design: .monospaced))
                                            .tracking(2)
                                            .textCase(.uppercase)
                                            .foregroundColor(Color(hex: "#666666"))
                                        Spacer()
                                        Text("SYNCED")
                                            .font(.system(size: 9, design: .monospaced))
                                            .tracking(2)
                                            .foregroundColor(Color(hex: "#00e639"))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                                    .padding(.top, 8)
                                }
                                .background(Color(hex: "#161616"))
                            }
                        }
                        
                        // FOOTER
                        HStack(spacing: 8) {
                            Text("Local Data Persistence Active")
                                .font(.system(size: 9, design: .monospaced))
                                .tracking(3)
                                .textCase(.uppercase)
                                .foregroundColor(Color(hex: "#666666"))
                            
                            Circle()
                                .fill(Color(hex: "#00e639"))
                                .frame(width: 6, height: 6)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                        
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func handleUpdatePassword() {
        guard password.count >= 6 else {
            alertTitle = "INVALID INPUT"
            alertMessage = "Password must be at least 6 characters."
            showAlert = true
            return
        }
        
        isUpdating = true
        Task {
            do {
                try await AuthService.shared.updatePassword(newPassword: password)
                await MainActor.run {
                    alertTitle = "SUCCESS"
                    alertMessage = "Operator access key updated successfully."
                    password = ""
                    isUpdating = false
                    showAlert = true
                }
            } catch {
                await MainActor.run {
                    alertTitle = "UPDATE FAILED"
                    alertMessage = error.localizedDescription
                    isUpdating = false
                    showAlert = true
                }
            }
        }
    }
    
    private func handleSignOut() {
        Task {
            do {
                try await AuthService.shared.signOut()
                await MainActor.run {
                    isLoggedIn = false
                }
            } catch {
                await MainActor.run {
                    alertTitle = "TERMINATION FAILED"
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}

struct StatBox: View {
    let label: String
    let value: String
    let valueColor: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .tracking(2)
                .textCase(.uppercase)
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(valueColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(hex: "#202020"))
    }
}
