//
//  TMDbManager.swift
//  TMDb-Framework
//
//  Created by Akashlal.com on 13/03/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import Foundation

//Delegation DP
public protocol TMDbManagerDelegate{
    
    //To get list of all movies from API
    func discoverNewMoviesSuccessWith(movies: [MovieData])
    func discoverNewMoviesFailedWith(error: String)
    
    //To get a list of movies for a particular search string
    func getMoviesForNamedSearchSuccessWith(movies: [MovieData])
    func getMoviesForNamedSearchFailedWith(error: String)
    
    //Trigger when search results are empty to notify user to search for something else.
    func searchResultsEmpty()
}

public class TMDbManager: NSObject{
    public var delegate: TMDbManagerDelegate!
    
    private let apiKey = "53eafbc1ab15fcd88324c96a958d6ca5"
    private let baseURL = "https://api.themoviedb.org/3"
    //Discover URL format - https://api.themoviedb.org/3/discover/movie?api_key=\(self.apiKey)&sort_by=\(self.sortMode)&page=\(pageNo)
    private let discoverURL = "/discover/movie"
    //Search URL format - https://api.themoviedb.org/3/search/company?api_key=\(self.apiKey)&query=\(query)&page=\(pageNo)
    private let searchURL = "/search/movie"
    //Image url format - https://image.tmdb.org/t/p/w500/pCUdYAaarKqY2AAUtV6xXYO8UGY.jpg
    private let imageBaseURL = "https://image.tmdb.org/t/p/w500/"
    
    private var pageNo: Int = 1
    private var totalPages: Int? = 1
    private var sortMode: String = "popularity.desc"
    
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
    //set isInitial as true only for the first call/search
    public func getInitialMovies(isInitial: Bool = false){
        resetState(isInitial: isInitial)
        self.getInitialSetOfMovies()
    }
    public func getMoviesFor(name: String, isInitial: Bool = false){
        resetState(isInitial: isInitial)
        self.getMovies(forName: name)
    }
    
    //To change sort order from API, could be better to check with appropriate values as per the API documentation.
    public func updateSort(order: String){
        self.rememberTo(sortBy: order)
    }
}

// MARK:- Private Methods
extension TMDbManager{
    
    //Call this function to reset all counters
    private func resetState(isInitial: Bool){
        if isInitial {
            self.pageNo = 1
            self.totalPages = 1
        }
    }
    
    private func constructDiscoverURL() -> URL{
        return URL(string: self.baseURL+self.discoverURL+"?api_key=\(self.apiKey)&sort_by=\(sortMode)&page=\(pageNo)")!
    }
    
    private func getInitialSetOfMovies(){
        if let totalPages = self.totalPages{
            //Check if user has viewed all entries. If so, no need to hit the network.
            if self.pageNo > totalPages{
                return
            }
        }
        DiscoverRequest.with(url: constructDiscoverURL()) { (movieModel, error) in
            if let error = error{
                self.delegate.discoverNewMoviesFailedWith(error: error)
            } else {
                self.totalPages = movieModel?.totalPages
                if self.totalPages == 0{
                    self.pageNo = 1
                    self.delegate.searchResultsEmpty()
                    return
                }
                guard let movies = movieModel?.results else {
                    self.delegate.discoverNewMoviesFailedWith(error: "Some unknown error occured. Please retry")
                    return
                }
                self.delegate.discoverNewMoviesSuccessWith(movies: movies)
                self.pageNo += 1    //Incrementing page count so that the next search will result in 
            }
        }
        
    }
    
    private func constructSearchURL(forQuery query: String) -> URL{
        let modifiedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = self.baseURL+self.searchURL+"?api_key=\(self.apiKey)&query=\(modifiedQuery)&page=\(pageNo)&language=en-US"
        return URL(string: urlString)!
    }
    
    private func getMovies(forName query: String){
        //Check if user has viewed all entries. If so, no need to hit the network.
        if let totalPages = self.totalPages{
            if self.pageNo > totalPages{
                return
            }
        }
        SearchRequest.with(url: constructSearchURL(forQuery: query)) { (movieModel, error) in
            if let error = error{
                self.delegate.getMoviesForNamedSearchFailedWith(error: error)
            } else {
                self.totalPages = movieModel?.totalPages
                if self.totalPages == 0{
                    self.pageNo = 1
                    self.delegate.searchResultsEmpty()
                    return
                }
                guard let movies = movieModel?.results else{
                    self.delegate.discoverNewMoviesFailedWith(error: "Some unknown error occured. Please retry")
                    return
                }
                self.delegate.getMoviesForNamedSearchSuccessWith(movies: movies)
                self.pageNo += 1
            }
        }
    }
    
    private func rememberTo(sortBy: String){
        self.sortMode = sortBy
    }
}
