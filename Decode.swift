//
//  Decode.swift
//  WooTEA
//
//  Created by shelley on 2023/2/3.
//

import Foundation

func decodeJsonData<T: Decodable>(_ data: Data) -> T {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError()
    }
}
