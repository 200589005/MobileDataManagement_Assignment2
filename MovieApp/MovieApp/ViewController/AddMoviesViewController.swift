//
//  AddMoviesViewController.swift
//  MovieApp
//
//  Created by Mitul Patel on 05/07/24.
//

import UIKit
import IQKeyboardManagerSwift

class AddMoviesViewController: UIViewController {

    var movie: MoviesEntity? = nil
    var imgMovies: UIImage? = nil
    var isImageUpdated: Bool = false
    
    @IBOutlet weak var imageMovies: UIImageView!
    @IBOutlet weak var txtMTitle: UITextField!
    @IBOutlet weak var txtMStudio: UITextField!
    @IBOutlet weak var txtMGenres: UITextField!
    @IBOutlet weak var txtMDirectors: UITextField!
    @IBOutlet weak var txtMWriters: UITextField!
    @IBOutlet weak var txtmActors: UITextField!
    @IBOutlet weak var txtMYear: UITextField!
    @IBOutlet weak var txtMLength: UITextField!
    @IBOutlet weak var txtMShortDescription: IQTextView!
    @IBOutlet weak var txtMPARatting: UITextField!
    @IBOutlet weak var txtMCriticsRating: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDefaultNavigation()
        self.setupUIForExistingMovie()
        self.setupUI()
    }
    
    func setupUIForExistingMovie() {
        self.navigationItem.title = "Add Movie"
        guard let movie = movie else { return }
        self.navigationItem.title = "Edit Movie"
        txtMTitle.text = movie.title
        txtMStudio.text = movie.studio
        txtMGenres.text = movie.genres
        txtMDirectors.text = movie.directors
        txtMWriters.text = movie.writers
        txtmActors.text = movie.actors
        txtMYear.text = movie.year
        txtMLength.text = movie.length
        txtMShortDescription.text = movie.shortDescriptionMovie
        txtMPARatting.text = movie.mpaRating
        txtMCriticsRating.text = movie.criticsRating
        if movie.isLocalImage, let data = movie.localImage, let image = UIImage(data: data) {
            imageMovies.image = image
        } else {
            imageMovies.sd_setImageCustom(url: movie.image ?? "",placeHolderImage: UIImage(named: "no-photo"))
        }
    }
    
    func setupUI() {
        
        txtMTitle.delegate = self
        txtMStudio.delegate = self
        txtMGenres.delegate = self
        txtMDirectors.delegate = self
        txtMWriters.delegate = self
        txtmActors.delegate = self
        txtMYear.delegate = self
        txtMLength.delegate = self
//        txtMShortDescription.delegate = self
        txtMPARatting.delegate = self
        txtMCriticsRating.delegate = self
        
        txtMShortDescription.layer.borderWidth = 1
        txtMShortDescription.layer.borderColor = UIColor.lightGray.cgColor
        txtMShortDescription.layer.cornerRadius = 6
        txtMShortDescription.layer.masksToBounds = true
        txtMShortDescription.clipsToBounds = true
    }
    
    func createDictForSaveData() -> [String:Any] {
        var dict: [String:Any] = [:]
        if let movie = movie {
            dict["id"] = movie.id ?? ""
        }
        dict["title"] = txtMTitle.text ?? ""
        dict["studio"] = txtMStudio.text ?? ""
        dict["genres"] = txtMGenres.text ?? ""
        dict["directors"] = txtMDirectors.text ?? ""
        dict["writers"] = txtMWriters.text ?? ""
        dict["actors"] = txtmActors.text ?? ""
        dict["year"] = Int(txtMYear.text ?? "") ?? 0
        dict["length"] = Int(txtMLength.text ?? "") ?? 0
        dict["shortDescription"] = txtMShortDescription.text ?? ""
        dict["mpaRating"] = txtMPARatting.text ?? ""
        dict["criticsRating"] = txtMCriticsRating.text ?? ""
        
        if let movie = movie {
            if movie.isLocalImage {
                if imgMovies != nil, !isImageUpdated , let data = movie.localImage  {
                    dict["imageData"] = data
                } else if imgMovies != nil, isImageUpdated , let data = imgMovies?.jpegData(compressionQuality: .ulpOfOne){
                    dict["imageData"] = data
                }
            } else if !movie.isLocalImage {
                if !isImageUpdated {
                    dict["image"] = movie.image ?? ""
                } else if let data = imgMovies?.jpegData(compressionQuality: .ulpOfOne){
                    dict["imageData"] = data
                }
            }
        } else if imgMovies != nil, let data = imgMovies?.jpegData(compressionQuality: .ulpOfOne) {
            dict["imageData"] = data
        }
        
        
        
        return dict
    }

    @IBAction func btnImageAction(_ sender: UIButton) {
        CameraAndGalleryPermisson.sharedInstance.openCamaraAndPhotoLibrary(self) {[weak self] image, strName, error in
            guard let self = self else {
                return
            }
            if let img = image {
                self.imageMovies.image = img
                self.imgMovies = img
                self.isImageUpdated = true
            }
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        if isValidDetails() {
            let dict = self.createDictForSaveData()
            let _ = MoviesEntity.createOrUpdateMovies(dictData: dict, context: CoreDataStackManager.sharedInstance.managedObjectContext)
            self.popVC()
        }
    }
    
    func isValidDetails() -> Bool {
        let isValidMovies = imgMovies == nil && movie == nil
        let isLocalImage = movie != nil && (movie?.isLocalImage ?? false && movie?.localImage == nil)
        let isDefaultImage = (!(movie?.isLocalImage ?? false) && movie?.image == nil)
        if  (isValidMovies || (isLocalImage && isDefaultImage)) {
            self.showAlert(string: "Please add image for movies")
            return false
        } else if let text = txtMTitle.text, text.isBlank{
            self.showAlert(string: "Please enter valid title for movies")
            return false
        } else if let text = txtMStudio.text, text.isBlank{
            self.showAlert(string: "Please enter valid studio for movies")
            return false
        } else if let text = txtMGenres.text, text.isBlank{
            self.showAlert(string: "Please enter valid genres for movies")
            return false
        } else if let text = txtMDirectors.text, text.isBlank{
            self.showAlert(string: "Please enter valid director for movies")
            return false
        } else if let text = txtMWriters.text, text.isBlank{
            self.showAlert(string: "Please enter valid writers for movies")
            return false
        } else if let text = txtmActors.text, text.isBlank{
            self.showAlert(string: "Please enter valid actors for movies")
            return false
        } else if let text = txtMYear.text, text.isBlank{
            self.showAlert(string: "Please enter valid year for movies")
            return false
        } else if let text = txtMLength.text, text.isBlank{
            self.showAlert(string: "Please enter valid length for movies")
            return false
        } else if let text = txtMShortDescription.text, text.isBlank{
            self.showAlert(string: "Please enter valid short description for movies")
            return false
        } else if let text = txtMPARatting.text, text.isBlank{
            self.showAlert(string: "Please enter valid MPA Rating for movies")
            return false
        } else if let text = txtMCriticsRating.text, text.isBlank{
            self.showAlert(string: "Please enter valid critics Rating for movies")
            return false
        }
        return true
    }
}

extension AddMoviesViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
