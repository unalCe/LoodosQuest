//
//  FeedTableViewCell.swift
//  LoodosQuest
//
//  Created by Unal Celik on 18.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import UIKit
import Kingfisher

class FeedTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    @IBOutlet weak var imdbScoreLabel: UILabel!
    
    @IBOutlet weak var movieGenreLabel: UILabel!
    
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    // Kingfisher RetrieveImageTask that will be used for cancelling download task in viewController.
    var imageRetrieveTask: RetrieveImageTask?
    
    var movie: Movie? {
        didSet {
            fetchImage(from: movie?.poster, to: movieImageView)
            fillLabelsWithMovieInformation()
        }
    }
    
    // MARK: - Customization
    /// Fill labels with movie data
    private func fillLabelsWithMovieInformation() {
        movieGenreLabel.text = "Genre: " + ((movie?.genre == "N/A") ? "Unknown" : (movie?.genre)!)
        movieNameLabel.text = movie?.title
        movieDescriptionLabel.text = (movie?.plot == "N/A") ? "No description available" : movie?.plot
        imdbScoreLabel.text = "imDB Rating: " + ((movie?.imdbRating == "N/A") ? "Unknown" : (movie?.imdbRating)!)
    }
    
    /**
     Image fetching method. Send request for a given URL and fetch image
     
     - parameter url: URL to request
     - parameter imageView: UIImageView object that fetched image will be set in
     */
    private func fetchImage(from url: URL?, to imageView: UIImageView) {
        // Start download indicator.
        imageView.kf.indicatorType = .activity
        // Retrieve the image with Kingfisher.
        imageRetrieveTask = imageView.kf.setImage(
            with: url,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    // Awake
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieImageView.layer.cornerRadius = 12
        movieImageView.clipsToBounds = true
        movieImageView.contentMode = .scaleAspectFill
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
