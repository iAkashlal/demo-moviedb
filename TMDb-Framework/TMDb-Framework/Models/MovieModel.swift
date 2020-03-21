//
//  MovieModel.swift
//  TMDb-Framework
//
//  Created by Akashlal on 14/03/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import Foundation

public struct MovieModel : Codable {

    public let page : Int?
    public let results : [MovieData]?
    public let totalPages : Int?
    public let totalResults : Int?


}

public struct MovieData : Codable {

    public let adult : Bool?
    public let backdropPath : String?
    public let genreIds : [Int]?
    public let id : Int?
    public let originalLanguage : String?
    public let originalTitle : String?
    public let overview : String?
    public let popularity : Float?
    public let posterPath : String?
    public let releaseDate : String?
    public let title : String?
    public let video : Bool?
    public let voteAverage : Float?
    public let voteCount : Int?
    public var posterLink: String?{
        if let validPosterPath = posterPath{
            return "https://image.tmdb.org/t/p/w500\(validPosterPath)"
        }else{
            return "https://f.v1.n0.cdn.getcloudapp.com/items/0P1A070P2W2D20010a1P/poster.png"
        }
    }
    public var releasedOn: String?{
        if let date = releaseDate, date != ""{
            let dateComponents = date.components(separatedBy: "-")
            return "\(dateComponents[2])-\(dateComponents[1])-\(dateComponents[0])"
        }
        else{
            return "Unknown"
        }
    }

}
