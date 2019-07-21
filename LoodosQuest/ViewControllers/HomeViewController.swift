//
//  HomeViewController.swift
//  LoodosQuest
//
//  Created by Unal Celik on 17.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // MARK: - Properties
    @IBOutlet var homeTableView: UITableView!
    var activityIndicator: NVActivityIndicatorView!
    
    // MovieDBFetcher object to handle networking with Alamofire.
    let movieDBFetcherService = MovieDBFetcher()
    
    // Movie array that will be shown
    var movies = [Movie]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch once for placeholder movies.
        fetchMovie(by: .search, withTitle: "Godfather", withID: nil)
        
        setup(customTableView: homeTableView)
        setupSearchController()
        setupActivityIndicatorView()
        //startAnimatingActivityIndicator()
    }
    
/**
     Fetch movie data by searching for a given title or id
 
     - parameter fetchType: Search for movies or bring only one for a title
     - parameter title: Title that will be searched
     - parameter id: Movie ID that will be searched
     - parameter resultType: Movie, Series or Episode
     - parameter plotType: Short or full plot
 */
    private func fetchMovie(by fetchType: FetchType, withTitle title: String?, withID id: String?, in resultType: ResultType = .movie, with plotType: PlotType = .short) {
        
        DispatchQueue.main.async {
            self.handleActivityIndicator()
        }
        
        let apiParameters = APIParameters(apiKey: apiKey!, fetchType: fetchType, title: title, id: id, resultType: resultType, plotType: plotType)
        
        movieDBFetcherService.fetch(with: apiParameters) { (fetchedMovs, err) in
            
            if fetchedMovs != nil, err == nil {
                
                // OMDB API doesn't return detailed results when searching multiple results by text.
                // Fetch detailedmovies for searched movies
                self.movieDBFetcherService.fetchDetailedMovies(for: fetchedMovs!, plotType: .short, completion: { (movies, err) in
                    if err == nil, let detailedMovies = movies {
                        self.movies = detailedMovies
                        
                        // Sort movies by imdbRatings
                        self.movies.sort {
                            guard let firstRating = $0.imdbRating, let secondRating = $1.imdbRating, let doubleFirstRating = Double(firstRating), let doubleSecondRating = Double(secondRating) else { return false }
                            return doubleFirstRating > doubleSecondRating
                        }
                        
                        self.homeTableView.reloadData()
                        self.handleActivityIndicator()
                    } else {
                        // Debugging only.
                        print("Error while fetching detailed movies: " + err.debugDescription)
                    }
                })
            } else {
                // If the search results are not there, clear movies and show empty table view data
                self.movies = []
                self.homeTableView.reloadData()
                self.handleActivityIndicator()
                print("Error while fetching searched movies: " + err.debugDescription) }
        }
    }
    
    // Start or stop activity animation depending on the current situation
    private func handleActivityIndicator() {
        let isActiveAlready = activityIndicator.isAnimating
        
        if isActiveAlready {
            homeTableView.removeBlurEffect()
            activityIndicator.stopAnimating()
        } else {
            homeTableView.addBlurEffect()
            activityIndicator.startAnimating()
        }
        
        homeTableView.isUserInteractionEnabled = isActiveAlready
        activityIndicator.isHidden = isActiveAlready
    }
    
    // MARK: - Customizations
    // Setup Custom Table View
    private func setup(customTableView: UITableView) {
        customTableView.delegate = self
        customTableView.dataSource = self
        customTableView.estimatedRowHeight = 360
        customTableView.rowHeight = UITableView.automaticDimension
        customTableView.tableFooterView = UIView()
    }
    
    // Setup Search Controller
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Movies"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // Setup Activity Indicator View for animating
    private func setupActivityIndicatorView() {
        let oneThirdOfTableWidth = homeTableView.bounds.width / 3
        let frameForActivityIndicatorView = CGRect(x: oneThirdOfTableWidth, y: (navigationController?.navigationBar.frame.maxY)! + 160, width: oneThirdOfTableWidth, height: oneThirdOfTableWidth)
        
        activityIndicator = NVActivityIndicatorView(frame: frameForActivityIndicatorView)
        view.addSubview(activityIndicator)
        
        activityIndicator.type = .ballTrianglePath
        activityIndicator.isHidden = true
    }
    
    // MARK: - SearchBar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchMovie(by: .search, withTitle: searchText, withID: searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movies.count == 0 {
            let noMovieImageView: UIImageView = {
                let miv = UIImageView()
                miv.image = UIImage(named: "noMoviesFound")
                miv.contentMode = .scaleAspectFit
                return miv
            }()
            homeTableView.backgroundView = noMovieImageView
        } else {
            homeTableView.backgroundView = nil
        }
        
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! FeedTableViewCell
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! FeedTableViewCell
        // Stop image retrieve tasks for cells that are not being displayed anymore.
        cell.imageRetrieveTask?.cancel()
    }
    
    // TODO: Try UITableViewDataSourcePrefetchingDelegate protocol
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    //    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail", let dest = segue.destination as? MovieDetailViewController, let cellIndex = homeTableView.indexPathForSelectedRow {
            dest.movie = movies[cellIndex.row]
        }
    }
}
