//
//  CoffeeShop.swift
//  CoffeeShopsNearMe
//
//  Created by Zhang, Wanming - (p) on 11/29/18.
//  Copyright © 2018 WanmingZhang. All rights reserved.
//

import Foundation

struct SearchForVenuesApiResponse {
    private(set) var meta: MetaDict
    private(set) var response: FindCoffeeShopApiResponse
    
}
extension SearchForVenuesApiResponse: Decodable {
    enum SearchForVenuesApiResponseCodingKeys: String, CodingKey {
        case meta = "meta"
        case response = "response"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SearchForVenuesApiResponseCodingKeys.self)
        meta = try container.decode(MetaDict.self, forKey: .meta)
        response = try container.decode(FindCoffeeShopApiResponse.self, forKey: .response)
    }
}

class MetaDict: NSObject, Decodable {
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


class FindCoffeeShopApiResponse: NSObject, Decodable {
    private(set) var groups: [CoffeeShopGroup]
    enum FindCoffeeShopApiResponseCodingKeys: String, CodingKey {
        case groups = "groups"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FindCoffeeShopApiResponseCodingKeys.self)
        groups = try container.decode([CoffeeShopGroup].self, forKey: .groups)
    }
    
    class CoffeeShopGroup: NSObject, Decodable {
        private(set) var items: [CoffeeShopItem]
        
        enum CoffeeShopGroupCodingKeys: String, CodingKey {
            case items = "items"
        }
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CoffeeShopGroupCodingKeys.self)
            items = try container.decode([CoffeeShopItem].self, forKey: .items)
        }
        
        class CoffeeShopItem: NSObject, Decodable {
            private(set) var venue: CoffeeShop
            
            enum CoffeeShopItemCodingKeys: String, CodingKey {
                case venue = "venue"
            }
            
            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CoffeeShopItemCodingKeys.self)
                venue = try container.decode(CoffeeShop.self, forKey: .venue)
            }
            
            class CoffeeShop: NSObject,Decodable {
                private(set) var id: String
                private(set) var name: String
                private(set) var location: CoffeeShopLocation
                private(set) var categories:[CoffeeShopCategory]
                
                enum CoffeeShopCodingKeys: String, CodingKey {
                    case id = "id"
                    case name = "name"
                    case location = "location"
                    case categories = "categories"
                }
                required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CoffeeShopCodingKeys.self)
                    id = try container.decode(String.self, forKey: .id)
                    name = try container.decode(String.self, forKey: .name)
                    location = try container.decode(CoffeeShopLocation.self, forKey: .location)
                    categories = try container.decode([CoffeeShopCategory].self, forKey: .categories)
                }
                
                class CoffeeShopLocation: NSObject, Decodable {
                    private(set) var lat: Float
                    private(set) var lng: Float
                    private(set) var formattedAddress: [String]
                    
                    enum CoffeeShopLocationCodingKeys: String, CodingKey {
                        case lat = "lat"
                        case lng = "lng"
                        case formattedAddress = "formattedAddress"
                    }
                    
                    required init(from decoder: Decoder) throws {
                        let container = try decoder.container(keyedBy: CoffeeShopLocationCodingKeys.self)
                        lat = try container.decode(Float.self, forKey: .lat)
                        lng = try container.decode(Float.self, forKey: .lng)
                        formattedAddress = try container.decode([String].self, forKey: .formattedAddress)
                    }
                }
                
                class CoffeeShopCategory: NSObject, Decodable  {
                    private(set) var icon: CoffeeShopIcon
                    enum CoffeeShopCategoryCodingKeys: String, CodingKey {
                        case icon = "icon"
                    }
                    required init(from decoder: Decoder) throws {
                        let container = try decoder.container(keyedBy: CoffeeShopCategoryCodingKeys.self)
                        icon = try container.decode(CoffeeShopIcon.self, forKey: .icon)
                    }
                    
                    class CoffeeShopIcon: NSObject, Decodable  {
                        private(set) var prefix: String
                        private(set) var suffix: String
                        
                        enum CoffeeShopIconCodingKeys: String, CodingKey {
                            case prefix = "prefix"
                            case suffix = "suffix"
                        }
                        required init(from decoder: Decoder) throws {
                            let container = try decoder.container(keyedBy: CoffeeShopIconCodingKeys.self)
                            prefix = try container.decode(String.self, forKey: .prefix)
                            suffix = try container.decode(String.self, forKey: .suffix)
                        }
                    }
                }
                
            }
        }
    }
    
    

    
}
