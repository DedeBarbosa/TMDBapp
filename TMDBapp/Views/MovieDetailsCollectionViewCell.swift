//
//  MovieDetailsCollectionViewCell.swift
//  TMDBapp
//
//  Created by Dmitry Pavlov on 02/11/2019.
//  Copyright © 2019 Dmitry Pavlov. All rights reserved.
//

import UIKit

class MovieDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    class var reuseIdentifier: String {
        return "creditsCell"
    }
    class var nibName: String {
        return "MovieDetailsCollectionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with crew: MovieCredits.crewItem) {
        label.text = "\(crew.name ?? "")\n\(crew.job ?? "")"
        guard let imageData = NetworkService.shared.getImage(by: crew.profilePath) else { return }
        image.image = UIImage(data: imageData)
    }
    func configure(with cast: MovieCredits.castItem) {
        label.text = cast.name ?? ""
        guard let imageData = NetworkService.shared.getImage(by: cast.profilePath) else { return }
        image.image = UIImage(data: imageData)
    }
}
