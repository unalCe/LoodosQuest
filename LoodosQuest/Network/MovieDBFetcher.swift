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
    
    let dispatchGroup = DispatchGroup()
    
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

        dispatchGroup.enter()
        
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
            self.dispatchGroup.leave()
        }
    }
    
    
    func fetchDetailedMovies(for movies: [Movie], plotType: PlotType, completion: @escaping SearchServiceResponse) {
        var detailedMovies = [Movie]()
        var err: Error?
        
        var apiParameters = APIParameters(apiKey: apiKey!, fetchType: .id, title: nil, id: nil, resultType: .movie, plotType: plotType)
        
        dispatchGroup.enter()
        for movIndex in movies.indices {
            apiParameters.id = movies[movIndex].imdbID
            
            let url = apiParameters.bringFullURL()

            Alamofire.request(url).response(completionHandler: { (response) in
                if response.error == nil, let data = response.data {
                    do {
                        let decodedMovie = try JSONDecoder().decode(Movie.self, from: data)
                        detailedMovies.append(decodedMovie)
                    } catch {
                        err = error
                    }
                } else {
                    err = response.error
                }
                
                if movIndex == movies.count - 1 {
                    self.dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            print(detailedMovies)
            completion(detailedMovies, err)
        }
    }
}
