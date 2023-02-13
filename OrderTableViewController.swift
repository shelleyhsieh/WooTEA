//
//  OrderTableViewController.swift
//  WooTEA
//
//  Created by shelley on 2023/2/1.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    let urlStr = "https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Order"
    var menuDatas: Record!
    var orderData = [OrderData.Record]()
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    
    @IBOutlet weak var orderNameTextField: UITextField!
    @IBOutlet weak var tempTextField: UITextField!
    @IBOutlet weak var sugarTextField: UITextField!
    @IBOutlet weak var toppingTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    
    @IBOutlet var pickerViewTextField: [UITextField]!
    
    @IBOutlet weak var numberOfCupLable: UILabel!
    @IBOutlet weak var submitOrderBtn: UIButton!
    
    let pickerView = UIPickerView()
    
    var orderName: String = ""
    var temp:String = ""
    var sugar:String = ""
    var topping:String = ""
    var size:String = ""
    
    var totalPrice: Int = 0
    var numberOfCup = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init
        self.navigationItem.title = "商品明細"
        
        //菜單頁面下載後傳到訂購頁面
        drinkNameLable.text = menuDatas.fields.name
        descriptionLable.text = menuDatas.fields.description
        
        // 下載照片
        let imageUrl = menuDatas.fields.image[0].url
        MenuController.shared.fetchImage(url: imageUrl) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.drinkImageView.image = image
            }
        }
        
        numberOfCupLable.text = String(numberOfCup)
        submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
        submitOrderBtn.titleLabel?.font = UIFont(name: "Songti.ttc", size: 24)
        
        tapGesture()
        
        orderNameTextField.delegate = self
        tempTextField.delegate = self
        sugarTextField.delegate = self
        toppingTextField.delegate = self
        sizeTextField.delegate = self
    
    }
    
    // 增加按空白處收鍵盤的觸控
    func tapGesture() {
        let tapGasture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGasture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGasture)
    }
    
    // 按空白處收鍵盤或pickerView
    @objc func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    
    //MARK: - total cups and price
    //增加杯數
    @IBAction func plusBtn(_ sender: UIButton) {
        numberOfCup += 1
        numberOfCupLable.text = String(numberOfCup)
        submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice * numberOfCup)"
        
    }
    // 少於一杯跳警告
    @IBAction func minusBtn(_ sender: UIButton) {
        if numberOfCup <= 1 {
            showAlert(title: "數量錯誤", message: "請輸入一杯以上")
        } else {
            numberOfCup -= 1
            numberOfCupLable.text = String(numberOfCup)
            submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice * numberOfCup)"
            
        }
    }
    
    // 加入訂單
    @IBAction func submitOrder(_ sender: UIButton) {
        
        if orderNameTextField.text?.isEmpty == true {
            showAlert(title: "提醒", message: "請輸入訂購人姓名")
        } else if sugarTextField.text?.isEmpty == true {
            showAlert(title: "提醒", message: "請選擇飲品甜度")
        } else if tempTextField.text?.isEmpty == true {
            showAlert(title: "提醒", message: "請選擇飲品溫度")
        } else if toppingTextField.text?.isEmpty == true {
            showAlert(title: "提醒", message: "請選擇是否加料，若不加料請選無")
        } else if sizeTextField.text?.isEmpty == true {
            showAlert(title: "提醒", message: "請選擇飲品大小")
        } else {
            confirmOrder {  _ in
                self.uploadData()
                self.navigationController?.popViewController(animated: true)  //加入訂單完回到首頁
            }
        }
    }
    
    func uploadData(){
        let urlStr = "https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Order"
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Bearer keyy7QrfYj3mhT9pM", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let id = createdID()
        let confirmOrder = OrderData.Record.Fields(buyer: orderName, drinkName: menuDatas.fields.name, size: size, sugar: sugar, temperature: temp, toppings: topping, pricePerCup: totalPrice, numberOfCups: numberOfCup, createdID: id)
        let record = OrderData.Record(id: nil, fields: confirmOrder)
        let order = OrderData(records: [record])
        
        let encoder = JSONEncoder()
        let encodeData = (try? encoder.encode(order))!
        let jasonString = String(data: encodeData, encoding: .utf8)
        let postData = jasonString!.data(using: .utf8)
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let order = try decoder.decode(OrderData.self, from: data)
                    let content = String(data: data, encoding: .utf8)
                    print("🧋\(order)")
                    print("✅ \(content)")
                } catch {
                    print("😡\(error)")
                }
            }
        }.resume()
        
    }
    
    //下單時間作為訂單ID
    func createdID () -> String {
        let now = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMMddHHmmSS"
        return dateformatter.string(from: now)
    }
    
    
    // 錯誤警告視窗
    func showAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
        
    }
    //訂單確認視窗
    func confirmOrder(action: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: "確認加入訂單？", message: "訂購人：\(orderNameTextField.text!)\n\(drinkNameLable.text!)\n\(sugarTextField.text!)\(tempTextField.text!),\(toppingTextField.text!)\n\(sizeTextField.text!), 總共\(numberOfCupLable.text!)杯, \(totalPrice * numberOfCup)元", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: action))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
// NSString gives us a nice sanitized debugDescription
//extension Date {
//    func PrettyPrintedJasonString() {
//        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
//              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
//              let prettyPrintedString = String(data: data, encoding: .utf8) else { return }
//
//        print(prettyPrintedString)
//    }
//}
