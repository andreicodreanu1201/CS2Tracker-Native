import SwiftUI
import SwiftData

struct MainDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var savedAssets: [WeaponAsset]
    @StateObject private var viewModel = DashboardViewModel()
    @AppStorage("deployment_region") private var region: String = "EUROPE - CORE"

    // Calcul dinamic pentru Market Value
    var totalMarketValue: Double {
        savedAssets.reduce(0) { $0 + $1.price }
    }
    
    var goToDatabase: () -> Void

    var body: some View {
        ZStack {
            Color(hex: "#0e0e0e").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // --- TOP APP BAR ---
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
                        
                        // --- SUMMARY SECTION (Inspirat din secțiunea grid din HTML) ---
                        HStack(spacing: 1) {
                            StatCard(label: "TOTAL ITEMS", value: "\(savedAssets.count)", trend: "+12 THIS WEEK", trendColor: Color(hex: "#00e639"))
                            StatCard(label: "MARKET VALUE", value: "$\(String(format: "%.2f", totalMarketValue))", trend: "LIVE FEED ACTIVE", trendColor: Color(hex: "#ffd709"))
                            StatCard(label: "REGION", value: region.uppercased(), trend: "3 ACTION REQ", trendColor: Color(hex: "#ff7162"))
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
                            
                            VStack(spacing: 0) {
                                ZStack {
                                    Color.white.opacity(0.05)
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
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text(savedAssets.first?.name.uppercased() ?? "INITIALIZING...")
                                        .font(.custom("SpaceGrotesk-Bold", size: 22))
                                        .foregroundColor(.white)
                                    
                                    Text("COVERT RIFLE")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Color(hex: "#00e639"))
                                        .tracking(2)
                                    
                                    Divider().background(Color.white.opacity(0.1))
                                    
                                    Button(action: {goToDatabase()}) {
                                        Text("VIEW IN DATABASE")
                                            .font(.system(size: 11, weight: .bold))
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

                        // --- MARKET ALERTS SECTION (Nou adăugată din HTML) ---
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("MARKET ALERTS")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                // Varianta explicită: Button(action: label:)
                                Button {
                                    Task {
                                        await viewModel.syncAssets(modelContext: modelContext)
                                    }
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(hex: "#00e639"))
                                        .rotationEffect(.degrees(viewModel.isSyncing ? 360 : 0))
                                }
                                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: viewModel.isSyncing)
                            }
                            
                            VStack(spacing: 1) {
                                AlertRow(name: "Karambit | Doppler", desc: "Phase 4 / Factory New", change: "+$42.50", color: Color(hex: "#00e639"))
                                AlertRow(name: "AWP | Dragon Lore", desc: "Field-Tested", change: "-$112.00", color: Color(hex: "#ff7162"))
                                AlertRow(name: "Glove Case", desc: "Bulk Supply (x500)", change: "+0.04%", color: Color(hex: "#ffd709"))
                            }
                        }
                        .padding(.horizontal)

                        // --- SYSTEM FOOTER ---
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
            await viewModel.syncAssets(modelContext: modelContext)
        }
    }
}

// Sub-componentă pentru rândurile de alerte
struct AlertRow: View {
    let name: String
    let desc: String
    let change: String
    let color: Color
    
    var body: some View {
        HStack {
            Rectangle().frame(width: 3, height: 30).foregroundColor(color)
            VStack(alignment: .leading) {
                Text(name).font(.system(size: 11, weight: .bold)).foregroundColor(.white)
                Text(desc).font(.system(size: 9)).foregroundColor(.gray)
            }
            Spacer()
            Text(change).font(.system(size: 11, weight: .bold)).foregroundColor(color)
        }
        .padding()
        .background(Color(hex: "#131313"))
    }
}

// Sub-componentă actualizată pentru cardurile de statistici
struct StatCard: View {
    let label: String
    let value: String
    let trend: String
    let trendColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.gray)
            Text(value)
                .font(.custom("SpaceGrotesk-Bold", size: 18))
                .foregroundColor(.white)
            Text(trend)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(trendColor)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#131313"))
        .overlay(Rectangle().frame(width: 2).foregroundColor(trendColor), alignment: .leading)
    }
}
