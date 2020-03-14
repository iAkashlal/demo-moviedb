//
//  ViewController.swift
//  TMDb-Client
//
//  Created by Akashlal on 13/03/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import UIKit
import TMDb_Framework

class HomeVC: UIViewController {
    
    var searchQuery = "Joker"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let manager = TMDbManager.shared()
        manager.delegate = self
        manager.getInitialMovies()
        manager.getMoviesFor(name: self.searchQuery)
        navigationController?.navigationBar.prefersLargeTitles = true
    }


}

extension HomeVC: TMDbManagerDelegate{
    func discoverNewMoviesFailedWith(error: String) {
        //Handle what happens when homepage cant load any movies.
    }
    
    
    func discoverNewMoviesSuccessWith(movies: [MovieData]) {
        //Show these movies on homepage when user first opens the application
        DispatchQueue.main.async {
            self.title = "What's Trending!"
        }
        for movie in movies{
            guard let title = movie.title, let posterURL = URL(string: movie.posterLink) else{
                return
            }
            print(title)
            print(posterURL)
        }
    }
    
    func getMoviesForNamedSearchSuccessWith(movies: String) {
        //ToDo: Hangle what happens when movie search call is successful
        DispatchQueue.main.async {
            self.title = "Results for \(self.searchQuery)"
        }
        print(movies)
    }
    func getMoviesForNamedSearchFailedWith(error: String) {
        //ToDo: Hangle what happens when movie call fails
        print(error)
    }
}
