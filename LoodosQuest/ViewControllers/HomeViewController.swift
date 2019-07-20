//
//  HomeViewController.swift
//  LoodosQuest
//
//  Created by Unal Celik on 17.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // MARK: - Properties
    @IBOutlet var homeTableView: UITableView!
    
    // MovieDBFetcher object to handle networking with Alamofire.
    let movieDBFetcherService = MovieDBFetcher()
    
    // Movie array that will be shown
    var movies = [Movie]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(customTableView: homeTableView)
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMovie(by: .search, withTitle: "Godfather", withID: nil)
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
        
        let apiParameters = APIParameters(apiKey: apiKey!, fetchType: fetchType, title: title, id: id, resultType: resultType, plotType: plotType)
        
        movieDBFetcherService.fetch(with: apiParameters) { (fetchedMovs, err) in
            
            if fetchedMovs != nil, err == nil {
                
                // OMDB API doesn't return detailed results when searching multiple results by text.
                // Fetch detailedmovies for searched movies
                self.movieDBFetcherService.fetchDetailedMovies(for: fetchedMovs!, plotType: .short, completion: { (movies, err) in
                    if err == nil, let detailedMovies = movies {
                            self.movies = detailedMovies
                            self.homeTableView.reloadData()
                    } else {
                        // Debugging only.
                        print("Error while fetching detailed movies: " + err.debugDescription)
                    }
                })
            } else { print("Error while fetching searched movies: " + err.debugDescription) }
        }
    }
    
    // MARK: - Customizations
    // Setup Custom Table View
    func setup(customTableView: UITableView) {
        customTableView.delegate = self
        customTableView.dataSource = self
        customTableView.estimatedRowHeight = 360
        customTableView.rowHeight = UITableView.automaticDimension
        customTableView.tableFooterView = UIView()
    }
    
    // Setup Search Controller
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Movies"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
        return self.movies.count
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
    //        let cell = homeTableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! FeedTableViewCell
    //        cell.movie = self.movies?[indexPath.row]
    //    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
