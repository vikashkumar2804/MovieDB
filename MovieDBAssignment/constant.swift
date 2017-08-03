//
//  constant.swift
//  MovieDBAssignment
//
//  Created by Vikash on 31/07/17.
//  Copyright © 2017 Vikash. All rights reserved.
//

import UIKit
import Alamofire

class constant: NSObject {
    static let apiKey = "29941791aeafa49822aa56cc7f6b279a"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    static let popularUrl = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page="
    static let topRatedUrl = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=en-US&page="
    static let searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query="
}
//MARK:- check Net Connection

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
