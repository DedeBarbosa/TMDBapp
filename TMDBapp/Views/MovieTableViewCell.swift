//
//  movieTableViewCell.swift
//  TMDBapp
//
//  Created by Dmitry Pavlov on 02/11/2019.
//  Copyright © 2019 Dmitry Pavlov. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    func configure(with movie: MovieList.Movie) {
        textLabel?.text = movie.title
        guard let imageData = NetworkService.shared.getImage(by: movie.posterPath) else { return }
        imageView?.image = UIImage(data: imageData)
        if let rate = self.viewWithTag(11) as? UILabel{
            rate.text = String(format:"%.1f", movie.voteAverage ?? 0)
        }    
    }

}
