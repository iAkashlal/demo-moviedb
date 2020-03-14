//
//  TMDbManager.swift
//  TMDb-Framework
//
//  Created by Akashlal.com on 13/03/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import Foundation

//Delegation DP
@objc public protocol TMDbManagerDelegate{  //Added ObjC to implement optional implementation to protocol functions
    
    //To get list of all movies from API
    @objc optional func getAllMoviesSuccessWith(_ movies: String)   //ToDo: Replace with movies model
    @objc optional func getAllMoviesFailedWith(_ error: String)
    
    //To get a list of movies for a particular search string
    @objc optional func getMoviesForNamedSearchSuccessWith(_ movies: String)   //ToDo: Replace with movies model
    @objc optional func getMoviesForNamedSearchFailedWith(_ error: String)
    
}

public class TMDbManager: NSObject{
    public weak var delegate: TMDbManagerDelegate!
    
    private let apiKey = "008e213571b77b7b378b8e66f788d0ad"
    private let baseURL = "https://api.themoviedb.org/3"
    //Search URL format - https://api.themoviedb.org/3/search/company?api_key=\(self.apiKey)&query=\(query)&page=\(pageNo)
    private let searchURL = "/search/company"
    //Image url format - https://image.tmdb.org/t/p/w500/pCUdYAaarKqY2AAUtV6xXYO8UGY.jpg
    private let imageBaseURL = "https://image.tmdb.org/t/p/w500/"
    
    
    //Singleton DP
    private override init(){
        super.init()
    }
    
    //Creating Shared instance of this class for Singleton Impementation
    private static var sharedInstance: TMDbManager{
        return TMDbManager()
    }
    
    //Exposing public method to get shared instance of TMDbManager - Singleton Pattern
    public static func shared() -> TMDbManager{
        return TMDbManager.sharedInstance
    }
    
}

// MARK:- Public Methods
extension TMDbManager{
    public func getInitialMovies(){
        self.getInitialSetOfMovies()
    }
    public func getMoviesFor(name: String){
        self.getMovies(forName: name)
    }
}

// MARK:- Private Methods
extension TMDbManager{
    private func getInitialSetOfMovies(){
        print("Inside Framework")
        //Do Network Call and Call getAllMoviesSuccessWith / getAllMoviesFailedWith
        self.delegate.getAllMoviesSuccessWith?("Demo Success Framework - All - S")
        self.delegate.getAllMoviesFailedWith?("Demo Success Framework - All - F")
    }
    
    private func getMovies(forName query: String){
        print("Attempting to search for \(query)")
        //Netowrk call and call getMoviesForNamedSearchSuccessWith / getMoviesForNamedSearchFailedWith
        self.delegate.getMoviesForNamedSearchSuccessWith?("Demo Success Framework - Named - S")
        self.delegate.getMoviesForNamedSearchFailedWith?("Demo Success Framework - Named - F")
    }
}
