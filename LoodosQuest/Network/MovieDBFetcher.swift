//
//  MovieDBFetcher.swift
//  LoodosQuest
//
//  Created by Unal Celik on 18.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import Foundation
import Alamofire

//enum NetworkError: Error {
//    case responseError
//    case decodingError
//}

class MovieDBFetcher {
    
    // Completion handler type for web service response.
    typealias ServiceResponse = ([Movie]?, Error?) -> Void
    
    // Data request object to cancel any old tasks.
    private var dataRequest: DataRequest? {
        didSet {
            oldValue?.cancel()
        }
    }
    
/**
     Send request for a given URL and fetch data
     
     - parameter url: URL to request
     - parameter fetchType: Search multiple movies or fetch one by title/id
     - parameter completion: ServiceResponse method to use fetched data
 */
    func fetch(_ url: URL, by fetchType: APIParameters.FetchType = .search, completion: @escaping ServiceResponse) {
        
        print(url)
        
        // Set the data request so the old task will be stopped.
        dataRequest = Alamofire.request(url).responseJSON { (response) in
            if response.error != nil {
                // Request error occured. No data passed into completion handler
                completion(nil, response.error)
            } else if let data = response.data {
                
                // Create a decoder object & movies array.
                let decoder = JSONDecoder()
                var decodedMovies = [Movie]()
                
                do {
                    // Switch decoding style depending on the fetch type.
                    switch fetchType {
                    case .search:
                        // Decode data into SearchMovie object which also contains a Movie array.
                        let decodedMovie = try decoder.decode(SearchMovie.self, from: data)
                        decodedMovies.append(contentsOf: decodedMovie.Search)
                    case .id, .title:
                        // Decode data into single Movie object.
                        let decodedMovie = try decoder.decode(Movie.self, from: data)
                        decodedMovies.append(decodedMovie)
                    }
                    
                    // Completion handler.
                    completion(decodedMovies, nil)
                } catch let jsonErr {
                    // Send error to completion.
                    completion(nil, jsonErr)
                }
            }
        }
    }
    
    
}
