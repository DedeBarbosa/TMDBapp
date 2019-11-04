//
//  MovieDetailsModel.swift
//  TMDBapp
//
//  Created by Dmitry Pavlov on 02/11/2019.
//  Copyright © 2019 Dmitry Pavlov. All rights reserved.
//

import Foundation


protocol MovieDetailModelProtocol{
    func getMovieInfo(with movieId: Int)
    func getMovieCredits(with movieId: Int)
    func getImageData(by path: String?) -> Data?
    init (presenter: MovieDetailModelOutputProtocol)
    
}

protocol MovieDetailModelOutputProtocol{
    func movieInfoDidRecieved(movie: Movie)
    func movieCreditsDidRecieved(movieCredits: MovieCredits)
}

class MovieDetailModel: MovieDetailModelProtocol{
    var presenter: MovieDetailModelOutputProtocol!
    required init(presenter: MovieDetailModelOutputProtocol) {
        self.presenter = presenter
    }
    
    func getMovieInfo(with movieId: Int) {
        NetworkService.shared.fetchMovie(by: movieId){ [weak self] movie in
            self?.presenter.movieInfoDidRecieved(movie: movie)
        }
    }
    
    func getMovieCredits(with movieId: Int) {
        NetworkService.shared.fetchMovieCredits(by: movieId){ [weak self] movieCredits in
            self?.presenter.movieCreditsDidRecieved(movieCredits: movieCredits)
        }
    }
    
    func getImageData(by path: String?) -> Data?{
        //var imageData: Data?
        if let data = NetworkService.shared.getImage(by: path){
            return data
        }/*{ data in
            imageData = data
        }
        return imageData*/
        return nil
    }
    
    
}
