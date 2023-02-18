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

let mediumOnly = ["最完美手沖泰奶", "綠茶凍手沖泰奶", "珍珠手沖泰奶"]
let largrOnly = ["杏仁凍五桐茶", "豆漿凍紅茶", "綠茶凍五桐奶茶", "仙草凍奶茶", "綠茶凍五桐茶拿鐵", "仙草凍紅茶拿鐵", "老實人鮮柚綠茶", "蜂蜜鮮柚綠茶", "雪絨草莓奶酪", "雪絨葡萄果粒", "葡萄冰茶凍飲"]


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

