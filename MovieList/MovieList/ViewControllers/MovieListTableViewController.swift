//
//  MovieListTableViewController.swift
//  MovieList
//
//  Created by Tarun Mukesh Kinger on 15/02/20.
//  Copyright © 2020 Tarun Mukesh Kinger. All rights reserved.
//

import Foundation
import UIKit

/// MovieListTableViewController to display Movies List
class MovieListTableViewController: UITableViewController {
    
    /// movieDetails array to store list of MovieDetail objects
    var movieDetails: [MovieDetail] = []
    
    /// Activity Indicator view
    var indicator = UIActivityIndicatorView()
    
    /// Retry Button for service failure or error state
    var retryButton = UIButton()

    
    /// Overriding super viewdidload
    /// Setup UI for this class
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kMovieListTitle
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        createActivityIndicator()
        createRetryButton()
        fetchMovieDetails()
    }
    
    /// Method to create and initialize activity indicator view
    func createActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.whiteLarge
        indicator.center = self.view.center
        indicator.backgroundColor = .clear
        self.view.addSubview(indicator)
    }
    
    /// Method to create a Retry button
    func createRetryButton() {
        retryButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        retryButton.center = self.view.center
        retryButton.setTitle(kRetry, for: .normal)
        retryButton.backgroundColor = .clear
        retryButton.setTitleColor(UIColor.white, for: .normal)
        retryButton.addTarget(self, action:#selector(fetchMovieDetails), for: .touchUpInside)
        retryButton.isHidden = true
        self.view.addSubview(retryButton)
    }
    
    /// Method to fetch list of movie details
    @objc func fetchMovieDetails() {
        retryButton.isHidden = true
        indicator.startAnimating()
        
        // Fetch list of movies
        MovieDetailManager.fetchMovieDetails(callBack: { (movies, error) in
            if let movieDetails = movies {
                
                // check and rearrange if persisted order is available
                self.movieDetails = self.checkAndReorderMoviesList(movieDetails)
                self.tableView.separatorStyle = .singleLine
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.tableView.reloadData()
            } else if let errorMsg = error {
                self.showErrorAlert(errorMsg)
            }
            self.indicator.stopAnimating()
        })
    }
    
    /// Method to fetch saved order of movies and rearrange the array
    ///
    /// - Parameter moviesList: movies list from response
    /// - Returns: Sorted movies list based on user's order
    func checkAndReorderMoviesList(_ moviesList: [MovieDetail]) -> [MovieDetail] {
        let defaults = UserDefaults.standard
        if let savedArray = defaults.stringArray(forKey: kSavedMovieTitlesArray) {
            let sortedMoviesList = moviesList.sorted { savedArray.firstIndex(of: $0.movieTitle!)! < savedArray.firstIndex(of: $1.movieTitle!)! }
            return sortedMoviesList
        }
        return moviesList
    }
    
    /// Method to display error alert message
    ///
    /// - Parameter errorMsg: Error object
    func showErrorAlert(_ errorMsg: Error) {
        let alert = UIAlertController(title: kErrorTitle, message: errorMsg.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: kOK, style: UIAlertAction.Style.default, handler: { _ in
            // Cancel Action
            self.retryButton.isHidden = false
        }))
        
        alert.addAction(UIAlertAction(title: kRetry,
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        // Retry  action
                                        self.fetchMovieDetails()
                                        
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    /// Method to persist the rearranged list of movie titles if user changes the order
    func persistRearrangedMoviesList() {
        var movieTitlesArray = [String]()
        for movie in movieDetails {
            movieTitlesArray.append(movie.movieTitle!)
        }
        let defaults = UserDefaults.standard
        defaults.set(movieTitlesArray, forKey: kSavedMovieTitlesArray)
    }
    
}

// MARK: UITableViewDataSource && UITableViewDelegate
extension MovieListTableViewController {
    
    // MARK: UITableViewDataSource
    
    /// Method to return the number of sections in the tableview
    ///
    /// - Parameter _: UITableView object
    /// - Returns: int value of number of sections
    open override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }
    
    /// Get number of rows from section
    ///
    /// - Parameters:
    ///   - _: TableView
    ///   - section: Number of section
    /// - Returns: Number of section
    open override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.movieDetails.count
    }
    
    /// Method will return height For Row
    ///
    /// - Parameters:
    ///   - _: UITableView object
    ///   - indexPath: IndexPath value for row
    /// - Returns: CGFloat for height
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(kCellHeight)
    }

    /// Table view cell for row at index path method
    ///
    /// - Parameters:
    ///   - _: table view instance
    ///   - indexPath: index path value
    /// - Returns: UITableViewCell object
    open override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let movieListCell = tableView.dequeueReusableCell(withIdentifier: kMovieListTableCellIdentifier) as? MovieListTableCell {
            movieListCell.posterImageView?.image = nil
            let movieDetail = movieDetails[indexPath.row]
            movieListCell.updateMovieDetail(movieDetail)
            cell = movieListCell
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    /// Called after the user changes the selection.
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: indexPath
    open override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: kStoryBoardName, bundle: nil)
        if let detailOrderVC = storyboard.instantiateViewController(withIdentifier: kMovieDetailViewControllerIdentifier) as? MovieDetailViewController {
            detailOrderVC.movieDetailModel = movieDetails[indexPath.row]
            self.navigationController?.pushViewController(detailOrderVC, animated: true)
        }
    }
    
    /// Method to return editing style for the row
    ///
    /// - Parameters:
    ///   - tableView: table view instance
    ///   - indexPath: index path value
    /// - Returns: Editing Style type
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    /// Method to return if indentation is required in editing mode
    ///
    /// - Parameters:
    ///   - tableView: table view instance
    ///   - indexPath: index path value
    /// - Returns: Bool value of indentation required
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /// Method called after row is reordered
    ///
    /// - Parameters:
    ///   - tableView: table view instance
    ///   - sourceIndexPath: source index path value
    ///   - destinationIndexPath: destination index path value
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movieDetail = movieDetails[sourceIndexPath.row]
        movieDetails.remove(at: sourceIndexPath.row)
        movieDetails.insert(movieDetail, at: destinationIndexPath.row)
        persistRearrangedMoviesList()
    }
}



