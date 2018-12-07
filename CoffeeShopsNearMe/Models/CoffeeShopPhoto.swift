//
//  CoffeeShopPhoto.swift
//  CoffeeShopsNearMe
//
//  Created by Zhang, Wanming - (p) on 12/7/18.
//  Copyright © 2018 WanmingZhang. All rights reserved.
//

import Foundation

struct GetVenuePhotosApiResponse {
    private(set) var meta: PhotoMetaDict
    private(set) var response: CoffeeShopPhotoApiResponse
    
}

extension GetVenuePhotosApiResponse: Decodable {
    enum GetVenuePhotosApiResponseCodingKeys: String, CodingKey {
        case meta = "meta"
        case response = "response"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GetVenuePhotosApiResponseCodingKeys.self)
        meta = try container.decode(PhotoMetaDict.self, forKey: .meta)
        response = try container.decode(CoffeeShopPhotoApiResponse.self, forKey: .response)
    }
}

class PhotoMetaDict: NSObject, Decodable {
    private(set) var code: Int
    private(set) var requestId:String
    
    enum MetaDictCodingKeys: String, CodingKey {
        case code = "code"
        case requestId = "requestId"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MetaDictCodingKeys.self)
        code = try container.decode(Int.self, forKey: .code)
        requestId = try container.decode(String.self, forKey: .requestId)
    }
}

class CoffeeShopPhotoApiResponse: NSObject, Decodable {
    private(set) var photos: CoffeeShopPhotos
    
    enum FindCoffeeShopApiResponseCodingKeys: String, CodingKey {
        case photos = "photos"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FindCoffeeShopApiResponseCodingKeys.self)
        photos = try container.decode(CoffeeShopPhotos.self, forKey: .photos)
    }
    
    
    class CoffeeShopPhotos: NSObject, Decodable {
        private(set) var count:Int
        private(set) var items:[CoffeeShopPhoto]
        //private(set) var dupesRemoved: Int
        
        enum CoffeeShopPhotosCodingKeys: String, CodingKey {
            case count = "count"
            case items = "items"
            //case dupesRemoved = "dupesRemoved"
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CoffeeShopPhotosCodingKeys.self)
            count = try container.decode(Int.self, forKey: .count)
            items = try container.decode([CoffeeShopPhoto].self, forKey: .items)
            //dupesRemoved = try container.decode(Int.self, forKey: .dupesRemoved)
        }
        
        class CoffeeShopPhoto: NSObject, Decodable {
            private(set) var id:String
            private(set) var prefix:String
            private(set) var suffix:String
            private(set) var width:Int
            private(set) var height:Int
            
            enum CoffeeShopPhotoCodingKeys: String, CodingKey {
                case id = "id"
                case prefix = "prefix"
                case suffix = "suffix"
                case width = "width"
                case height = "height"
            }
            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CoffeeShopPhotoCodingKeys.self)
                id  = try container.decode(String.self, forKey: .id)
                prefix = try container.decode(String.self, forKey: .prefix)
                suffix = try container.decode(String.self, forKey: .suffix)
                width  = try container.decode(Int.self, forKey: .width)
                height  = try container.decode(Int.self, forKey: .height)
            }
        }
        
    }
    
    
}
