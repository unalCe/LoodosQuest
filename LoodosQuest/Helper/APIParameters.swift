//
//  APIParameters.swift
//  LoodosQuest
//
//  Created by Unal Celik on 18.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import Foundation

// Structure for handling API call parameters.
struct APIParameters {
    let baseURL = "http://www.omdbapi.com/?&apikey="
    private let apiKey: String
    
    // Movie title that will be fetched
    var title: String?
    // Movie id that will be fetched
    var id: String?
    // Fetching with title,id or searching
    var fetchType: FetchType?
    
    enum FetchType: String {
        case title = "&t="
        case id = "&i="
        case search = "&s="
    }
    
    enum ResultType: String {
        case movie = "&type=movie"
        case series = "&type=series"
        case episode = "&type=episode"
    }
    
    enum PlotType: String {
        case short = "&plot=short"
        case full = "&plot=full"
    }
    
    /**
     Returns full URL depending on the input parameters

     - parameter resultType: Searching for movies, series or episodes
     - parameter plotType: Fetch plot as short or long description

     - returns: Specified URL for given parameters
     */
    
    func bringFullURL(for resultType: ResultType?, plotType: PlotType?) -> URL {
        let baseWithAPIKey = baseURL + apiKey
        let withTypeParametersAdded = baseWithAPIKey + (resultType?.rawValue ?? "") + (plotType?.rawValue ?? "")
        let withSearchParametersAdded = withTypeParametersAdded + (fetchType?.rawValue ?? "") + (title ?? "") + (id ?? "")
        return URL(string: withSearchParametersAdded)!
    }
    
    /**
     Initializer for APIParameters
     
     - parameter apiKey: API Key
     - parameter fetchType: Search for multiple movies or return a single movie based on title or id.
     - parameter title: Movie title to be searched.
     - parameter id: Movie id to be searched.
     */
    
    init(apiKey: String, fetchType: FetchType, title: String?, id: String?) {
        // Lowercase the string and replace the blank spaces with API friendly "-"
        let apiTitle = title?.lowercased().replacingOccurrences(of: " ", with: "-")
        
        self.fetchType = fetchType
        self.apiKey = apiKey
        self.title = apiTitle
        self.id = id
    }
}
