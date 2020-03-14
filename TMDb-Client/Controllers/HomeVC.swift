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
    
    var searchQuery = ""
    var searchResults: [MovieBinding] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Using the custom built TMDbFramework and its delegate methods in the extension
        let manager = TMDbManager.shared()
        manager.delegate = self //Set delegate to ensure successful callbacks
        manager.getInitialMovies(isInitial: true)
//        manager.getMoviesFor(name: self.searchQuery, isInitial: true)
        
    }


}

extension HomeVC: TMDbManagerDelegate{
    func discoverNewMoviesFailedWith(error: String) {
        //Handle what happens when homepage cant load any movies.
        self.presentAlert(title: "Error!", description: error)
    }
    
    
    func discoverNewMoviesSuccessWith(movies: [MovieData]) {
        //Show these movies on homepage when user first opens the application
        DispatchQueue.main.async {
            self.title = "What's Trending!"
        }
        movies.forEach {
            guard let title = $0.title, let originalTitle = $0.originalTitle, let thumbnail = $0.posterLink, let synopsis = $0.overview, let rating = $0.voteAverage, let released = $0.releaseDate else { return }
            let movieData = MovieBinding(title: title, originalTitle: originalTitle, thumbnail: thumbnail, synopsis: synopsis, rating: rating, released: released)
            searchResults.append(movieData)
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
