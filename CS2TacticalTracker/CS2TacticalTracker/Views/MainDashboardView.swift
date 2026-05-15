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
    
    // Itemele pentru Market Alerts (indexul 1, 2, 3 din lista descărcată)
    var alertAssets: [WeaponAsset] {
        guard savedAssets.count > 3 else { return Array(savedAssets.dropFirst().prefix(3)) }
        return Array(savedAssets[1...3])
    }
    
    // Culorile pentru alertele dinamice
    let alertColors: [Color] = [
        Color(hex: "#00e639"),
        Color(hex: "#ff7162"),
        Color(hex: "#ffd709")
    ]

    var body: some View {
        NavigationStack {
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
                                        
                                        Text(savedAssets.first?.rarity.uppercased() ?? "COVERT RIFLE")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(Color(hex: "#00e639"))
                                            .tracking(2)
                                        
                                        Divider().background(Color.white.opacity(0.1))
                                        
                                        // Navigăm direct la detaliile produsului specific
                                        if let firstAsset = savedAssets.first {
                                            NavigationLink(destination: AssetSpecificationsView(asset: firstAsset)) {
                                                Text("VIEW IN DATABASE")
                                                    .font(.system(size: 11, weight: .bold))
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color(hex: "#00e639"))
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                    .padding(20)
                                    .background(Color(hex: "#131313"))
                                }
                            }
                            .padding(.horizontal)

                            // --- MARKET ALERTS SECTION (Date dinamice din DB) ---
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
                                    ForEach(Array(alertAssets.enumerated()), id: \.element.id) { index, asset in
                                        let color = alertColors[index % alertColors.count]
                                        NavigationLink(destination: AssetSpecificationsView(asset: asset)) {
                                            AlertRow(
                                                name: asset.name,
                                                desc: asset.collection,
                                                change: "$\(String(format: "%.2f", asset.price))",
                                                color: color
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
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
            .navigationBarHidden(true)
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
