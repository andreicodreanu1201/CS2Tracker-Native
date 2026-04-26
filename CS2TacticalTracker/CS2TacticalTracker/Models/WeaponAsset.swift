//
//  WeaponAsset.swift
//  CS2TacticalTracker
//
//  Created by Andrei Codreanu on 25.04.2026.
//

import Foundation
import SwiftData

@Model
class WeaponAsset {
    @Attribute(.unique) var id: String
    var name: String
    var rarity: String
    var imageURL: String
    var collection: String
    var floatValue: Double
    var isFavorite: Bool = false
    var price: Double = 0.0
    // Stocăm codul de culoare HEX primit direct din API (ex: "#eb4b4b")
    var rarityColor: String

    init(id: String, name: String, rarity: String, imageURL: String, collection: String, floatValue: Double, price: Double, rarityColor: String) {
        self.id = id
        self.name = name
        self.rarity = rarity
        self.imageURL = imageURL
        self.collection = collection
        self.floatValue = floatValue
        self.price = price
        self.rarityColor = rarityColor
    }
}
