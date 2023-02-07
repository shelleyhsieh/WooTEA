//
//  CheckoutTableViewController.swift
//  WooTEA
//
//  Created by shelley on 2023/2/1.
//

import UIKit

class CheckoutTableViewController: UITableViewController {

    let urlStr = "https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Order?sort[][field]=createdID"
    var orderList = [OrderList.Record]()
    var deleteID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdateNotification, object: nil)
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
        
    func updateUI(with orderList: [OrderList.Record]) {
        DispatchQueue.main.async {
            self.orderList = orderList
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MenuController.shared.order.orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CheckoutTableViewCell.self)", for: indexPath) as! CheckoutTableViewCell
        let orderData = MenuController.shared.order.orders[indexPath.row]
        
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
        
        cell.totalCupsLable.text = "共\(orderData.fields.numberOfCups)杯"
        cell.totalPriceLable.text = "$ \(orderData.fields.pricePerCup * orderData.fields.numberOfCups)"
        
        tableView.rowHeight = 140

        return cell
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

            let deleteID = orderList[indexPath.row]
            MenuController.shared.deleteOrderData(urlStr: "https://api.airtable.com/v0/appPjWNJvMilEx1Cz/Order/" + deleteID.id)
            MenuController.shared.order.orders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            
            
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