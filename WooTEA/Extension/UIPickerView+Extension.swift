//
//  UIPickerView+Extension.swift
//  WooTEA
//
//  Created by shelley on 2023/2/5.
//

import Foundation
import UIKit

extension OrderTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //顯示每個textField中picker有幾個
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    //設定顯示的資料數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return Sugar.allCases.count
        case 1:
            guard self.menuDatas.fields.iceOnly != nil else { return tempList.count}
            return iceOnly.count
        case 2:
            return Topping.allCases.count
        default:
            //只有中杯
            if drinkNameLable.text == "最完美手沖泰奶, 綠茶凍手沖泰奶, 珍珠手沖泰奶" {
                return 0
                //只有大杯
            } else if drinkNameLable.text == "杏仁凍五桐茶, 豆漿凍紅茶, 綠茶凍五桐奶茶, 仙草凍奶茶, 綠茶凍五桐茶拿鐵, 仙草凍紅茶拿鐵, 老實人鮮柚綠茶, 蜂蜜鮮柚綠茶, 雪絨草莓奶酪, 雪絨葡萄果粒, 葡萄冰茶凍飲" {
                return 1
            } else {
                return Size.allCases.count
            }
        }
    }
    
    //選項顯示的資料內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return Sugar.allCases[row].rawValue
        case 1:
            guard self.menuDatas.fields.iceOnly != nil else { return tempList[row]}
            return iceOnly[row]
        case 2:
            return Topping.allCases[row].rawValue
        default:
            //只有中杯
            if drinkNameLable.text == "最完美手沖泰奶, 綠茶凍手沖泰奶, 珍珠手沖泰奶" {
                return Size.allCases[0].rawValue
            }else if drinkNameLable.text == "杏仁凍五桐茶, 豆漿凍紅茶, 綠茶凍五桐奶茶, 仙草凍奶茶, 綠茶凍五桐茶拿鐵, 仙草凍紅茶拿鐵, 老實人鮮柚綠茶, 蜂蜜鮮柚綠茶, 雪絨草莓奶酪, 雪絨葡萄果粒, 葡萄冰茶凍飲" {
                return Size.allCases[1].rawValue
            } else {
                return Size.allCases[row].rawValue
            }
        
        }
        
    }
    
    // picker 停止滑動時會呼叫 pickerView(_:didSelectRow:inComponent:),如選擇後執行是否增加費用
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            return sugar = Sugar.allCases[row].rawValue
        case 1:
            return temp = Temperature.allCases[row].rawValue
        case 2:
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
                if sizeTextField.text == "中杯" {
                    totalPrice = menuDatas.fields.priceM!
                    submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
                } else {
                    if let large = menuDatas.fields.priceL {
                        submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
                    }
                }
            }
            
            default:
            //只有中杯
            if drinkNameLable.text == "最完美手沖泰奶, 綠茶凍手沖泰奶, 珍珠手沖泰奶" {
                size = Size.allCases[0].rawValue
                totalPrice = menuDatas.fields.priceM!
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
            } else if drinkNameLable.text == "杏仁凍五桐茶, 豆漿凍紅茶, 綠茶凍五桐奶茶, 仙草凍奶茶, 綠茶凍五桐茶拿鐵, 仙草凍紅茶拿鐵, 老實人鮮柚綠茶, 蜂蜜鮮柚綠茶, 雪絨草莓奶酪, 雪絨葡萄果粒, 葡萄冰茶凍飲" {
                size = Size.allCases[0].rawValue
                totalPrice = menuDatas.fields.priceL!
                submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
            } else {
                size = Size.allCases[row].rawValue
                if row == 0 {
                    totalPrice = menuDatas.fields.priceM!
                    submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
                } else {
                    if let large = menuDatas.fields.priceL {
                        totalPrice = large
                        submitOrderBtn.configuration?.title = "送出訂單 $ \(totalPrice)"
                    }
                }
            }
    
        }
    }
}
