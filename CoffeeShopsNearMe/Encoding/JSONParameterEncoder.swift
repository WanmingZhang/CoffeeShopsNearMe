//
//  JSONParameterEncoder.swift
//  CoffeeShopsNearMe
//
//  Created by Zhang, Wanming - (p) on 11/28/18.
//  Copyright © 2018 WanmingZhang. All rights reserved.
//

import Foundation

public protocol JsonParameterEncodingProtocol {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public struct JSONParameterEncoder: JsonParameterEncodingProtocol {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }catch {
            throw NetworkError.encodingFailed
        }
    }
}
