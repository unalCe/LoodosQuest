//
//  RCFetcher.swift
//  LoodosQuest
//
//  Created by Unal Celik on 17.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import Foundation
import Firebase

enum RemoteConfigKeyValues: String {
    case splash_text
}

class RCFetcher {
    // MARK: - Properties
    private(set) var fetchDuration: TimeInterval = 0
    static let rcFetcher = RCFetcher()
    
    /// Callback function that will be triggered from other view controllers when the fetching is activated and completed.
    var fetchCompleteCallBack: (() -> Void)?
    
    // MARK: - Initializer
    private init() {
        fetchRemoteConfigValues()
    }
    
    // MARK: - Functions
    private func fetchRemoteConfigValues() {
        activateDebugMode()
        
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { [weak self] (status, error) in
            // If any error occures while fetching, print the error and return.
            if let error = error {
                print("Error occured. -- \(error.localizedDescription)")
                return
            }
            
            // Apply fetched config data and update behavior with callback function
            RemoteConfig.remoteConfig().activate(completionHandler: { (error) in
                
                // This completion handler needs to update UI so do it on main thread.
                DispatchQueue.main.async {
                    self?.fetchCompleteCallBack?()
                }
            })
        }
    }
    
    /// Set the minimumFetchInterval to zero for being able to fetch from the remote without limitations.
    private func activateDebugMode() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = fetchDuration
        RemoteConfig.remoteConfig().configSettings = settings
    }
    
    /**
     Bring string represantation of the remote config value for a given key
     
     - parameter for: RemoteConfigKeyValue
     
     - returns: Optional String value of remote config value
     */
    func stringValue(for key: RemoteConfigKeyValues) -> String? {
        return RemoteConfig.remoteConfig() [key.rawValue].stringValue
    }
}
