//
//  SearchRequest.swift
//  TMDb-Framework
//
//  Created by Akashlal on 14/03/20.
//  Copyright © 2020 AkOS. All rights reserved.
//

import Foundation

class SearchRequest: NSObject{
    
    class func parseMovieResponse(data: Data?) -> (MovieModel?, String?){
        guard let data = data else{
            return (nil, JSONError.NoData.rawValue)
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(MovieModel.self, from: data)
            return (decodedData, nil)
        } catch {
            return(nil, JSONError.ConversionFailed.rawValue)
        }
    }
    
    class func with(url: URL, completionHandler: @escaping (MovieModel?, String?) -> Void){
        var result: (data: MovieModel?, errorMessage: String?)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                completionHandler(nil, error.localizedDescription)
            }
            else{
                result = parseMovieResponse(data: data)
                completionHandler(result.data, result.errorMessage)
            }
        }.resume()
    }
}
