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
        // 先判斷網址是否正確
        guard let url = URL(string: urlStr) else {
            print("🕸️網址錯誤")
            return
        }
        var request = URLRequest(url: url)
        // 設定httpmethod
        request.httpMethod = "Get"
        request.setValue("Bearer keyy7QrfYj3mhT9pM", forHTTPHeaderField: "Authorization")
        
        // 使用URLSession建立網路連線
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 先判斷是否有error
            if let error = error {
                print("😡\(error)")
                completion(.failure(error))
            } else if let data = data {
                do {
                    //解析 drinkDataResponse
                    let decoder = JSONDecoder()
                    let drinkDataResponse = try decoder.decode(DrinkData.self, from: data)
                    
                    //非同步成功回傳飲料清單
                    completion(.success(drinkDataResponse.records))
                    print("✅ download menu")
                    
                } catch  {
                    print("❌ 解碼失敗")
                    completion(.failure(error))
                }
            }
            //檢查 status code
            if let httpResponse = response as? HTTPURLResponse, error == nil {
                print("HTTP response status code: \(httpResponse.statusCode)")
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
        // 先判斷網址是否正確
        guard let url = URL(string: urlStr) else {
            print("🕸️網址錯誤")
            return
        }
        var request = URLRequest(url: url)

        request.setValue("Bearer keyy7QrfYj3mhT9pM", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("下載失敗")
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let renewOrder = try decoder.decode(OrderData.self, from: data)
                    print("✏️ 訂單明細\(renewOrder.records)")
                    completion(.success(renewOrder.records))
                } catch  {
                    print("✏️ ❌ 解碼失敗 ")
                    completion(.failure(error))
                }
            }
            //檢查 status code
            if let httpResponse = response as? HTTPURLResponse, error == nil {
                print("HTTP response status code: \(httpResponse.statusCode)")
            }
        }.resume()
        
    }
    
    
}
