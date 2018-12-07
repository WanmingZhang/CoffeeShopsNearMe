//
//  CoffeeShopViewModel.swift
//  CoffeeShopsNearMe
//
//  Created by Zhang, Wanming - (p) on 11/29/18.
//  Copyright © 2018 WanmingZhang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol FetchCoffeeShopsCompletedProtocol: class {
    func onFetchFailed(with error: String)
    func onFetchCompleted()
}

class CoffeeShopViewModel: NSObject {

    weak var delegate: FetchCoffeeShopsCompletedProtocol?
    
    let serviceManager = NetworkManager.sharedManager
    let imageCache = ImageCache.sharedCache
    var isFetchInProgress = false
    var coffeeShops: [FindCoffeeShopApiResponse.CoffeeShopGroup.CoffeeShopItem]?
    
    let clientId = "W1LHFKVVGDKXS12Y3MEFM52SBKJQTKIRFKAB51ZCDJQKCBOV"
    let clientSecret = "LZAS1ZGSIIF4E4QAXB1U0FCL0MTYOP3R55TTVH2EDDQ1VV4Q"
    let v = "20181206"
    
    func fetchCoffeeShops(near address: String) {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        
        let latlon = address
        let query = "coffee"
        let limit = 15
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.serviceManager.getCoffeeShops(client_id: strongSelf.clientId, client_secret: strongSelf.clientSecret, v: strongSelf.v, ll: latlon, query: query, limit: limit, completion: { (coffeeShopResponse, error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        strongSelf.delegate?.onFetchFailed(with: error!)
                    }
                    strongSelf.isFetchInProgress = false
                    return
                }
                guard let response = coffeeShopResponse else {
                    DispatchQueue.main.async {
                        strongSelf.delegate?.onFetchFailed(with: "Not able to find coffee shops nearby")
                    }
                    strongSelf.isFetchInProgress = false
                    return
                }
                
                DispatchQueue.main.async {
                    guard response.groups.count > 0 else {
                        strongSelf.delegate?.onFetchFailed(with: error ?? "Not able to find coffee shops nearby")
                        return
                    }
                    let coffeeShopGroup = response.groups[0]
                    strongSelf.coffeeShops = coffeeShopGroup.items
                    strongSelf.delegate?.onFetchCompleted()
                }
            })
        }
    }

    func convertAddressToLatLon(address: String, completion: @escaping  ( _ latlon: String?) -> ()) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else { // handle no location found
                    print("Not a valid address")
                    return
            }
            //var latLonStr = ""
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("Lat: \(lat), Lon: \(lon)")
            let latlonStr = "\(lat)" +  "," + "\(lon)"
            completion(latlonStr)
            
        }
        
    }
        
     //MARK: fetch product image
    
    func retrieveProductImage(coffeeShop: FindCoffeeShopApiResponse.CoffeeShopGroup.CoffeeShopItem.CoffeeShop, completion: @escaping (_ image: UIImage?, _ error: String?) -> ()) {
        
        let group = "checkin"
        let limit = 100
        let offset = 100
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.serviceManager.getCoffeeShopPhotos(client_id: strongSelf.clientId, client_secret: strongSelf.clientSecret, v: strongSelf.v, VENUE_ID: coffeeShop.id, group:group , limit: limit, offset: offset) { (error) in
                print(error?.description)
            }
        }
    }

        
//        serviceManager.getProductImage(imageURL: product.productImageURL) { (responseData, errorDesc) in
//
//            guard let data = responseData else {
//                print(errorDesc ?? "")
//                completion(nil, errorDesc)
//                return
//            }
//
//            if let image = UIImage(data: data) {
//                self.imageCache[product.productId] = data
//                completion(image, nil)
//            } else {
//                completion(nil, NetworkResponse.unableToDecode.rawValue)
//            }
//        }
    
    
//    func getImage(forProduct product: Product, onCompleted: ((String?, UIImage?) -> ())?) {
//        let imageCache = WPCache.sharedCache
//
//        if (product.productId.isEmpty == true) {
//            onCompleted?(nil, nil)
//            return
//        }
//
//        if let cachedImageData = imageCache[product.productId],
//            let cachedImage = UIImage(data: cachedImageData) {
//            onCompleted?(product.productId, cachedImage)
//            return
//        }
//
//        DispatchQueue.global(qos: .default).async { [weak self] in
//            guard let strongSelf = self else { return }
//            strongSelf.retrieveProductImage(product: product, completion: { (image, errorDesc) in
//                if let productImage = image {
//                    onCompleted?(product.productId, productImage)
//                }
//            })
//        }
//    }
//
//    func retrieveProductImage(product: Product, completion: @escaping (_ image: UIImage?, _ error: String?) -> ()) {
//        serviceManager.getProductImage(imageURL: product.productImageURL) { (responseData, errorDesc) in
//
//            guard let data = responseData else {
//                print(errorDesc ?? "")
//                completion(nil, errorDesc)
//                return
//            }
//
//            if let image = UIImage(data: data) {
//                self.imageCache[product.productId] = data
//                completion(image, nil)
//            } else {
//                completion(nil, NetworkResponse.unableToDecode.rawValue)
//            }
//        }
//    }
    
    // MARK: helper method
//    func product(at row: Int) -> Product? {
//        return self.products[row]
//    }
//
//    func reviewRatingIcon(for product: Product) -> UIImage? {
//        let rating = product.reviewRating
//        let intRating = Int(floor(rating))
//        let decimalRating = rating - Float(intRating)
//        var imageName = "regular"
//        if (rating < 1) {
//            imageName.append("_0")
//        } else {
//            imageName.append("_" + "\(intRating)")
//        }
//        if (decimalRating >= 0.5) {
//            imageName.append("_half")
//        }
//        return UIImage(named: imageName)
//    }
//
//    func reviewCountString(for product: Product) -> String {
//        let count = product.reviewCount
//        var countStr = "\(count)"
//
//        if (count > 1) {
//            countStr.append(" reviews ")
//        } else {
//            countStr.append(" review ")
//        }
//        return countStr
//    }
    
    
}
