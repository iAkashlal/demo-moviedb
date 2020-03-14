//
//  MovieModel.swift
//  TMDb-Framework
//
//  Created by Akashlal on 14/03/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import Foundation

public class MovieModel : NSObject, Codable {

    let page : Int?
    let results : [MovieData]?
    let totalPages : Int?
    let totalResults : Int?


}

public class MovieData : NSObject, Codable {

    let adult : Bool?
    let backdropPath : String?
    let genreIds : [Int]?
    let id : Int?
    let originalLanguage : String?
    let originalTitle : String?
    let overview : String?
    let popularity : Float?
    let posterPath : String?
    let releaseDate : String?
    let title : String?
    let video : Bool?
    let voteAverage : Float?
    let voteCount : Int?
    var posterLink: String{
        "https://image.tmdb.org/t/p/w500/\(posterPath)"
    }

}
