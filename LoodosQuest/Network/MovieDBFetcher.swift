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
    
    static let movieFetcher = MovieDBFetcher()
    
    // Completion handler type for web service response.
    typealias SearchServiceResponse = ([Movie]?, Error?) -> Void
    typealias SingleMovieServiceResponse = (Movie? , Error?) -> Void
    
    // Data request object to cancel any old tasks.
    private var dataRequest: DataRequest? {
        didSet {
            oldValue?.cancel()
        }
    }
    
/**
     General fetch method. Send request for a given URL and fetch data
     
     - parameter url: URL to request
     - parameter fetchType: Search multiple movies or fetch one by title/id
     - parameter completion: ServiceResponse method to use fetched data
 */
    func fetch(with apiParameters : APIParameters, completion: @escaping SearchServiceResponse) {
        
        let url = apiParameters.bringFullURL()
        
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
                    switch apiParameters.fetchType! {
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
    
    
    
    func fetchSingleMovie(withID: String, plotType: PlotType, completion: @escaping SingleMovieServiceResponse) {
        let apiParameters = APIParameters(apiKey: apiKey!, fetchType: .id, title: nil, id: withID, resultType: .movie, plotType: plotType)
        
        fetch(with: apiParameters) { (movs, err) in
            if err != nil { completion(nil, err) }
            else { completion(movs?.first, nil) }
        }
    }
}
