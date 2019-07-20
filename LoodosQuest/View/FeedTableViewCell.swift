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
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    @IBOutlet weak var imdbScoreLabel: UILabel!
    
    @IBOutlet weak var movieGenreLabel: UILabel!
    
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            fetchImage(from: movie?.poster, to: movieImageView)
            fillLabelsWithMovieInformation()
        }
    }
    
    var imageRetrieveTask: RetrieveImageTask?
    
    func fillLabelsWithMovieInformation() {
        movieGenreLabel.text = "Genre: " + (movie?.genre ?? "Unknown")
        movieNameLabel.text = movie?.title
        movieDescriptionLabel.text = movie?.plot
        imdbScoreLabel.text = "imDB Rating: " + (movie?.imdbRating ?? "Unknown")
    }
    
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
