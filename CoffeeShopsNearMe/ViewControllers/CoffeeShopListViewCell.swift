//
//  CoffeeShopListViewCell.swift
//  CoffeeShopsNearMe
//
//  Created by Zhang, Wanming - (p) on 12/1/18.
//  Copyright © 2018 WanmingZhang. All rights reserved.
//

import UIKit

class CoffeeShopListViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var address3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCell(with coffeeShop: FindCoffeeShopApiResponse.CoffeeShopGroup.CoffeeShopItem.CoffeeShop?) {
        if let coffeeShop = coffeeShop {
            nameLabel.text = coffeeShop.name
            guard coffeeShop.location.formattedAddress.count >= 3 else {
                return
            }
            let addresses = coffeeShop.location.formattedAddress
            address1.text = addresses[0]
            address2.text = addresses[1]
            address3.text = addresses[2]
        }
    }
}
