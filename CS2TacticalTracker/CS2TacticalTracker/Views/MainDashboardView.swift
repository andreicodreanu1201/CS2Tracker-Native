import SwiftUI
import SwiftData

struct MainDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    // Query pentru a număra elementele salvate local (Cerința Offline)
    @Query var savedAssets: [WeaponAsset]
    
    var totalMarketValue: Double{
        savedAssets.reduce(0) { $0 + $1.price}
    }
    
    @StateObject private var viewModel = DashboardViewModel()
    
    // Luăm regiunea salvată local (Cerința Settings)
    @AppStorage("deployment_region") private var region: String = "EUROPE - CORE"

    var body: some View {
        ZStack {
            Color(hex: "#0e0e0e").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // --- TOP BAR ---
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "terminal")
                        Text("SITUATION REPORT // OVERVIEW")
                            .font(.custom("SpaceGrotesk-Bold", size: 14))
                    }
                    .foregroundColor(Color(hex: "#00e639"))
                    
                    Spacer()
                    
                    Image(systemName: "sensor")
                        .foregroundColor(Color(hex: "#00e639"))
                }
                .padding()
                .background(Color.black.opacity(0.5))

                ScrollView {
                    VStack(spacing: 20) {
                        
                        // --- SUMMARY SECTION (Cele 3 carduri din HTML) ---
                        HStack(spacing: 1) {
                            StatCard(label: "TOTAL ITEMS", value: "\(savedAssets.count)", color: Color(hex: "#00e639"))
                            StatCard(
                                        label: "MARKET VALUE", 
                                        value: "$\(String(format: "%.2f", totalMarketValue))", 
                                        color: Color(hex: "#ffd709")
                                    )
                            StatCard(label: "REGION", value: region.prefix(10).uppercased(), color: Color(hex: "#ff7162"))
                        }
                        .padding(.horizontal, 10)

                        // --- PRIORITY ASSET SECTION ---
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("PRIORITY ASSET // ITEM OF THE DAY")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("ID: 8842-PX-01")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(hex: "#00e639"))
                            }
                            
                            // Cardul principal (M4A1-S Printstream logic)
                            VStack(spacing: 0) {
                                ZStack {
                                    Color.white.opacity(0.05)
                                    // Folosim o imagine de placeholder sau prima din listă
                                    if let firstAsset = savedAssets.first {
                                        AsyncImage(url: URL(string: firstAsset.imageURL)) { img in
                                            img.resizable().scaledToFit()
                                        } placeholder: {
                                            ProgressView().tint(.white)
                                        }
                                        .padding(40)
                                    } else {
                                        Image(systemName: "shield.fill") 
                                            .font(.largeTitle)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(height: 250)
                                
                                // Detalii Asset
                                VStack(alignment: .leading, spacing: 15) {
                                    Text(savedAssets.first?.name.uppercased() ?? "INITIALIZING ASSET...")
                                        .font(.custom("SpaceGrotesk-Bold", size: 24))
                                        .foregroundColor(.white)
                                    
                                    Text("COVERT RIFLE")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Color(hex: "#00e639"))
                                        .tracking(2)
                                    
                                    Divider().background(Color.white.opacity(0.1))
                                    
                                    // Butonul verde din imagine
                                    Button(action: {}) {
                                        Text("VIEW IN DATABASE")
                                            .font(.system(size: 12, weight: .bold))
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color(hex: "#00e639"))
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding(20)
                                .background(Color(hex: "#131313"))
                            }
                        }
                        .padding(.horizontal)
                        
                        // Status Log la final (Footer-ul din HTML)
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Circle().fill(Color(hex: "#00e639")).frame(width: 6, height: 6)
                                Text("SYSTEM STATUS: NOMINAL")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color(hex: "#00e639"))
                            }
                            Text("> SYNCHRONIZING ASSET DATABASE... [COMPLETE]")
                                .font(.system(size: 8, design: .monospaced))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.black.opacity(0.3))
                    }
                    .padding(.vertical)
                }
            }
        }
        .task {
            // Pornim sincronizarea datelor (Cerința API)
            await viewModel.syncAssets(modelContext: modelContext)
        }
    }
}

// Structura pentru cardurile de statistici
struct StatCard: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.gray)
            Text(value)
                .font(.custom("SpaceGrotesk-Bold", size: 18))
                .foregroundColor(.white)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#131313"))
        .overlay(Rectangle().frame(width: 2).foregroundColor(color), alignment: .leading)
    }
}
