//
//  WeaponryDatabaseView.swift
//  CS2TacticalTracker
//
//  Created by Andrei Codreanu on 26.04.2026.
//

import SwiftUI
import SwiftData

struct WeaponryDatabaseView: View {
    //Accessing local database
    @Environment(\.modelContext) private var modelContext
    
    //Query to bring all the weapons, sorted alphabetically
    @Query(sort: \WeaponAsset.name) var assets: [WeaponAsset]
    
    @State private var searchText = ""
    
    var body: some View{
        NavigationStack{
            ZStack{
                //Black background
                Color(hex: "#0e0e0e").ignoresSafeArea()
                
                VStack(spacing: 0){
                    //Search bar
                    VStack(alignment: .leading, spacing: 5){
                        Text("SEARCH")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: "#00e639"))
                        
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("SEARCH ASSET DATABASE...", text: $searchText)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.05))
                        .border(Color(hex: "#00e639").opacity(0.3), width: 1)
                    }
                    .padding()
                    
                    //List of assets
                    ScrollView{
                        LazyVStack(spacing:2){
                            ForEach(filteredAssets) { asset in
                            //Show more details when pressing
                                NavigationLink(destination: AssetSpecificationsView(asset: asset)) {
                                    AssetRow(asset: asset)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .navigationTitle("DATABASE")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    var filteredAssets: [WeaponAsset] {
        if searchText.isEmpty{
            return assets
        } else {
            return assets.filter{ $0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
}

struct AssetRow: View {
    let asset: WeaponAsset
    
    var body: some View{
        HStack(spacing: 15){
            AsyncImage(url: URL(string: asset.imageURL)) { img in
                img.resizable().scaledToFit()
            } placeholder: {
                ProgressView().tint(.gray)
            }
            .frame(width: 80, height: 50)
            .background(Color.black.opacity(0.2))
            
            VStack(alignment: .leading, spacing: 4){
                Text(asset.name.uppercased())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack{
                    Text(asset.rarity)
                        .font(.system(size: 8, weight: .black))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("$\(String(format: "%.2f", asset.price))")
                        .font(.system(size: 12,weight: .bold))
                        .foregroundColor(Color(hex: "#00e639"))
                }
            }
        }
        
        .padding()
        .background(Color(hex: "#131313"))
        //Show a colored border based on rarity
        
        .overlay(
            Rectangle()
                .frame(width: 4)
                .foregroundColor(Color(hex: asset.rarityColor)),
            alignment: .leading
        )
    }
}

