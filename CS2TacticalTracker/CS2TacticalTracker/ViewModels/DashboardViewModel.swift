//
//  DashboardViewModel.swift
//  CS2TacticalTracker
//
//  Created by Andrei Codreanu on 25.04.2026.
//

import Foundation
import SwiftData
import SwiftUI
internal import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var alertMessage: String?
    @Published var isSyncing: Bool = false
    
    // Funcția care aduce datele din API și le salvează în SwiftData
    func syncAssets(modelContext: ModelContext) async {
        print("--- SYNC ATTEMPT STARTED ---") // DEBUG
        isLoading = true
        
        let urlString = "https://bymykel.com/CSGO-API/api/en/skins.json"
        guard let url = URL(string: urlString) else {
            print("ERROR: Invalid URL")
            return
        }
        
        do {
            // Încearcă acest URL de pe GitHub (este mai stabil pentru request-uri din simulator)
            let urlString = "https://raw.githubusercontent.com/ByMykel/CSGO-API/main/public/api/en/skins.json"
            guard let url = URL(string: urlString) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            // Păstrăm header-ele de browser pentru siguranță
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
            
            print("--- INITIATING NETWORK COMMAND TO GITHUB ---")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("--- SERVER RESPONSE CODE: \(httpResponse.statusCode) ---")
                
                if httpResponse.statusCode == 200 {
                    let decoder = JSONDecoder()
                    // Decodăm lista de skin-uri
                    let apiSkins = try decoder.decode([SkinAPIResponse].self, from: data)
                    
                    print("--- SUCCESS: DECODED \(apiSkins.count) ASSETS ---")
                    
                    // Ștergem toate datele existente înainte de a insera cele noi
                    let existingAssets = try modelContext.fetch(FetchDescriptor<WeaponAsset>())
                    for old in existingAssets {
                        modelContext.delete(old)
                    }
                    print("--- DATABASE CLEARED: \(existingAssets.count) OLD ASSETS REMOVED ---")
                    
                    // Amestecăm TOATE skinurile și extragem 200 random
                    let shuffledSkins = apiSkins.shuffled()
                    let selectedSkins = Array(shuffledSkins.prefix(200))
                    
                    print("--- SELECTED \(selectedSkins.count) RANDOM ASSETS ---")
                    
                    // Salvăm datele
                    for skin in selectedSkins {
                        // Generăm un preț estimativ bazat pe raritate
                        let randomPrice: Double = {
                            switch skin.rarity?.name {
                            case "Covert": return Double.random(in: 150...1500)
                            case "Classified": return Double.random(in: 50...149)
                            case "Restricted": return Double.random(in: 10...49)
                            default: return Double.random(in: 0.5...9.99)
                            }
                        }()

                        let newAsset = WeaponAsset(
                            id: skin.id,
                            name: skin.name,
                            rarity: skin.rarity?.name ?? "Unknown",
                            imageURL: skin.image,
                            collection: skin.collections?.first?.name ?? "Global Archive",
                            floatValue: Double.random(in: 0.001...0.08),
                            price: randomPrice,
                            rarityColor: skin.rarity?.color ?? "#808080"
                        )
                        modelContext.insert(newAsset)
                    }
                    try modelContext.save()
                    print("--- DATABASE UPDATED ---")
                }
            }
            
            await MainActor.run { self.isLoading = false }
            
        } catch {
            print("--- DECODING ERROR: \(error) ---")
            await MainActor.run { self.isLoading = false }
        }
        
        // Structuri suport pentru a "înțelege" API-ul ByMykel
        struct SkinAPIResponse: Codable {
            let id: String
            let name: String
            let image: String
            let rarity: RarityAPI?
            let collections: [CollectionAPI]?
            
            // Folosim CodingKeys pentru a fi siguri de nume
            enum CodingKeys: String, CodingKey {
                case id, name, image, rarity, collections
            }
        }
        
        struct RarityAPI: Codable {
            let name: String
            let id: String
            let color: String
        }
        
        struct CollectionAPI: Codable {
            let name: String
            let id: String
        }
    }
}
