//
//  ServiceManager.swift
//  CoffeeShopsNearMe
//
//  Created by Zhang, Wanming - (p) on 11/28/18.
//  Copyright © 2018 WanmingZhang. All rights reserved.
//

import Foundation

import UIKit

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    
    static let sharedManager = NetworkManager() //Singleton instance
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    let fourSquareRouter = NetworkRouter<FourSquareApi>()

    func getCoffeeShops(client_id: String,
                        client_secret: String,
                        v: String,
                        ll: String,
                        query: String,
                        limit: Int,
                        completion: @escaping  ( _ coffeeShopResponse: FindCoffeeShopApiResponse?, _ error: String?) -> ()) {
        
        fourSquareRouter.request(.exploreCoffeeShops(client_id: client_id, client_secret: client_secret, v: v, ll: ll, query: query, limit: limit)) { (data, response, error) in
            if (error != nil) {
                completion(nil, error?.localizedDescription)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String:Any] else {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                            return
                        }
                        print(jsonData)
                        do {
                            let apiResponse = try JSONDecoder().decode(SearchForVenuesApiResponse.self, from: responseData)
                            completion(apiResponse.response, nil)
                        } catch let error {
                            print(error)
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                    }
                    catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getCoffeeShopPhotos(client_id: String,
                             client_secret: String,
                             v: String,
                             VENUE_ID: String,
                             group: String,
                             limit: Int,
                             offset: Int,
                             completion: @escaping (_ photoResponse: CoffeeShopPhotoApiResponse?, _ error: String?) -> ()) {
        
        fourSquareRouter.request(.coffeeShopImage(client_id: client_id, client_secret: client_secret, v: v, VENUE_ID: VENUE_ID, group: group, limit: limit, offset: offset)) { (data, response, error) in
            if (error != nil) {
                completion(nil, error?.localizedDescription)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String:Any] else {
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                            return
                        }
                        print(jsonData)
                        do {
                            let apiResponse = try JSONDecoder().decode(GetVenuePhotosApiResponse.self, from: responseData)
                            print(apiResponse.response)
                            completion(apiResponse.response, nil)
                        } catch let error {
                            print(error)
                            completion(nil, NetworkResponse.unableToDecode.rawValue)
                        }
                }
                catch {
                    print(error)
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
                case .failure(let networkFailureError):
                completion(nil, networkFailureError)
                }
            }
        }
    }

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }

}


