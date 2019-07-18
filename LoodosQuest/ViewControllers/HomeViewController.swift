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



class HomeViewController: UITableViewController {

    // MARK: - Properties
    let movieDBFetcherService = MovieDBFetcher()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let apiParameters = APIParameters(apiKey: apiKey!, fetchType: .title, title: "Fast ", id: nil)
        let newURL = apiParameters.bringFullURL(for: .movie, plotType: .short)
        
        movieDBFetcherService.fetch(newURL, by: apiParameters.fetchType!) { (movies, err) in
            print(movies ?? "boş geldi")
        }
        
        // Do any additional setup after loading the view.
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
