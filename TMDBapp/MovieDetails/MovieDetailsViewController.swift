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
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var creditsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creditsCollection.dataSource = self
        creditsCollection.delegate = self
        creditsCollection.isPagingEnabled = true
        registerNib()
        presenter.viewDidLoad()
    }
    
    func registerNib() {
        let nib = UINib(nibName: MovieDetailsCollectionViewCell.nibName, bundle: nil)
        creditsCollection?.register(nib, forCellWithReuseIdentifier: MovieDetailsCollectionViewCell.reuseIdentifier)
        let sectionNib = UINib(nibName: "SectionCollectionReusableView", bundle: nil)
        self.creditsCollection.register(sectionNib,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier: "SectionCollectionReusableView")
        if let flowLayout = self.creditsCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = true
        }
//        if let flowLayout = self.creditsCollection?.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
//        }
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
            self.creditsCollection.reloadData()
        }
    }
    
}

extension MovieDetailsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1{
            return presenter.getCrewCount ?? 0
        }
        return presenter.getActorsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "creditsCell", for: indexPath) as? MovieDetailsCollectionViewCell else {return UICollectionViewCell()}
        if indexPath.section == 1, let crew = presenter.getCrew(atIndex: indexPath){
                   cell.configure(with: crew)
                   return cell
        } else{
            guard let cast = presenter.getCast(atIndex: indexPath) else {return UICollectionViewCell()}
            cell.configure(with: cast)
            return cell
        }

//        guard let cell = Bundle.main.loadNibNamed(MovieDetailsCollectionViewCell.nibName, owner: self,
//                                                  options: nil)?.first as? MovieDetailsCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        if indexPath.section == 1, let crew = presenter.getCrew(atIndex: indexPath){
//                   cell.configure(with: crew)
//        } else if let cast = presenter.getCast(atIndex: indexPath){
//            cell.configure(with: cast)
//        }
//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
//        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "SectionCollectionReusableView",
                                                                   for: indexPath) as! SectionCollectionReusableView

        view.textLabel.text = String(indexPath.section + 1)
        return view
    }
}

extension MovieDetailsViewController: UICollectionViewDelegate{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    
}






extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize(width: collectionView.bounds.size.width - 16, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 64)
    }
}
