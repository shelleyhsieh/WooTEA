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
    
    // 上傳資料 https://api.airtable.com/v0/{baseId}/{tableIdOrName}
    // https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Order
    
    func uploadData(urlStr: String, data: OrderData) {
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(data)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let content = String(data: data, encoding: .utf8)
                    print(content)
                    print("上傳成功")
                } catch  {
                    print(error)
                    print("上傳失敗")
                }
            }
        }.resume()
        
    }

    
    //更新訂單 https://api.airtable.com/v0/{baseId}/{tableIdOrName}/{recordId}
    // https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Order
    func fetchOrderData(urlStr:String, completion: @escaping(Result<[OrderList.Record], Error>) -> Void) {
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
//        request.httpMethod = "PATCH"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let renewOrder = try decoder.decode(OrderList.self, from: data)
                    completion(.success(renewOrder.records))
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
    
    // 刪除訂單 https://api.airtable.com/v0/{baseId}/{tableIdOrName}/{recordId}
    // https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Order/createdID
    func deleteOrderData(urlStr: String) {
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let orderList = try decoder.decode(OrderList.self, from: data)
                    print(orderList)
                } catch  {
                    print(error)
                }
              
            }
            if let httpResponse = response as? HTTPURLResponse, error == nil {
                print("HTTP response status code: \(httpResponse.statusCode)")
            }
        }.resume()
        
    }
    
    
}
