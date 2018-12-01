//
//  CoffeeShopListViewController.swift
//  CoffeeShopsNearMe
//
//  Created by Zhang, Wanming - (p) on 11/29/18.
//  Copyright © 2018 WanmingZhang. All rights reserved.
//

import UIKit

class CoffeeShopListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let envoyAddress = "410 Townsend St, San Francisco, CA"
    
    let kCoffeeShopListCellIdentifier = "CoffeeShopListViewCell"
    
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = CoffeeShopViewModel()
    var retryCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: kCoffeeShopListCellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: kCoffeeShopListCellIdentifier)
        self.tableView.rowHeight = 120
        // Do any additional setup after loading the view.
        self.viewModel.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchCoffeeShopsList), name:UIApplication.didBecomeActiveNotification,  object: nil)
    }
    
    @objc func fetchCoffeeShopsList() {
        self.viewModel.convertAddressToLatLon(address: envoyAddress) { (latlon) in
            self.viewModel.fetchCoffeeShops(near: latlon ?? "37.7752996,-122.398058") 
        }
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.responseGroup?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCoffeeShopListCellIdentifier, for: indexPath) as! CoffeeShopListViewCell
        

        return cell
    }
 
}

// MARK: FetchCoffeeShopsCompletedProtocol
extension CoffeeShopListViewController: FetchCoffeeShopsCompletedProtocol {

    // if request fails, automatically retry for 3 times
    // notify user after 3 retries.
    func onFetchFailed(with error: String) {
        print("Request to server was failed: \(error)")
        if(self.retryCounter < 1) {
            self.viewModel.fetchCoffeeShops(near: envoyAddress)
            retryCounter += 1
        } else {
            // notify user
            self.showAlert(with: "Not able to retrieve product list at the moment.", message: error)
        }
        return
    }
    
    func onFetchCompleted(with coffeeShops: [FindCoffeeShopApiResponse.CoffeeShopGroup] ) {
        
        self.tableView.reloadData()
        for coffeeShop in coffeeShops {
            
            for item in coffeeShop.items {
                let name = item.venue.name
                print(name)
                let addressArr = item.venue.location.formattedAddress

                
                
                
                
            }
            
        }
        
        //tableView.reloadData()

    }
    
    func updateCoffeeShopsCount() {
//        let countStr = String(self.viewModel.totalProductCount)
//        self.productCountLabel.text = countStr + " Total Products"
    }
    
    func showAlert(with title: String, message: String) {
        let okTitle = "OK"
        let alert: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: okTitle, style: .default) { (okAction) in
            NSLog("user tapped ok")
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
