//
//  CoffeeShopListViewCell.swift
//  CoffeeShopsNearMe
//
//  Created by Zhang, Wanming - (p) on 12/1/18.
//  Copyright © 2018 WanmingZhang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CoffeeShopListViewCell: UITableViewCell {

    @IBOutlet weak var coffeeShopImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
            
            guard coffeeShop.categories.count > 0 else {
                return
            }
            let category = coffeeShop.categories[0]
            let width = 100
            let height = 100
            
            
            let viewModel = CoffeeShopViewModel.init()
            
            viewModel.retrieveProductImage(coffeeShop: coffeeShop) { (imageStr, error) in
                guard let imageStr = imageStr else {
                    return
                }
                guard let url = URL(string: imageStr) else {
                    return
                }
                print(imageStr)
                self.activityIndicator.startAnimating()
                let filter = AspectScaledToFillSizeFilter(size: CGSize(width: width, height: height))
                self.coffeeShopImageView.af_setImage(withURL: url,
                                                placeholderImage: nil,
                                                filter: filter,
                                                progress: nil,
                                                progressQueue: DispatchQueue.main,
                                                imageTransition: .noTransition,
                                                runImageTransitionIfCached: false) { (dataResponse : DataResponse<UIImage>) in
                                                    switch dataResponse.result {
                                                    case .success( _):
                                                        print("success")
                                                        self.activityIndicator.stopAnimating()
                                                    case .failure(let imageError):
                                                        print("\(imageError)")
                                                    }
                }
                
                
                
                
            }
//            let imageStr = category.icon.prefix + "\(width)" + "x" + "\(height)" + category.icon.suffix
//
//            guard let url = URL(string: imageStr) else {
//                return
//            }
            

            
        }
    }
}
