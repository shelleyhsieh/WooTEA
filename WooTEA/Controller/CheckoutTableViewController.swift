//
//  CheckoutTableViewController.swift
//  WooTEA
//
//  Created by shelley on 2023/2/1.
//

import UIKit

class CheckoutTableViewController: UITableViewController {

    let urlStr = "https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Order?sort[][field]=createdID"
    var orderList = [OrderData.Record]()
    var deleteID = ""
    
    var id = String()
    var deleted = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(Self.self, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdateNotification, object: nil)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MenuController.shared.fetchOrderData(urlStr: urlStr) { (result) in
            switch result {
            case.success(let orderList):
                self.updateUI(with: orderList)
            case.failure(let error):
                print (error)
            }
        }
    }
    
    //有註冊Observer，就要移除oberver，移除時機就是畫面消失時
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
// MARK: - fetch orderList 
    func updateUI(with orderList: [OrderData.Record]) {
        self.orderList = orderList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateDelete(indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard let deleteID = self.orderList[indexPath.row].id else { return }
            self.deleteOrderData(urlStr: "https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Order/\(deleteID)") { (result) in
                switch result {
                case .success(let boolValue):
                    print("✅delete OK!")
                case .failure(let error):
                   print(error)
                }
            }
            print(deleteID)
            
            self.orderList.remove(at: indexPath.row)
            print(indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print(indexPath)
            
            self.tableView.reloadData()
        }
    }
    
    // 刪除訂單 https://api.airtable.com/v0/{baseId}/{tableIdOrName}/{recordId}
    func deleteOrderData(urlStr: String, completion: @escaping (Result< Bool, Error >) -> Void) {
       
        guard let url = URL(string: urlStr) else {
            print("🕸️網址錯誤")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let deletedOrder = DeleteOrder(id: id, deleted: deleted)
        
        let encoder = JSONEncoder()
        let encodeData = try? encoder.encode(deletedOrder)
        let jsonString = String(data: encodeData!, encoding: .utf8)
        let postData = jsonString?.data(using: .utf8)
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 先判斷是否有error
            if let error = error {
                print("😡\(error)")
            } else if let data = data {
                let status = String(data: data, encoding: .utf8)
                print("✂️\(status ?? "")")
                do {
                    let decoder = JSONDecoder()
                    let deleteOrderResponse = try decoder.decode(DeleteOrder.self, from: data)
                    print("✅\(deleteOrderResponse)")
                    completion(.success(true))
                    
                } catch  {
                    print("🥺 JSON ERROR")
                    completion(.failure(error))
                }
            
            }
            //檢查 status code
            if let httpResponse = response as? HTTPURLResponse, error == nil {
                print("HTTP response status code: \(httpResponse.statusCode)")
            }
        }.resume()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CheckoutTableViewCell.self)", for: indexPath) as! CheckoutTableViewCell
        let orderData = orderList[indexPath.row]
        
        cell.orderNameLable.text = orderData.fields.buyer
        cell.drinkNameLable.text = orderData.fields.drinkName
        cell.drinkSize.text = orderData.fields.size
        cell.drinkTemp.text = orderData.fields.temperature
        cell.drinkSugar.text = orderData.fields.sugar
        cell.addTopping.text = orderData.fields.toppings
        
        if orderData.fields.toppings == "無" {
            cell.addTopping.text = ""
        } else {
            cell.addTopping.text = "+\(orderData.fields.toppings)"
        }
        
        cell.totalCupsLable.text = "共  \(orderData.fields.numberOfCups)  杯"
        cell.totalPriceLable.text = "$ \(orderData.fields.pricePerCup * orderData.fields.numberOfCups)"
        
//        tableView.rowHeight = 140

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete")
            
            updateDelete(indexPath: indexPath)
            print(indexPath)
            
        }           
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
