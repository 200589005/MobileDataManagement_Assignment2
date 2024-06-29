//
//  MoviesEntity+Fetch.swift
//  MovieApp
//
//  Created by Mitul Patel on 29/06/24.
//

import Foundation
import CoreData

extension MoviesEntity {
    
    @discardableResult
    static func fetchItemWithID(id:String) -> MoviesEntity? {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "MoviesEntity")
        let predicate = NSPredicate(format: "id == %@",id)
        request.predicate = predicate
        
        let category = try?
            (CoreDataStackManager.sharedInstance.managedObjectContext.fetch(request).first) as? MoviesEntity
        return category
    }
    
    @discardableResult
    static func fetchAllMovies() -> [MoviesEntity] {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "MoviesEntity")
        
        let arr = try?
            (CoreDataStackManager.sharedInstance.managedObjectContext.fetch(request)) as? [MoviesEntity]
        return arr ?? []
    }
    
    
}
