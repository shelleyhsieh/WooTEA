//
//  UITextField+Extensions.swift
//  WooTEA
//
//  Created by shelley on 2023/2/4.
//

import Foundation

import UIKit
extension OrderTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing (_ textField: UITextField) {
        textField.becomeFirstResponder()
        self.setPickerView(selectAt: textField)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    public func setPickerView(selectAt sender: UITextField){
        switch sender {
        case sugarTextField:
            pickerView.tag = 0
        case tempTextField:
            pickerView.tag = 1
        case toppingTextField:
            pickerView.tag = 2
        case sizeTextField:
            pickerView.tag = 3
        default:
            break
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // set pickerview toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(named: "AppRed")
        toolBar.barTintColor = .white
        toolBar.sizeToFit()
        
        //set barBotton
        let doneBtn = UIBarButtonItem(title: "確認", style: .plain, target: self , action: #selector(done))
        let cancelBen = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelBen, spaceBtn, doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        for textfield in self.pickerViewTextField {
            textfield.inputView = pickerView
            textfield.inputAccessoryView = toolBar
        }
        
    }
    // barbutton action
    @objc func done() {
        if let orderName = orderNameTextField.text {
            self.orderName = orderName
        }
        
        switch pickerView.tag {
        case 0:
            sugarTextField.text = sugar
            if sugar.isEmpty == true {
                sugar = Sugar.allCases[0].rawValue
                sugarTextField.text = sugar
            }

        case 1:
            tempTextField.text = temp
            if temp.isEmpty == true {
                temp = Temperature.allCases[0].rawValue
                tempTextField.text = temp
            }
            
        case 2:
            toppingTextField.text = topping
            if topping.isEmpty == true {
                topping = Topping.allCases[0].rawValue
                toppingTextField.text = topping
            }
            
        case 3:
            sizeTextField.text = size
            if size.isEmpty == true {
                size = Size.allCases[0].rawValue
                sizeTextField.text = size
            }
            
        default:
            break
        }
        tableView.endEditing(true)

    }
    
    @objc func cancel(){
        tableView.endEditing(true)
    }
    
}
