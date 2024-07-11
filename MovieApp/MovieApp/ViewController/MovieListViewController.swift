//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Mitul Patel on 29/06/24.
//

import UIKit
import CoreData

class MovieListViewController: UIViewController {

    var arrMovies: [MoviesEntity] = []
    
    @IBOutlet weak var tblMovies: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAndSetMovies()
    }
    
    func getAndSetMovies() {
        arrMovies = MoviesEntity.fetchAllMovies()
        self.tblMovies.reloadData()
    }
    
    func registerTableViewCells() {
        tblMovies.register(UINib.init(nibName: "MovieListTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieListTableViewCell")
        tblMovies.rowHeight = UITableView.automaticDimension
        tblMovies.estimatedRowHeight = 30;
        tblMovies.tableFooterView = UIView()
        tblMovies.delegate = self
        tblMovies.dataSource = self
        tblMovies.reloadData()
        self.setupDefaultNavigation()
    }
    
    func navigateToAddMovies(movie: MoviesEntity) {
        let addMovies: AddMoviesViewController = AddMoviesViewController.instantiateViewController(identifier: .main)
        addMovies.movie = movie
        self.pushVC(addMovies)
    }
    
    @IBAction func btnAddAction(_ sender: UIBarButtonItem) {
        let addMovies: AddMoviesViewController = AddMoviesViewController.instantiateViewController(identifier: .main)
        self.pushVC(addMovies)
    }
    
    
}

extension MovieListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMovies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell") as? MovieListTableViewCell {
            cell.indexPath = indexPath
            cell.delegate = self
            cell.cellConfig(modal: arrMovies[indexPath.row])
            return cell
            
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension MovieListViewController: MovieListTableViewCellProtocol {
    func deleteMoviesAtIndex(indexPath: IndexPath) {
        self.showAlertWithOkAndCancelHandler(string: "Are you sure you want to delete this movies?", strOk: "YES", strCancel: "NO") { isOkBtnPressed in
            if isOkBtnPressed {
                let movie = self.arrMovies[indexPath.row]
                MoviesEntity.deleteMoviesFromID(id: movie.id ?? "")
                DispatchQueue.main.async {
                    self.getAndSetMovies()
                }
            }
        }
        
    }
    
    func editMoviesAtIndex(indexPath: IndexPath) {
        self.navigateToAddMovies(movie: arrMovies[indexPath.row])
    }
}
