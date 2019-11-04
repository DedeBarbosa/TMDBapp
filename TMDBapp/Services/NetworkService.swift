//
//  NetworkService.swift
//  TMDBapp
//
//  Created by Dmitry Pavlov on 01/11/2019.
//  Copyright © 2019 Dmitry Pavlov. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    static var imageDictionary: [String:Data] = [:]
    private let movieListId = 28
    
    private let tmdbApiHost = "api.themoviedb.org"
    private let tmdbImageHost = "image.tmdb.org"
    private let apiKey = "110c40bee2051d9162f0847cd1918bd9"
    private let language =  "ru-RU"//"en-US"
    
    private var defaultQueryItems : [URLQueryItem] {
        return [   URLQueryItem(name: "api_key", value: apiKey),
                    URLQueryItem(name: "language", value: language)]}
    
    
    func fetchMovieList(completion: @escaping (_ movies: MovieList)->()) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = tmdbApiHost
        components.path = "/3/list/\(movieListId)"
        components.queryItems = defaultQueryItems
        
        guard let url = components.url else {return}
        URLSession.shared.dataTask(with: url){ (data, _, _) in
            guard let data = data else {return}
        
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movies = try decoder.decode(MovieList.self, from: data)
                completion(movies)
            } catch let error {
                print("Error serialization json", error)
            }
        }.resume()
    }
    
    func fetchMovie(by id: Int, completion: @escaping(_ movie: Movie)->()){
        var components = URLComponents()
        components.scheme = "https"
        components.host = tmdbApiHost
        components.path = "/3/movie/\(id)"
        components.queryItems = defaultQueryItems
        
        guard let url = components.url else {return}
        
        URLSession.shared.dataTask(with: url){ (data, _, _) in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movie = try decoder.decode(Movie.self, from: data)
                completion(movie)
            } catch let error {
                print("Error serialization json", error)
            }
        }.resume()
    }
    
    func fetchMovieCredits(by id: Int, completion: @escaping(_ credits: MovieCredits)->()){
        var components = URLComponents()
        components.scheme = "https"
        components.host = tmdbApiHost
        components.path = "/3/movie/\(id)/credits"
        components.queryItems = defaultQueryItems
        
        guard let url = components.url else {return}
        print(url.absoluteURL)
        URLSession.shared.dataTask(with: url){ (data, _, _) in
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let credits = try decoder.decode(MovieCredits.self, from: data)
                completion(credits)
            } catch let error {
                print("Error serialization json", error)
            }
        }.resume()
    }
    
    func getImage(by path: String?) -> Data?{
        guard let path = path else {return nil}
        if NetworkService.imageDictionary.keys.contains(path){
            return NetworkService.imageDictionary[path]
        }
        var components = URLComponents()
        components.scheme = "https"
        components.host = tmdbImageHost
        components.path = "/t/p/w200\(path)"
        
        guard let url = components.url else {return nil}
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        NetworkService.imageDictionary[path] = imageData
        return imageData
    }
    
//    func getImage(by path: String?, completion: @escaping(_ data: Data)->()){
//        guard let path = path else {return}
//        if let data = NetworkService.imageDictionary[path]{
//            completion(data)
//            return
//        }
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = tmdbImageHost
//        components.path = "/t/p/w200\(path)"
//
//
//        guard let url = components.url else {return}
//
//        URLSession.shared.dataTask(with: url){ (data, _, _) in
//            guard let data = data else {return}
//            NetworkService.imageDictionary[path] = data
//            completion(data)
//        }.resume()
//    }
}
