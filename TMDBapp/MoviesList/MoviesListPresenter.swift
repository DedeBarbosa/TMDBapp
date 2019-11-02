//
//  MoviesListPresenter.swift
//  TMDBapp
//
//  Created by Dmitry Pavlov on 01/11/2019.
//  Copyright © 2019 Dmitry Pavlov. All rights reserved.
//

import Foundation

protocol MoviesListPresenterProtocol: class{
    var movies : MovieList? {get}
    var moviesCount : Int? {get}
    init(view: MoviesListViewProtocol)
    func movie(atIndex indexPath: IndexPath) -> MovieList.Movie?
    func showMovieDetails(for indexPath: IndexPath)
}

class MoviesListPresenter: MoviesListPresenterProtocol{
    
    weak var view: MoviesListViewProtocol!
    var model: MoviesListModelProtocol!
    
    var movies: MovieList?
    var moviesCount: Int? {
        return movies?.items?.count ?? 0
    }
    
    required init(view: MoviesListViewProtocol) {
        self.view = view
        let model = MoviesListModel(presenter: self)
        self.model = model
        model.getMoviesList()
    }

    func movie(atIndex indexPath: IndexPath) -> MovieList.Movie? {
        if let movies = movies?.items, movies.indices.contains(indexPath.row) {
            return movies[indexPath.row]
        } else {
            return nil
        }
    }
    
    func showMovieDetails(for indexPath: IndexPath){
        if let movies =  movies?.items, movies.indices.contains(indexPath.row) {
            let movie = movies[indexPath.row]
            view.performDetailSegue(with: movie.id)
        }
    }
}

extension MoviesListPresenter: MoviesListModelOutputProtocol{
    func moviesListDidRecieved(moviesList: MovieList) {
        movies = moviesList
        view.reloadData()
    }
    
    
}
