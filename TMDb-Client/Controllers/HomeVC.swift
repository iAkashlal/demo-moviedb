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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    @IBAction func showDetail(_ sender: Any) {
        performSegue(withIdentifier: "showDetailsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsSegue"{
            if let detailsVC = segue.destination as? MovieDetailsVC{
                detailsVC.movie = self.searchResults[0]
            }
        }
    }
    
    func refresh(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }


}

extension HomeVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath)
        if let cell = cell as? CollectionViewCell{
            cell.movieTitle.text = searchResults[indexPath.row].title
            //cell.movieImage = searchResults[indexPath.row].thumbnail
        }
        return cell
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
            self.searchResults.append(movieData)
        }
        refresh()
    }
    
    func getMoviesForNamedSearchSuccessWith(movies: String) {
        //ToDo: Hangle what happens when movie search call is successful
        DispatchQueue.main.async {
            self.title = "Results for \(self.searchQuery)"
        }
        print(movies)
        refresh()
    }
    func getMoviesForNamedSearchFailedWith(error: String) {
        //ToDo: Hangle what happens when movie call fails
        print(error)
    }
}
