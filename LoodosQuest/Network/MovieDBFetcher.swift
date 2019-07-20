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
    typealias SearchServiceResponse = ([Movie]?, Error?) -> Void
    
    // A DispatchGroup to control fetching threads.
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
     - parameter completion: SearchServiceResponse method to use fetched data
 */
    func fetch(with apiParameters : APIParameters, completion: @escaping SearchServiceResponse) {
        
        let url = apiParameters.bringFullURL()

        // Enter Dispatch
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
            // Leave DispatchGroup when Alamofire request ends.
            self.dispatchGroup.leave()
        }
    }
  
    /**
     Fetch all details about given movies
     
     - parameter movies: Movies that more details needed
     - parameter plotType: Short or long plot type
     - parameter completion: SearchServiceResponse method to use fetched data
     */
    func fetchDetailedMovies(for movies: [Movie], plotType: PlotType, completion: @escaping SearchServiceResponse) {
        // Create a Movie array and an Error object that will be filled while fetching and will be sent in completion handler
        var detailedMovies = [Movie]()
        var fetchError: Error?
        
        var apiParameters = APIParameters(apiKey: apiKey!, fetchType: .id, title: nil, id: nil, resultType: .movie, plotType: plotType)
        
        // Enter DispatchGroup again.
        dispatchGroup.enter()
        for movIndex in movies.indices {
            // Change API parameters for a specific movie ID
            apiParameters.id = movies[movIndex].imdbID
            
            // Bring an URL for that id
            let url = apiParameters.bringFullURL()

            Alamofire.request(url).response(completionHandler: { (response) in
                if response.error == nil, let data = response.data {
                    do {
                        let decodedMovie = try JSONDecoder().decode(Movie.self, from: data)
                        detailedMovies.append(decodedMovie)
                    } catch {
                        fetchError = error
                    }
                } else {
                    fetchError = response.error
                }
                
                // Leave the DispatchGroup when last movie fetching is done.
                if movIndex == movies.count - 1 {
                    self.dispatchGroup.leave()
                }
            })
        }
        
        // Notify when background fetch request is done. Handle completion in main queue.
        dispatchGroup.notify(queue: .main) {
            completion(detailedMovies, fetchError)
        }
    }
}
