//
//  OrderData.swift
//  WooTEA
//
//  Created by shelley on 2023/2/1.
//

import Foundation

// 上傳，JsonEncode
struct OrderData: Codable {
    var records: [Record]

    struct Record: Codable {
        var id: String?
        var fields: Fields
        
        struct Fields: Codable {
            var buyer: String?
            var drinkName: String
            var size: String
            var sugar: String
            var temperature: String
            var toppings: String
            var pricePerCup: Int
            var numberOfCups: Int
            var createdID: String
        }
        
    }
}


// 記錄
struct Order: Codable {
    var orders: [OrderData.Record]
    
    init(orders: [OrderData.Record] = []) {
        self.orders = orders
    }
    
}

//// 下載
//struct OrderList: Codable {
//    var records: [Record]
//    
//    struct Record: Codable {
//        var id: String
//        var fields: OrderData.Fields
//    }
//}
