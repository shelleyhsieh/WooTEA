//
//  DrinkMenu.swift
//  WooTEA
//
//  Created by shelley on 2023/2/1.
//

import Foundation

struct DrinkMenu: Equatable {
    let name: String
    let priceM: Int?
    let priceL: Int?
    let iceOnly: Bool
    let description: String?
    let category: String

}

var allDrinks: [DrinkMenu] = []

struct DrinkCategory {
    let name: String
    var menu: [DrinkMenu]
}

// get json decode
struct DrinkData: Codable {
    let records: [Record]
}

struct Record: Codable {
    let id: String
    let fields: Fields
    
    struct Fields: Codable {
        let name: String
        let image: [Image]
        let category: String
        let priceM: Int?
        let priceL: Int?
        let iceOnly: String?
        let description: String?
    }
}

struct Image: Codable {
    let url: URL
}





