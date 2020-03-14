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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let manager = TMDbManager.shared()
        manager.delegate = self
        manager.getInitialMovies()
        manager.getMoviesFor(name: "Search")
    }


}

extension HomeVC: TMDbManagerDelegate{
    func getAllMoviesSuccessWith(_ movies: String) {
        //ToDo: Hangle what happens when initial call is successful
        print(movies)
    }
    func getAllMoviesFailedWith(_ error: String) {
        //ToDo: Hangle what happens when initial call fails
        print(error)
    }
    func getMoviesForNamedSearchSuccessWith(_ movies: String) {
        //ToDo: Hangle what happens when movie search call is successful
        print(movies)
    }
    func getMoviesForNamedSearchFailedWith(_ error: String) {
        //ToDo: Hangle what happens when movie call fails
        print(error)
    }
}
