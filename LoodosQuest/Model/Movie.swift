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
    var year: String
    var rated: String
    var released: Date
    var runtime: TimeInterval
    var genre: String
    var director: String
    var writer: String
    var actors: String
    var plot: String
    var language: String
    var awards: String
    var poster: URL
    var metaScore: Double
    var imdbRating: Double
    var imdbVotes: Int
    var imdbID: String
    var type: String
    var production: String
    var website: URL
    var response: Bool
}
