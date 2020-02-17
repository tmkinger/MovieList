//
//  MovieViewModel.swift
//  MovieList
//
//  Created by Tarun Mukesh Kinger on 16/02/20.
//  Copyright © 2020 Tarun Mukesh Kinger. All rights reserved.
//

import Foundation
import UIKit

/// Root struct to parse movies array from the JSON
public struct Movies: Decodable {
    var movies: [MovieDetail]
}

/// MovieDetail struct to parse the movie detail dictionaries from the JSON
public struct MovieDetail: Decodable {
    var movieTitle: String?
    var genre: String?
    var year: String?
    var rating: String?
    var releaseDate: String?
    var runTime: String?
    var director: String?
    var writer: String?
    var actors: String?
    var plot: String?
    var language: String?
    var country: String?
    var awards: String?
    var posterImageURL: String?
    var posterURL: String?
}

// MARK: - Extension to define coding keys for the properties
extension MovieDetail {
    
    enum CodingKeys: String, CodingKey {
        case movieTitle = "Title"
        case genre = "Genre"
        case year = "Year"
        case rating = "Rated"
        case releaseDate = "Released"
        case runTime = "Runtime"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case posterImageURL = "Poster"
        case posterURL = "Poster "
    }
    
    /// Init method for Decoder
    ///
    /// - Parameter decoder: Decoder object
    /// - Throws: exception handler
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        movieTitle = try container.decodeIfPresent(String.self, forKey: .movieTitle)
        genre = try container.decodeIfPresent(String.self, forKey: .genre)
        year = try container.decodeIfPresent(String.self, forKey: .year)
        rating = try container.decodeIfPresent(String.self, forKey: .rating)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        runTime = try container.decodeIfPresent(String.self, forKey: .runTime)
        director = try container.decodeIfPresent(String.self, forKey: .director)
        writer = try container.decodeIfPresent(String.self, forKey: .writer)
        actors = try container.decodeIfPresent(String.self, forKey: .actors)
        plot = try container.decodeIfPresent(String.self, forKey: .plot)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        awards = try container.decodeIfPresent(String.self, forKey: .awards)
        posterImageURL = try container.decodeIfPresent(String.self, forKey: .posterImageURL)
        posterURL = try container.decodeIfPresent(String.self, forKey: .posterURL)
    }
}

