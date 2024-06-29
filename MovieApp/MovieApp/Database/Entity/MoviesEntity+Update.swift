//
//  MovieEntity+Update.swift
//  MovieApp
//
//  Created by Mitul Patel on 29/06/24.
//

import Foundation
import CoreData

extension MoviesEntity {
    
    @discardableResult
    class func createOrUpdateMovies(dictData:[String:Any], context: NSManagedObjectContext) -> MoviesEntity? {
        
        var strMovieID : String?
        
        var moviesDetails: MoviesEntity?
        
        if let id = dictData["id"] as? String {
            strMovieID = String(id)
        }
        
        if let strID = strMovieID,let existingMovie = MoviesEntity.fetchItemWithID(id: strID) {
            moviesDetails = existingMovie
        }else{
            let entityDesc =
                NSEntityDescription.entity(forEntityName: String(describing: MoviesEntity.self),
                                           in: context)!
            
            moviesDetails = MoviesEntity(entity: entityDesc, insertInto: context)
            moviesDetails?.id = UUID().uuidString
        }
        
        if let title = dictData["title"] as? String {
            moviesDetails?.title = title
        }
        if let studio = dictData["studio"] as? String {
            moviesDetails?.studio = studio
        }
        if let genres = dictData["genres"] as? String {
            moviesDetails?.genres = genres
        }
        if let directors = dictData["directors"] as? String {
            moviesDetails?.directors = directors
        }
        if let writers = dictData["writers"] as? String {
            moviesDetails?.writers = writers
        }
        if let actors = dictData["actors"] as? String {
            moviesDetails?.actors = actors
        }
        if let year = dictData["year"] as? String {
            moviesDetails?.year = year
        }
        if let length = dictData["length"] as? String {
            moviesDetails?.length = length
        }
        if let shortDescription = dictData["shortDescription"] as? String {
            moviesDetails?.shortDescriptionMovie = shortDescription
        }
        if let mpaRating = dictData["mpaRating"] as? String {
            moviesDetails?.mpaRating = mpaRating
        }
        if let criticsRating = dictData["criticsRating"] as? String {
            moviesDetails?.criticsRating = criticsRating
        }
        if let image = dictData["image"] as? String {
            moviesDetails?.image = image
        }
        
        if moviesDetails?.createdAt == nil {
            moviesDetails?.createdAt = Int64(Date().timeIntervalSince1970)
        }
        
        
        moviesDetails?.updatedAt = Int64(Date().timeIntervalSince1970)
        CoreDataStackManager.saveContextCommon(context: context)
        CoreDataStackManager.sharedInstance.saveContext()
        return moviesDetails
        
    }
    
}
