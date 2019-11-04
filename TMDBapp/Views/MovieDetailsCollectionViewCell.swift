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
     @IBOutlet weak var footer: UILabel!
    
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
        label.text = "\(crew.name ?? "")"
        footer.text = "\(crew.job ?? "")"
        if let data = NetworkService.shared.getImage(by: crew.profilePath){
            image.image = UIImage(data: data)/*{ [weak self] data in
            DispatchQueue.main.async {
                self?.image.image = UIImage(data: data)
            }*/
        }
    }
    func configure(with cast: MovieCredits.castItem) {
        label.text = cast.name ?? ""
        if let data = NetworkService.shared.getImage(by: cast.profilePath){
            image.image = UIImage(data: data)
        }/*{ [weak self] data in
            DispatchQueue.main.async {
                self?.image.image = UIImage(data: data)
            }
        }*/
    }
}
