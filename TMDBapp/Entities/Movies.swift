//
//  Models.swift
//  TMDBapp
//
//  Created by Dmitry Pavlov on 01/11/2019.
//  Copyright © 2019 Dmitry Pavlov. All rights reserved.
//

import Foundation

struct MovieList: Decodable{
    struct Movie: Decodable{
        let title: String
        let voteAverage: Double?
        let posterPath: String?
        let id: Int
    }
    let items: [Movie]?
}

struct Movie:Decodable {
    let title: String?
    let backdropPath: String?
}

struct MovieCredits: Decodable{
    struct castItem: Decodable{
        let name: String?
        let profilePath: String?
        let order: Int?
    }
    struct crewItem: Decodable{
        let name: String?
        let profilePath: String?
        let job: String?
        
    }
    let cast: [castItem]
    let crew: [crewItem]
}
