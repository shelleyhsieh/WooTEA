//
//  DrinkMenu.swift
//  WooTEA
//
//  Created by shelley on 2023/2/1.
//

import Foundation

struct DrinkData: Codable {
    let records: [Record]
}

struct Record: Codable {
    let id: String
    let fields: Fields
    
    static let categories = { (drinks: [Record]) -> [String] in
        var allCategories = [String]()
        for i in 0..<drinks.count {
            let categoryBtn = drinks[i].fields.category
            allCategories.append(categoryBtn)
        }
        return allCategories
    }
    
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





