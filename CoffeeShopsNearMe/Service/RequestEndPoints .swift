//
//  RequestEndPoints .swift
//  CoffeeShopsNearMe
//
//  Created by Zhang, Wanming - (p) on 11/28/18.
//  Copyright © 2018 WanmingZhang. All rights reserved.
//

import Foundation

protocol RequestEndPoints {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
