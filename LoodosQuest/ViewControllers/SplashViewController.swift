//
//  ViewController.swift
//  LoodosQuest
//
//  Created by Unal Celik on 16.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import UIKit
import Network
import Hero

let homeSegueIdentifier = "homeSegue"

class SplashViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var splashTextLabel: UILabel!
    
    private var splashText: String? {
        didSet {
            splashTextLabel.text = splashText
            
            UIView.animate(withDuration: 0.7, animations: {
                self.splashTextLabel.isHidden = false
                self.splashTextLabel.alpha = 1.0
            }) { (completed) in
                if completed && self.connectedToInternet {
                    // Wait 3 seconds to perform segue after splash text has been set
                    self.perform(#selector(self.performHomeSegue), with: nil, afterDelay: 3)
                }
            }
        }
    }
    
    private let networkMonitor = NWPathMonitor()
    private var connectedToInternet = false

    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        fetchSplashTextFromRemoteConfig()
        checkInternetConnection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        splashTextLabel.alpha = 0
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
                self?.connectedToInternet = false
            } else {
                self?.connectedToInternet = true
            }
        }
        
        // Start the background thread for monitoring network changes.
        let queue = DispatchQueue(label: "Monitor")
        networkMonitor.start(queue: queue)
    }
    
    /// Fetch splash text from Remote Config.
    private func fetchSplashTextFromRemoteConfig() {
        RCFetcher.rcFetcher.fetchCompleteCallBack = { [weak self] in
            // Fetch raw string from Remote Config
            let rawString = RCFetcher.rcFetcher.stringValue(for: .splashText)
            
            // Remove the " character from string
            self?.splashText = rawString?.replacingOccurrences(of: "\"", with: "")
            
            // Set API Key from Remote Config for safety
            apiKey = RCFetcher.rcFetcher.stringValue(for: .apiKey)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == homeSegueIdentifier {
            let dest = segue.destination as! UINavigationController
            // Enable Hero transitions
            dest.hero.isEnabled = true
            // Selecting the Hero transition style
            dest.hero.modalAnimationType = .selectBy(presenting: .zoomSlide(direction: .left), dismissing: .zoomSlide(direction: .right))
        }
    }
    
    @objc func performHomeSegue() {
        self.performSegue(withIdentifier: homeSegueIdentifier, sender: nil)
    }
}

