//
//  ViewController.swift
//  LoodosQuest
//
//  Created by Unal Celik on 16.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import UIKit
import Network


class SplashViewController: UIViewController {
    // MARK: - Properties
    private let networkMonitor = NWPathMonitor()
    
    private var splashText: String? {
        didSet {
            print(splashText!)
        }
    }

    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        fetchSplashTextFromRemoteConfig()
        checkInternetConnection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    // MARK: - Functions
    
    /// Checks if there are internet connection. If not, presents an alert.
    private func checkInternetConnection() {
        // This closure gets called at the beginning and every time the connection status changes.
        networkMonitor.pathUpdateHandler = { [weak self] path in
            if path.status != .satisfied {
                let alert = UIAlertController(title: "No Internet Connection 📶",
                                              message: "Please check your internet connection in settings.",
                                              preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Okay",
                                              style: UIAlertAction.Style.default,
                                              handler: nil))
                
                self?.present(alert, animated: true, completion: nil)
            } else {
                print("there are internet connection")
            }
        }
        
        // Start the background thread for monitoring network changes.
        let queue = DispatchQueue(label: "Monitor")
        networkMonitor.start(queue: queue)
    }
    
    /// Fetch splash text from remote config.
    private func fetchSplashTextFromRemoteConfig() {
        let rcFetcher = RCFetcher.rcFetcher
        
        rcFetcher.fetchCompleteCallBack = {
            self.splashText = rcFetcher.stringValue(for: .splash_text)
        }
    }

}

