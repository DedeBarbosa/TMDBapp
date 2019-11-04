//
//  MovieDetailsViewController.swift
//  TMDBapp
//
//  Created by Dmitry Pavlov on 02/11/2019.
//  Copyright © 2019 Dmitry Pavlov. All rights reserved.
//

import UIKit

protocol MovieDetailsViewProtocol {
    func setImage(data: Data?)
    func setTitle(title: String?)
    func reloadData()
}


class MovieDetailsViewController: UIViewController {
    var presenter: MovieDetailPresenterProtocol!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var crewCollection: UICollectionView!
    @IBOutlet weak var castCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crewCollection.dataSource = self
        crewCollection.delegate = self
        castCollection.dataSource = self
        castCollection.delegate = self
        registerNib()
        presenter.viewDidLoad()
        creditsCollectionLayoutConfig()
    }
    
    
    
    func creditsCollectionLayoutConfig(){
        crewCollection.showsVerticalScrollIndicator = false
        crewCollection.alwaysBounceVertical = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        crewCollection.setCollectionViewLayout(layout, animated: false)
        castCollection.setCollectionViewLayout(layout, animated: false)
    }
    
    func registerNib() {
        let nib = UINib(nibName: MovieDetailsCollectionViewCell.nibName, bundle: nil)
        crewCollection?.register(nib, forCellWithReuseIdentifier: MovieDetailsCollectionViewCell.reuseIdentifier)
        castCollection?.register(nib, forCellWithReuseIdentifier: MovieDetailsCollectionViewCell.reuseIdentifier)
    }
    
    func configureModule(with movieId: Int){
        let presenter = MovieDetailPresenter(view: self, with: movieId)
        self.presenter = presenter
    }
}

extension MovieDetailsViewController: MovieDetailsViewProtocol{
    func setImage(data: Data?) {
        if let data = data{
            poster.image = UIImage(data: data)
        }
    }
    
    func setTitle(title: String?) {
            titleLabel.text = title
    }
    
    
    func reloadData(){
        DispatchQueue.main.async {
            self.crewCollection.reloadData()
        }
    }
    
}

extension MovieDetailsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == crewCollection{
            return presenter.getCrewCount ?? 0
        }
        return presenter.getActorsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailsCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieDetailsCollectionViewCell else {return UICollectionViewCell()}
        if collectionView == crewCollection, let crew = presenter.getCrew(atIndex: indexPath){
            print(indexPath.row)
            cell.configure(with: crew)
                   return cell
        } else{
            guard let cast = presenter.getCast(atIndex: indexPath) else {return UICollectionViewCell()}
            cell.configure(with: cast)
            return cell
        }
    }
}

extension MovieDetailsViewController: UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: collectionView.frame.width/4, height: collectionView.frame.height/1.5)
    }
    
}
