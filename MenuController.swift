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
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let drinkMenu = try decoder.decode(DrinkData.self, from: data)
                    completion(.success(drinkMenu.records))
                    print("成功印出菜單\(drinkMenu.records)")
                } catch  {
                    completion(.failure(error))
                }
            }else if let error = error {
                completion(.failure(error))
                print("🚫ERROR \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // 下載圖片
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
                print("drink image\(image)")
            } else {
                completion(nil)
            }
        }.resume()
    }
    
//    // 上傳資料 https://api.airtable.com/v0/{baseId}/{tableIdOrName}
//    // https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Order
//
//    func uploadData(urlStr: String, data: OrderData) {
//        let url = URL(string: urlStr)
//        var request = URLRequest(url: url!)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//
//        let encoder = JSONEncoder()
//
//        request.httpBody = try? encoder.encode(confirmOrder)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                do {
//                    let decoder = JSONDecoder()
//                    let order = try decoder.decode(OrderData.self, from: data)
//                    let content = String(data: data, encoding: .utf8)
//                    print(order)
//                    print("✏️\(content ?? "")")
//                } catch {
//                    print("😡\(error.localizedDescription)")
//
//                }
//            }
//        }.resume()
//
//    }

    //重新抓取訂單
    func fetchOrderData(urlStr:String, completion: @escaping(Result< [OrderData.Record], Error >) -> Void) {
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)

        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let renewOrder = try decoder.decode([OrderData.Record].self, from: data)
                    print(renewOrder)
                    completion(.success(renewOrder.self))
                } catch  {
                    print("🥲 解碼失敗 \(error.localizedDescription)")
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
    
    // 刪除訂單 https://api.airtable.com/v0/{baseId}/{tableIdOrName}/{recordId}
    // https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Order/createdID
    func deleteOrderData(urlStr: String) {
        
        let url = URL(string: urlStr) 
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let status = String(data: data, encoding: .utf8)
                print(status)
                do {
                    let decoder = JSONDecoder()
                    let orderList = try decoder.decode(OrderData.self, from: data)
                    print("✅\(orderList)")
                } catch  {
                    print("🥲\(error.localizedDescription)")
                }
            
            }
            if let httpResponse = response as? HTTPURLResponse, error == nil {
                print("HTTP response status code: \(httpResponse.statusCode)")
            }
        }.resume()
        
    }
    
    
}
