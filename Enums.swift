//
//  Enums.swift
//  WooTEA
//
//  Created by shelley on 2023/2/1.
//

import Foundation

let iceOnly = ["去冰", "微冰", "少冰","正常冰"]
let sugarList = ["無糖", "微糖", "半糖","少糖", "全糖" ]
let tempList = ["去冰", "微冰", "少冰","正常冰", "熱"]
let toppingList = ["珍珠":5, "仙草凍":5, "綠茶凍":10,"小芋圓":10, "杏仁凍":15, "米漿凍":15,"豆漿凍":15,"奶霜":20]


enum Sugar: String, CaseIterable {
    case sugarFree = "無糖"
    case quartSugar = "微糖"
    case halfSugar = "半糖"
    case lessSugar = "少糖"
    case regularSugar = "全糖"
}

enum Temperature: String, CaseIterable {
   case iceFree = "去冰"
   case easyIce = "微冰"
   case lessIce = "少冰"
   case regularIce = "正常"
   case hot = "熱"
    
}

enum Topping: String, CaseIterable {
    case nonoe = "無"
    case bubble = "珍珠"
    case grassJelly = "仙草凍"
    case greenteaJelly = "綠茶凍"
    case taroBUbble = "小芋圓"
    case almondJelly = "杏仁凍"
    case riceJelly = "米漿凍"
    case soyJelly = "豆漿凍"
    case cream = "奶霜"
}

enum Size: String, CaseIterable {
    case medium = "中杯"
    case large = "大杯"
}

