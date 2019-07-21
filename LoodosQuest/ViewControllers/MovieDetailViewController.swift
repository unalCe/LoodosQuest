//
//  MovieDetailViewController.swift
//  LoodosQuest
//
//  Created by Unal Celik on 20.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAnalytics

class MovieDetailViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var lenghtLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    
    //
    var movie: Movie? {
        didSet {
            fetchFullPlot(for: movie!)
        }
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always

        updateUI()
    }
    
    /// Fetch full plot for a detailed movie description.
    private func fetchFullPlot(for movie: Movie) {
        let moviePlotFetcher = MovieDBFetcher()
        moviePlotFetcher.fetch(with: APIParameters(apiKey: apiKey!, fetchType: .id, title: nil, id: movie.imdbID, resultType: .movie, plotType: .full)) { (movs, err) in
            if err == nil, let movie = movs?.first {
                DispatchQueue.main.async {
                    // Set the plot text when fetching is complete.
                    self.plotLabel.text = movie.plot
                    
                    // Log event depending on the needed information
                    Analytics.logEvent("movie_viewed", parameters: ["movie_id": movie.imdbID, "movie_name" : movie.title, "movie_genre": (movie.genre ?? "Unknown")])
                }
            }
        }
    }
    
    /// Update UI according to movie properties
    private func updateUI() {
        navigationItem.title = movie?.title
        
        // No need to set activity indicator here, images already cached by url.
        movieImageView.kf.setImage(with: movie?.poster, placeholder: UIImage(named: "NoMovieImage"), options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
            ])
        movieImageView.layer.cornerRadius = 16
        movieImageView.clipsToBounds = true
        
        // Set label texts to movie information.
        genreLabel.attributedText = NSMutableAttributedString().bold("Genre: ").normal(movie?.genre ?? "Unknown")
        yearLabel.attributedText = NSMutableAttributedString().bold("Year: ").normal(movie?.year ?? "Unknown")
        lenghtLabel.attributedText = NSMutableAttributedString().bold("Lenght: ").normal(movie?.runtime ?? "Unknown")
        actorsLabel.attributedText = NSMutableAttributedString().bold("Actors: ").normal(movie?.actors ?? "Unknown")
        languageLabel.attributedText = NSMutableAttributedString().bold("Language: ").normal(movie?.language ?? "Unknown")
    }
}
