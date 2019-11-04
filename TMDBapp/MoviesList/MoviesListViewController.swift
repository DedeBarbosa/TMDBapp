//
//  ViewController.swift
//  TMDBapp
//
//  Created by Dmitry Pavlov on 01/11/2019.
//  Copyright © 2019 Dmitry Pavlov. All rights reserved.
//

import UIKit

protocol MoviesListViewProtocol: class {
    func reloadData()
    func performDetailSegue(with movieId: Int)
}

class MoviesListViewController: UIViewController {

    var presenter: MoviesListPresenterProtocol!
    let goToDetailSegue = "showDetail"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = MoviesListPresenter(view: self)
        self.presenter = presenter
        setupNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == goToDetailSegue {
            guard let movieId = sender as? Int else {return}
            guard let detailVC = segue.destination as? MovieDetailsViewController else {return}
            detailVC.configureModule(with: movieId)
            //let configurator: CourseDetailsConfiguratorProtocol = CourseDetailsConfigurator()
            //configurator.configure(with: detailVC, and: course)
        }
    }
    
    private func setupNavigationBar() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            navBarAppearance.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }

}
extension MoviesListViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.moviesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell",
                                                       for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        guard let course = presenter.movie(atIndex: indexPath) else { return UITableViewCell() }
            cell.configure(with: course)
        return cell
    }
    
    
}
extension MoviesListViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.showMovieDetails(for: indexPath)
    }
    
}

extension MoviesListViewController: MoviesListViewProtocol{
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func performDetailSegue(with movieId: Int) {
        self.performSegue(withIdentifier: self.goToDetailSegue, sender: movieId)
    }
}
