//
//  MovieDetailManager.swift
//  MovieList
//
//  Created by Tarun Mukesh Kinger on 16/02/20.
//  Copyright © 2020 Tarun Mukesh Kinger. All rights reserved.
//

import Foundation
import UIKit

/// MovieDetailManager to handle network operations
class MovieDetailManager: NSObject {
    
    /// URL session object
    static let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: .main)
    
    /// Method to fetch movies list from the URL
    ///
    /// - Parameter callBack: callback that returns MovieDetail array object and Error object
    class func fetchMovieDetails(callBack: @escaping (_ movies: [MovieDetail]?, _ error: Error?) -> Void) {

        let url = URL(string: kMovieListURL)!
        
        MovieDetailManager.execute(url: url) { (data, error) in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                var moviesArray = [MovieDetail]()
                if let moviesList = try? decoder.decode(Movies.self, from: data) {
                    for movieDetail in moviesList.movies {
                        moviesArray.append(movieDetail)
                    }
                    callBack(moviesArray, nil)
                }
            } else if error != nil {
                callBack(nil, error)
            }
        }
    }
}

// MARK: - Extension to handle service call
extension MovieDetailManager {
    
    /// Method to execute service call using URL Session
    ///
    /// - Parameters:
    ///   - url: URL to make the service call
    ///   - completion: completion block that returns the response as Data and Error object if any
    class func execute(url: URL, withCompletion completion: @escaping (Data?, Error?) -> Void) {
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, _, error: Error?) -> Void in
            if (data != nil) {
            completion(data, nil)
            } else if (error != nil) {
                completion(nil, error)
            } else {
                completion(nil, nil)
            }
        })
        task.resume()
    }
}

