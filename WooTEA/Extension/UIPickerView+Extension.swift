//
//  UIPickerView+Extension.swift
//  WooTEA
//
//  Created by shelley on 2023/2/5.
//

import Foundation
import UIKit

extension OrderTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //顯示每個textField中pickerview顯示數量
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    //設定每一列的選項數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            guard self.menuDatas.fields.iceOnly != nil else { return iceOnly.count} //只限冰飲
            return tempList.count
        case 1:
            return Sugar.allCases.count
        case 2:
            // 只有中杯
            if drinkNameLable.text == "最完美手沖泰奶, 綠茶凍手沖泰奶, 珍珠手沖泰奶" {
                return Size.medium.hashValue
                //只有大杯
            } else if drinkNameLable.text == "杏仁凍五桐茶, 豆漿凍紅茶, 綠茶凍五桐奶茶, 仙草凍奶茶, 綠茶凍五桐茶拿鐵, 仙草凍紅茶拿鐵, 老實人鮮柚綠茶, 蜂蜜鮮柚綠茶, 雪絨草莓奶酪, 雪絨葡萄果粒, 葡萄冰茶凍飲" {
                return Size.large.hashValue
            } else {
                return Size.allCases.count
            }
        default:
            return Topping.allCases.count
        }
    }
    
    //選項顯示的資料內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            guard self.menuDatas.fields.iceOnly != nil else { return iceOnly[row]}
            return tempList[row]
        case 1:
            return Sugar.allCases[row].rawValue
        case 2:
            //只有中杯
            if drinkNameLable.text == "最完美手沖泰奶, 綠茶凍手沖泰奶, 珍珠手沖泰奶" {
                return Size.allCases[0].rawValue
                //只有大杯
            } else if drinkNameLable.text == "杏仁凍五桐茶, 豆漿凍紅茶, 綠茶凍五桐奶茶, 仙草凍奶茶, 綠茶凍五桐茶拿鐵, 仙草凍紅茶拿鐵, 老實人鮮柚綠茶, 蜂蜜鮮柚綠茶, 雪絨草莓奶酪, 雪絨葡萄果粒, 葡萄冰茶凍飲" {
                return Size.allCases[1].rawValue
            } else {
                return Size.allCases[row].rawValue
            }
        default:
            return Topping.allCases[row].rawValue
        }
        
    }
    
    // picker 停止滑動時會呼叫 pickerView(_:didSelectRow:inComponent:),如選擇後執行是否增加費用，意即選擇後要執行的方法
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            temp = Temperature.allCases[row].rawValue
//            return temp = Temperature.allCases[row].rawValue
        case 1:
            return sugar = Sugar.allCases[row].rawValue
        case 2:
            //只有中杯
            if drinkNameLable.text == "最完美手沖泰奶, 綠茶凍手沖泰奶, 珍珠手沖泰奶" {
                size = Size.allCases[0].rawValue
                totalPrice = menuDatas.fields.priceM ?? 0
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
            } else if drinkNameLable.text == "杏仁凍五桐茶, 豆漿凍紅茶, 綠茶凍五桐奶茶, 仙草凍奶茶, 綠茶凍五桐茶拿鐵, 仙草凍紅茶拿鐵, 老實人鮮柚綠茶, 蜂蜜鮮柚綠茶, 雪絨草莓奶酪, 雪絨葡萄果粒, 葡萄冰茶凍飲" {  //只有大杯
                size = Size.allCases[1].rawValue
                totalPrice = menuDatas.fields.priceL ?? 0
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
            } else {
                size = Size.allCases[row].rawValue
                if let medium = menuDatas.fields.priceM {
                    totalPrice = medium
                    submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
                } else {
                    if let large = menuDatas.fields.priceL {
                        totalPrice = large
                        submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
                    }
                }
            }
            
            default:
            topping = Topping.allCases[row].rawValue
            if row == 1 {
                totalPrice += 5
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
                
            }else if row == 2 {
                totalPrice += 5
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
            } else if row == 3 {
                totalPrice += 10
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
            } else if row == 4 {
                totalPrice += 10
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
            } else if row == 5 {
                totalPrice += 15
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
            } else if row == 6 {
                totalPrice += 15
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
            } else if row == 7 {
                totalPrice += 15
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
            } else if row == 8 {
                totalPrice += 20
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
            } else {
                if let medium = menuDatas.fields.priceM {
                    totalPrice = medium
                    submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
                } else {
                    if let large = menuDatas.fields.priceL {
                        submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
                    }
                }
            }
            
    
        }
    }
}
