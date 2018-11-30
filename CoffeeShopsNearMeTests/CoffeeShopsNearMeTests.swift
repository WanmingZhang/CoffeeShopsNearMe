//
//  CoffeeShopsNearMeTests.swift
//  CoffeeShopsNearMeTests
//
//  Created by Zhang, Wanming - (p) on 11/28/18.
//  Copyright © 2018 WanmingZhang. All rights reserved.
//

import XCTest
@testable import CoffeeShopsNearMe

class CoffeeShopsNearMeTests: XCTestCase {

    let latlon = "40.7243,-74.0018"
    let clientId = "W1LHFKVVGDKXS12Y3MEFM52SBKJQTKIRFKAB51ZCDJQKCBOV"
    let clientSecret = "LZAS1ZGSIIF4E4QAXB1U0FCL0MTYOP3R55TTVH2EDDQ1VV4Q"
    let v = "20181128"
    let query = "coffee"
    let limit = 15
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFourSquareExploreCoffeeURLEncodingWithComponent() {
        guard let url = URL(string: "https://api.foursquare.com") else {
            XCTAssertTrue(false, "Could not instantiate url")
            return
        }
    
        var urlRequest = URLRequest(url: url)
        let parameters: Parameters = ["client_id":clientId,
                                      "client_secret":clientSecret,
                                      "v":v,
                                      "ll":latlon,
                                      "query":query,
                                      "limit":10]
        
        do {
            let encoder = URLParameterEncoder()
            try encoder.encodeWithComponent(urlRequest: &urlRequest, with: parameters)
            guard let fullURL = urlRequest.url else {
                XCTAssertTrue(false, "urlRequest url is nil.")
                return
            }
            print(fullURL)
            let expectedURL =
                "https://api.foursquare.com?client_id=" + clientId + "&client_secret=" + clientSecret + "&v=" + v + "&ll=" + latlon + "&query=" + query + "&limit=" + "\(limit)"
            
            XCTAssertEqual(fullURL.absoluteString.sorted(), expectedURL.sorted())
            
        }catch {
            
        }
    }
    
    
    func testRouterBuildFourSquareRequest() {
        do {

            let router = NetworkRouter<FourSquareApi>()
            let request = try router.buildRequest(from: .exploreCoffeeShops(client_id: clientId, client_secret: clientSecret, v: v, ll: latlon, query: query, limit: limit))
            
            guard let fullURL = request.url else {
                XCTAssertTrue(false, "request url is nil.")
                return
            }
            print(fullURL)
            let expectedURL = "https://api.foursquare.com/v2/venues/explore?client_id=" + clientId + "&client_secret=" + clientSecret + "&v=" + v + "&ll=" + latlon + "&query=" + query + "&limit=" + "\(limit)"
            XCTAssertEqual(fullURL.absoluteString.sorted(), expectedURL.sorted())
        } catch {
            
        }
    }
    
    func testAddressToLatlonString() {
        let model = CoffeeShopViewModel.init()
        let address = "410 Townsend St, San Francisco, CA"

        let expectation = XCTestExpectation(description: "Convert address to latlon string.")
        model.convertAddressToLatLon(address: address) { (latlon) in
            guard let latlon = latlon else {
                XCTAssertTrue(false, "did not get latlon string.")
                return
            }
            let arr = latlon.split(separator: ",")
            print(latlon)
            let lat =  arr[0]
            let lon = arr[1]
            XCTAssertTrue(!lat.isEmpty, "was able to get lat string from address")
            XCTAssertTrue(!lon.isEmpty, "was able to get lon string from address")
            expectation.fulfill()
        }
        // Wait until the expectation is fulfilled, with a timeout of 5 seconds.
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
