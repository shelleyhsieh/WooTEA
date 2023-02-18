//
//  MenuController.swift
//  WooTEA
//
//  Created by shelley on 2023/2/4.
//

import Foundation
import UIKit

public let apiKey = "keyy7QrfYj3mhT9pM"

class MenuController {
    static let shared = MenuController()
    
    static let orderUpdateNotification = Notification.Name("MenuController.orderUpdate")
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdateNotification, object: nil)
        }
    }
    
    
    // 下載menu  https://api.airtable.com/v0/{baseId}/{tableIdOrName}/{recordId}
    // https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Menu
    func fetchData(urlStr: String, completion: @escaping (Result<[Record], Error>) -> Void) {
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "Get"
        request.setValue("Bearer keyy7QrfYj3mhT9pM", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let drinkMenu = try decoder.decode(DrinkData.self, from: data)
                
                    completion(.success(drinkMenu.records))
                    print("✅ download menu")
                    
                } catch  {
                    completion(.failure(error))
                }
            }else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // 下載圖片
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }

    //重新抓取訂單
    func fetchOrderData(urlStr:String, completion: @escaping(Result< [OrderData.Record], Error >) -> Void) { //[OrderData.Record]
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)

        request.setValue("Bearer keyy7QrfYj3mhT9pM", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let renewOrder = try decoder.decode(OrderData.self, from: data)
                    print("✏️訂單明細\(renewOrder.records)") //.records
                    completion(.success(renewOrder.records)) //.records
                } catch  {
                    print("解碼失敗")
                    completion(.failure(error))
                }
            } else if let error = error {
                print("下載失敗")
                completion(.failure(error))
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP response status code: \(httpResponse.statusCode)")
            }
        }.resume()
        
    }
    
    
}
