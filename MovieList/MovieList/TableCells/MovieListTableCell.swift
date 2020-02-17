//
//  MovieListTableCell.swift
//  MovieList
//
//  Created by Tarun Mukesh Kinger on 15/02/20.
//  Copyright © 2020 Tarun Mukesh Kinger. All rights reserved.
//

import Foundation
import UIKit

/// MovieListTableCell to define custom UITableViewCell
class MovieListTableCell : UITableViewCell {
    
    /// UILabel for movie title
    @IBOutlet weak var movieTitleLabel: UILabel!
    /// UILabel for genre
    @IBOutlet weak var genreLabel: UILabel!
    /// UIImageView for poster Image
    @IBOutlet weak var posterImageView: UIImageView!
    
    /// Awake from nib method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// Method to update the cell with the movie details
    ///
    /// - Parameter movieDetail: MovieDetail model object
    func updateMovieDetail(_ movieDetail: MovieDetail?) {
        if let movieInfo = movieDetail {
            self.movieTitleLabel.text = movieInfo.movieTitle
            self.genreLabel.text = movieInfo.genre
            let imageURL = ((movieDetail?.posterImageURL) != nil) ?  movieDetail?.posterImageURL : movieDetail?.posterURL
            self.downloadImageFromURL(imageURL: imageURL?.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
}

extension MovieListTableCell {
    func downloadImageFromURL(imageURL :String?) {
        if let posterURL = imageURL {
            MovieDetailManager.execute(url: NSURL(string:posterURL)! as URL) { (data, error) in
                DispatchQueue.main.async {
                    if let data = data, let posterImage = UIImage(data: data) {
                        self.posterImageView.image = posterImage
                    } else {
                        self.posterImageView.image = UIImage(named: kNoImageAvailableName)
                    }
                }
            }
        } else {
            self.posterImageView.image = UIImage(named: kNoImageAvailableName)
        }
    }
}
