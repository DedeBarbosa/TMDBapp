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
    let blankPhoto = #imageLiteral(resourceName: "169-1695846_jane-no-one-icon-clipart.png")
    
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
        NetworkService.shared.getImage(by: crew.profilePath){  [weak self] data in
            DispatchQueue.main.async {
                if let data = data{
                    self?.image.image = UIImage(data: data)
                }
                else{
                    self?.image.image = nil
                }
            }
        }
    }
    func configure(with cast: MovieCredits.castItem) {
        label.text = cast.name ?? ""
        NetworkService.shared.getImage(by: cast.profilePath){[weak self] data in
            DispatchQueue.main.async {
                if let data = data{
                    self?.image.image = UIImage(data: data)
                }
                else{
                    self?.image.image = nil
                }
            }
        }
    }
}
