//
//  MovieDetailsPresenter.swift
//  TMDBapp
//
//  Created by Dmitry Pavlov on 02/11/2019.
//  Copyright © 2019 Dmitry Pavlov. All rights reserved.
//

import Foundation

protocol MovieDetailPresenterProtocol: class {
    var movie: Movie? {get}
    var movieCredits: MovieCredits? {get}
    var getCrewCount: Int? {get}
    var getActorsCount: Int? {get}
    init(view: MovieDetailsViewProtocol, with MovieId: Int)
    func viewDidLoad()
    func getCrew(atIndex index: IndexPath) -> MovieCredits.crewItem?
    func getCast(atIndex index: IndexPath) -> MovieCredits.castItem?
    
}

class MovieDetailPresenter: MovieDetailPresenterProtocol{
    
    var view: MovieDetailsViewProtocol!
    var movieId: Int
    var movie: Movie?{
        didSet{
            if let movie = self.movie{
                DispatchQueue.main.async {
                    self.view.setTitle(title: movie.title)
                    self.view.setImage(data: self.model.getImageData(by: movie.backdropPath) ?? nil)
                }
            }
        }
    }
    var movieCredits: MovieCredits?
    var getCrewCount: Int?{
        movieCredits?.crew.count
    }
    var getActorsCount: Int?{
        movieCredits?.cast.count
    }
    var model: MovieDetailModelProtocol!
    required init(view: MovieDetailsViewProtocol, with movieId: Int) {
        self.view = view
        self.movieId = movieId
        let model = MovieDetailModel(presenter: self)
        self.model = model
    }
    
    func viewDidLoad(){
        model.getMovieInfo(with: movieId)
        model.getMovieCredits(with: movieId)
    }
    
    func getCast(atIndex index: IndexPath) -> MovieCredits.castItem? {
        if let cast = movieCredits?.cast, cast.indices.contains(index.row){
            return cast[index.row]
        }
        return nil
    }
    
    func getCrew(atIndex index: IndexPath) -> MovieCredits.crewItem? {
        if let crew = movieCredits?.crew, crew.indices.contains(index.row){
            return crew[index.row]
        }
        return nil
    }
    
}

extension MovieDetailPresenter: MovieDetailModelOutputProtocol{
    func movieInfoDidRecieved(movie: Movie) {
        self.movie = movie
    }
    
    func movieCreditsDidRecieved(movieCredits: MovieCredits) {
        self.movieCredits = movieCredits
        view.reloadData()
    }
    
    
}
