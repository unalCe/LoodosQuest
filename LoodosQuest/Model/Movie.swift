//
//  Movie.swift
//  LoodosQuest
//
//  Created by Unal Celik on 17.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var title: String
    var year: String?
    var rated: String?
    var released: String?
    var runtime: String?
    var genre: String?
    var plot: String?
    var poster: URL?
    var ratings: [[String: String]]?
    var metaScore: String?
    var imdbRating: String?
    var imdbID: String
    var type: String?
    var response: String?
    var actors: String?
    var language: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case plot = "Plot"
        case poster = "Poster"
        case ratings = "Ratings"
        case metaScore = "Metascore"
        case imdbRating
        case imdbID
        case type = "Type"
        case response = "Response"
        case actors = "Actors"
        case language = "Language"
    }
}

struct SearchMovie: Codable {
    var Search: [Movie]
    var totalResults: String
    var Response: String
}
