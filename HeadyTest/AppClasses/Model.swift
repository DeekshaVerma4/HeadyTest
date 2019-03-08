//
//  Model.swift
//  HeadyTest
//
//  Created by Deeksha on 3/7/19.
//  Copyright © 2019 Deeksha. All rights reserved.
//

import Foundation

struct APIResults: Decodable {
    let page: Int
    let numResults: Int
    let numPages: Int
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case page, numResults = "total_results", numPages = "total_pages", movies  = "results"
    }
}

struct Movie: Decodable  {
    let id:Int?
    let posterPath: String
    var videoPath: String?
    let backdrop: String
    let title: String
    var releaseDate: String
    var rating: Double
    let overview: String
    
    private enum CodingKeys: String, CodingKey {
        case id, posterPath = "poster_path", videoPath, backdrop = "backdrop_path", title, releaseDate = "release_date", rating = "vote_average", overview
    }
}


