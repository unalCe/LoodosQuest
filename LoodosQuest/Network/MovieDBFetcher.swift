//
//  MovieDBFetcher.swift
//  LoodosQuest
//
//  Created by Unal Celik on 18.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import Foundation
import Alamofire

class MovieDBFetcher {
    
    // Completion handler type for web service response.
    typealias ServiceResponse = ([Movie]?, Error?) -> Void
    
    // Send request for a given URL
    func fetch(_ url: URL, by fetchType: APIParameters.FetchType, completion: @escaping ServiceResponse) {
        Alamofire.request(url).responseJSON { (response) in
            if let error = response.error {
                // Request error occured. No data passed into completion handler
                completion(nil, error)
            } else if let data = response.data {
                
                // Create a decoder object & movies array.
                let decoder = JSONDecoder()
                var decodedMovies = [Movie]()
                
                print(url)
                
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
                    // use only for debugging
                    fatalError("Error occured while decoding data --> \(jsonErr)")
                }
            }
        }
    }
    
}
