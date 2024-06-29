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
    }
    
}

extension MovieListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMovies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell") as? MovieListTableViewCell {
            cell.cellConfig(modal: arrMovies[indexPath.row])
            return cell
            
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}
