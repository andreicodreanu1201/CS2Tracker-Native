import SwiftUI

struct AssetSpecificationsView: View {
    let asset: WeaponAsset
    @Environment(\.dismiss) var dismiss
    @State private var showingExportAlert = false

    var body: some View {
        ZStack {
            // Fundalul negru specific
            Color(hex: "#0e0e0e").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // --- SECTION 1: VISUAL IDENTIFIER ---
                    ZStack {
                        // Grid subtil pe fundal (ca în HTML)
                        Rectangle()
                            .fill(Color.white.opacity(0.02))
                            .overlay(
                                Image(systemName: "scope")
                                    .font(.system(size: 200))
                                    .foregroundColor(.white.opacity(0.03))
                            )
                        
                        AsyncImage(url: URL(string: asset.imageURL)) { img in
                            img.resizable()
                                .scaledToFit()
                                .padding(40)
                                .shadow(color: Color(hex: asset.rarityColor).opacity(0.3), radius: 20)
                        } placeholder: {
                            ProgressView().tint(.white)
                        }
                    }
                    .frame(height: 320)
                    .background(Color(hex: "#131313"))
                    .border(Color(hex: asset.rarityColor).opacity(0.2), width: 1)
                    
                    // --- SECTION 2: CORE TELEMETRY ---
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text(asset.rarity.uppercased())
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(Color(hex: asset.rarityColor))
                                .tracking(2)
                            Spacer()
                            Text("AUTHENTICITY: VERIFIED")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(Color(hex: "#00e639"))
                        }
                        
                        Text(asset.name.uppercased())
                            .font(.custom("SpaceGrotesk-Bold", size: 28))
                            .foregroundColor(.white)
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text("CURRENT MARKET VAL:")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                            Text("$\(String(format: "%.2f", asset.price))")
                                .font(.custom("SpaceGrotesk-Bold", size: 24))
                                .foregroundColor(Color(hex: "#00e639"))
                        }
                    }
                    .padding(.horizontal)
                    
                    // --- SECTION 3: DETALII TEHNICE (Telemetrie) ---
                    VStack(spacing: 1) {
                        SpecRow(label: "COLLECTION", value: asset.collection)
                        SpecRow(label: "FLOAT VALUE", value: String(format: "%.10f", asset.floatValue))
                        SpecRow(label: "FINISH STYLE", value: "Custom Paint Job")
                        SpecRow(label: "ASSET ID", value: asset.id.uppercased())
                    }
                    .background(Color.white.opacity(0.1))
                    .padding(.horizontal)
                    
                    // --- SECTION 4: MARKET HISTORY (Placeholder vizual din HTML) ---
                    VStack(alignment: .leading, spacing: 10) {
                        Text("MARKET PERFORMANCE (24H)")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        HStack(alignment: .bottom, spacing: 8) {
                            ForEach(0..<10) { _ in
                                Rectangle()
                                    .fill(Color(hex: "#00e639").opacity(Double.random(in: 0.3...1.0)))
                                    .frame(width: 25, height: CGFloat.random(in: 20...60))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#131313"))
                    }
                    
                    // --- SECTION 5: ACTIONS ---
                    Button(action: {
                        generateReport()
                    }) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                            Text("GENERATE TECHNICAL REPORT")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#00e639"))
                        .foregroundColor(.black)
                    }
                    .padding()
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("REPORT GENERATED", isPresented: $showingExportAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The technical specifications for \(asset.name) have been exported to the system archive.")
        }
    }
    
    // Funcție pentru cerința „Generate Report”
    func generateReport() {
        // Aici am putea genera un PDF sau un fișier text
        print("Exporting data: \(asset.name) | Float: \(asset.floatValue)")
        showingExportAlert = true
    }
}

// Rând de specificație stilizat
struct SpecRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(.white)
        }
        .padding()
        .background(Color(hex: "#131313"))
    }
}
