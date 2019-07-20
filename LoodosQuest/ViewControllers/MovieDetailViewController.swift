//
//  MovieDetailViewController.swift
//  LoodosQuest
//
//  Created by Unal Celik on 20.07.2019.
//  Copyright © 2019 unalCelik. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var lenghtLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .always

        updateUI()
    }
    
    private func updateUI() {
        navigationItem.title = movie?.title
        plotLabel.text = movie?.plot
        genreLabel.text = movie?.genre
        yearLabel.text = movie?.year
        lenghtLabel.text = movie?.runtime
        actorsLabel.text = movie?.actors
        languageLabel.text = movie?.language
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
