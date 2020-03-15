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
    
    //MARK: - Lifecycle Management
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Using the custom built TMDbFramework and its delegate methods in the extension
        manager = TMDbManager.shared()
        manager.delegate = self //Set delegate to ensure successful callbacks
        
        //
        self.performNamedSearch(forName: "Invincible")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - Custom methods
    func refresh(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    func performNamedSearch(forName name: String){
        self.searchQuery = name
        self.searchResults.removeAll()
        if name == ""{
            self.context = .discover
            manager.getInitialMovies(isInitial: true)
        }
        else{
            self.context = .search
            manager.getMoviesFor(name: name, isInitial: true)
        }
    }
    
    //MARK: - IBActions
    @IBAction func nextResults(_ sender: Any) {
        if self.context == .discover{
            manager.getInitialMovies()
        }
        else {
            manager.getMoviesFor(name: self.searchQuery)
        }
    }
    @IBAction func showDetail(_ sender: Any) {
        performSegue(withIdentifier: "showDetailsSegue", sender: self)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsSegue"{
            if let detailsVC = segue.destination as? MovieDetailsVC{
                detailsVC.movie = self.searchResults.last
            }
        }
    }
}

//MARK: - UICollectionView functions
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

//MARK: - TMDbManager Framework Delegates
extension HomeVC: TMDbManagerDelegate{
    func discoverNewMoviesSuccessWith(movies: [MovieData]) {
        //Show these movies on homepage when user first opens the application
        DispatchQueue.main.async {
            self.title = "What's Trending!"
        }
        movies.forEach {
            guard let title = $0.title, let originalTitle = $0.originalTitle, let thumbnail = $0.posterLink, let synopsis = $0.overview, let rating = $0.voteAverage else {
                self.presentAlert(title: "Error", description: "We can't seem to find a poster for a movie you might like! Apologies.")
                return
            }
            let movieData = MovieBinding(title: title, originalTitle: originalTitle, thumbnail: thumbnail, synopsis: synopsis, rating: rating, released: $0.releaseDate ?? "Unknown")
            self.searchResults.append(movieData)
        }
        refresh()
    }
    func discoverNewMoviesFailedWith(error: String) {
        //Handle what happens when homepage cant load any movies.
        self.presentAlert(title: "Error!", description: error)
    }
    
    func getMoviesForNamedSearchSuccessWith(movies: [MovieData]) {
        //ToDo: Hangle what happens when movie search call is successful
        DispatchQueue.main.async {
            self.title = "Results for \(self.searchQuery)"
        }
        movies.forEach {
            guard let title = $0.title, let originalTitle = $0.originalTitle, let thumbnail = $0.posterLink, let synopsis = $0.overview, let rating = $0.voteAverage else {
                self.presentAlert(title: "Error", description: "We can't seem to find a poster for a movie you might like! Apologies.")
                return
            }
            let movieData = MovieBinding(title: title, originalTitle: originalTitle, thumbnail: thumbnail, synopsis: synopsis, rating: rating, released: $0.releaseDate ?? "Unknown")
            self.searchResults.append(movieData)
        }
        refresh()
    }
    func getMoviesForNamedSearchFailedWith(error: String) {
        //Handle what happens when named movie call fails
        self.presentAlert(title: "Error!", description: error)
    }
    func searchResultsEmpty() {
        //Handle what happens when search results are empty. PS. Show a view asking user to search for something else.
        
    }
}
