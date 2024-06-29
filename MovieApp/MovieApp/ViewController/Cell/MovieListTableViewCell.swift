//
//  MovieListTableViewCell.swift
//  MovieApp
//
//  Created by Mitul Patel on 29/06/24.
//

import UIKit
import CoreData

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgMovies: UIImageView!
    @IBOutlet weak var lblMovies: UILabel!
    @IBOutlet weak var lblStudio: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfig(modal: MoviesEntity) {
        lblMovies.text = modal.title
        lblStudio.text = modal.studio
        lblRating.text = modal.criticsRating
        print(modal.image)
        imgMovies.sd_setImageCustom(url: modal.image ?? "")
    }
    
}
