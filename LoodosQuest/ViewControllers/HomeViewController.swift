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



class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    @IBOutlet var homeTableView: UITableView!
    let movieDBFetcherService = MovieDBFetcher()
    
    var movie: Movie?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let apiParameters = APIParameters(apiKey: apiKey!, fetchType: .title, title: "Fast ", id: nil)
        let newURL = apiParameters.bringFullURL(for: .movie, plotType: .short)
        
        movieDBFetcherService.fetch(newURL, by: apiParameters.fetchType!) { (movies, err) in
            
            // TODO: - Replace single movie with an array.
            DispatchQueue.main.async {
                self.movie = movies?.first
                self.homeTableView.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.estimatedRowHeight = 360
        homeTableView.rowHeight = UITableView.automaticDimension
        
    }
    
    // MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! FeedTableViewCell
        cell.movieImageView.backgroundColor = .orange
        cell.movieNameLabel.text = movie?.title
        cell.movieDescriptionLabel.text = movie?.plot
        cell.movieGenreLabel.text = "Genre: " + (movie?.genre ?? "")
        cell.imdbScoreLabel.text = "IMDB Score: " + (movie?.imdbRating ?? "")
        // cell.movieDescriptionLabel.text = "işte şimdi askldjaskldjalksd ulaa doldur doldur. \n aşağı da geçtim ooh artık yok öyle tek satır olayım falan... işte şimdi askldjaskldjalksd ulaa doldur doldur. \n aşağı da geçtim ooh artık yok öyle tek satır olayım falan... işte şimdi askldjaskldjalksd ulaa doldur doldur. \n aşağı da geçtim ooh artık yok öyle tek satır olayım falan... işte şimdi askldjaskldjalksd ulaa doldur doldur. \n aşağı da geçtim ooh artık yok öyle tek satır olayım falan... "
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
