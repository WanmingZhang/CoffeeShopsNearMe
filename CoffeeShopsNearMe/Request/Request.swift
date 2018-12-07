//
//  Request.swift
//  CoffeeShopsNearMe
//
//  Created by Zhang, Wanming - (p) on 11/28/18.
//  Copyright © 2018 WanmingZhang. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum FourSquareApi {
    
    case exploreCoffeeShops(client_id:String, client_secret:String, v:String,  ll:String, query:String,limit:Int)
    case coffeeShopImage(client_id:String, client_secret:String, v:String, VENUE_ID:String, group:String, limit:Int, offset:Int)
}

extension FourSquareApi: RequestEndPoints {
    
    var baseURLString : String {
        return "https://api.foursquare.com/v2"
    }
    
    var baseURL: URL {
        guard let url = URL(string: baseURLString) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .exploreCoffeeShops(_, _, _, _, _, _):
            return "venues/explore"
        case .coffeeShopImage(client_id: _, client_secret: _, v: _, VENUE_ID: let venue_Id, group: _, limit: _, offset: _):
            
            return "venues/" + venue_Id + "/photos"
            //https://api.foursquare.com/v2/venues/43695300f964a5208c291fe3/photos?
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .exploreCoffeeShops(client_id:let clientID, client_secret:let secret, v:let date,  ll:let latlon, query:let query, limit:let limit):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["client_id":clientID,
                                                                                                       "client_secret":secret,
                                                                                                       "v":date,
                                                                                                       "ll":latlon,
                                                                                                       "query":query,
                                                                                                       "limit":limit])
            
        case .coffeeShopImage(client_id: let clientID, client_secret: let secret, v:let date, VENUE_ID: _, group: let group, limit: let limit, offset: let offset):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["client_id":clientID,
                                                                                                       "client_secret":secret,
                                                                                                       "v":date,
                                                                                                       "group":group,
                                                                                                       "limit":limit,
                                                                                                       "offset":offset])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}




