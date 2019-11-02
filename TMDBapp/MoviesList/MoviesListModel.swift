//
//  MoviesListModel.swift
//  TMDBapp
//
//  Created by Dmitry Pavlov on 01/11/2019.
//  Copyright © 2019 Dmitry Pavlov. All rights reserved.
//

import Foundation

protocol MoviesListModelProtocol: class{
    init (presenter: MoviesListModelOutputProtocol)
    func getMoviesList()
}

protocol MoviesListModelOutputProtocol: class{
    func moviesListDidRecieved(moviesList: MovieList)
}

class MoviesListModel: MoviesListModelProtocol{
    
    weak var presenter: MoviesListModelOutputProtocol!
    let networkService = NetworkService()
    
    required init(presenter: MoviesListModelOutputProtocol) {
        self.presenter = presenter
    }
    
    func getMoviesList(){
        NetworkService.shared.fetchMovieList{ [weak self] moviesList in
            self?.presenter.moviesListDidRecieved(moviesList: moviesList)
        }
    }
    
    
}
