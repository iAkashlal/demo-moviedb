//
//  ViewController.swift
//  TMDb-Client
//
//  Created by Akashlal on 13/03/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import UIKit
import TMDb_Framework
import SDWebImage


class HomeVC: UIViewController {
    
    var searchQuery = ""
    var searchResults: [MovieBinding] = []
    var context : Context = .discover
    var manager: TMDbManager!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Using the custom built TMDbFramework and its delegate methods in the extension
        manager = TMDbManager.shared()
        manager.delegate = self //Set delegate to ensure successful callbacks
        manager.getInitialMovies(isInitial: true)
//        manager.getMoviesFor(name: self.searchQuery, isInitial: true)
        
    }
    
    @IBAction func showDetail(_ sender: Any) {
        performSegue(withIdentifier: "showDetailsSegue", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsSegue"{
            if let detailsVC = segue.destination as? MovieDetailsVC{
                detailsVC.movie = self.searchResults.last
            }
        }
    }
    
    func refresh(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    @IBAction func nextResults(_ sender: Any) {
        if self.context == .discover{
            manager.getInitialMovies()
        }
        else {
            manager.getMoviesFor(name: self.searchQuery)
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
            cell.movieImage.sd_setImage(with: URL(string: searchResults[indexPath.row].thumbnail))
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
            guard let title = $0.title, let originalTitle = $0.originalTitle, let thumbnail = $0.posterLink, let synopsis = $0.overview, let rating = $0.voteAverage, let released = $0.releaseDate else {
                self.presentAlert(title: "Error", description: "We can't seem to find a poster for a movie you might like! Apologies.")
                return
            }
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
        refresh()
    }
    func getMoviesForNamedSearchFailedWith(error: String) {
        //ToDo: Hangle what happens when movie call fails
        print(error)
    }
}
