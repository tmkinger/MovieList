//
//  MovieDetailViewController.swift
//  MovieList
//
//  Created by Tarun Mukesh Kinger on 15/02/20.
//  Copyright © 2020 Tarun Mukesh Kinger. All rights reserved.
//

import Foundation
import UIKit

/// MovieDetailViewController class to handle the Movie Detail screen
class MovieDetailViewController: UIViewController {
    
    /// UILabel for date
    @IBOutlet weak var movieTitleLabel: UILabel!
    /// UILabel for detail
    @IBOutlet weak var posterImageView: UIImageView!
    /// UILabel for date
    @IBOutlet weak var detailLabel: UILabel!
    /// UILabel for order number
    @IBOutlet weak var actorsLabel: UILabel!
    /// UILabel for detail
    @IBOutlet weak var directorLabel: UILabel!
    /// UILabel for date
    @IBOutlet weak var writerLabel: UILabel!
    /// UILabel for order number
    @IBOutlet weak var languageLabel: UILabel!
    /// UILabel for detail
    @IBOutlet weak var countryLabel: UILabel!
    /// UILabel for date
    @IBOutlet weak var plotLabel: UILabel!
    /// UILabel for order number
    @IBOutlet weak var awardsLabel: UILabel!
    
    /// MovieDetail object to display the detail
    var movieDetailModel: MovieDetail?
    
    
    /// Overriding super viewdidload
    /// Setup UI for this class
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = movieDetailModel?.movieTitle ?? ""

        updateViewWithMovieModel()
    }

    /// Method to updatet the UI using the movies view model
    func updateViewWithMovieModel() {
        if let movieModel = self.movieDetailModel {
            let releaseYear = movieModel.year?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.movieTitleLabel.text = (movieModel.movieTitle ?? "") + "(\(releaseYear))"
            
            self.actorsLabel.attributedText = formAttributedString(kActors, movieModel.actors ?? "")
            self.directorLabel.attributedText = formAttributedString(kDirector, movieModel.director ?? "")
            self.writerLabel.attributedText = formAttributedString(kWriter, movieModel.writer ?? "")
            self.languageLabel.attributedText = formAttributedString(kLanguage, movieModel.language ?? "")
            self.countryLabel.attributedText = formAttributedString(kCountry, movieModel.country ?? "")
            self.plotLabel.attributedText = formAttributedString(kPlot, movieModel.plot ?? "")
            self.awardsLabel.attributedText = formAttributedString(kAwards, movieModel.awards ?? "")
            
            let imageURL = ((movieModel.posterImageURL) != nil) ?  movieModel.posterImageURL : movieModel.posterURL
            self.downloadImageFromURL(imageURL: imageURL?.trimmingCharacters(in: .whitespacesAndNewlines))
            updateDetailsLabel(movieModel)
        }
    }
    
    /// Method to update the details label to display runtime, rating, release date and genre
    ///
    /// - Parameter movieDetailModel: MovieDetail object
    func updateDetailsLabel(_ movieDetailModel: MovieDetail) {
        let rating = movieDetailModel.rating ?? ""
        let runTime = movieDetailModel.runTime ?? ""
        let genre = movieDetailModel.genre ?? ""
        let releaseDate = movieDetailModel.releaseDate ?? ""

        self.detailLabel.text = rating + " | " + runTime + " | " + genre + " | " + releaseDate
    }
    
    /// Method to form attributed string to display bold white text for the item and regular text for the value
    ///
    /// - Parameters:
    ///   - keyString: Item string
    ///   - valueString: Value string
    /// - Returns: combined attributed string
    func formAttributedString(_ keyString: String, _ valueString: String) -> NSAttributedString {
        
        let keyAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)]
        let valueAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19)]
        
        let partOne = NSMutableAttributedString(string: keyString, attributes: keyAttributes)
        let partTwo = NSMutableAttributedString(string: valueString, attributes: valueAttributes)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        
        return combination
    }
    
    /// Method to download poster image
    ///
    /// - Parameter imageURL: image URL for the poster
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
