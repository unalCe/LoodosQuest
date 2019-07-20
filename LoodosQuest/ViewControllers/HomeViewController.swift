//
//  HomeViewController.swift
//  LoodosQuest
//
//  Created by Unal Celik on 17.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import UIKit


// let url = URL(string: "http://www.omdbapi.com/?i=tt3896198&apikey=3639a762")!
// let url = URL(string: "http://www.omdbapi.com/?apikey=3639a762&type=movie&r=json&y=2019&s=the*&page=1")!
// tt0222012

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // MARK: - Properties
    @IBOutlet var homeTableView: UITableView!
    let movieDBFetcherService = MovieDBFetcher()
    
    var movies: [Movie]?
    
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
        
            DispatchQueue.main.async {
                self.movies = fetchedMovs
                self.homeTableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchMovie(by: .search, withTitle: searchText, withID: searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
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
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! FeedTableViewCell
        
        // !! The omdb API doesn't returns detailed information when searching multiple results by text. Fetch again by movieID for plot and genre details. The proper way to do this in MovieDBFetcher
        MovieDBFetcher.movieFetcher.fetchSingleMovie(withID: movies![indexPath.row].imdbID, plotType: .short, completion: { (fetchedMov, error) in
            if error == nil {
                cell.movie = fetchedMov
            }
        })
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! FeedTableViewCell
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
