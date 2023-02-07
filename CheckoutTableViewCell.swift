//
//  CheckoutTableViewCell.swift
//  WooTEA
//
//  Created by shelley on 2023/2/1.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNameLable: UILabel!
    @IBOutlet weak var drinkNameLable: UILabel!
    
    @IBOutlet weak var drinkSize: UILabel!
    @IBOutlet weak var drinkTemp: UILabel!
    @IBOutlet weak var drinkSugar: UILabel!
    @IBOutlet weak var addTopping: UILabel!
    @IBOutlet weak var totalCupsLable: UILabel!
    @IBOutlet weak var totalPriceLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
