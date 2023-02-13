//
//  DeleteOrder.swift
//  WooTEA
//
//  Created by shelley on 2023/2/13.
//

import Foundation

struct DeleteOrder: Codable {
    var records: [Record]
    
    struct Record: Codable {
        var id: String
        var deleted: Bool
    }
}
