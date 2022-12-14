//
//  FavouriteUseCase.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 15/10/2022.
//

import UIKit
import CoreData

protocol FavouriteUseCaseType {
    func getAllFavourites() -> [Favourite]
    func saveFavourite(movie: Movie)
    func deleteFavourite(movie: Favourite)
    func getBy(id: Int) -> Favourite?
}

class FavouriteUseCase: FavouriteUseCaseType {
    
    static let containerName = "favourite"
    
    lazy var container: NSPersistentContainer = makeContainer()
    
    var moc: NSManagedObjectContext?  {
        return container.viewContext
    }
    
    func makeContainer() -> NSPersistentContainer {
        
        let container = NSPersistentContainer(name: FavouriteUseCase.containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        
    }
    
    func getAllFavourites() -> [Favourite] {
        
        let favFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        do {
            if let data = try moc?.fetch(favFetchRequest) as? [Favourite] {
                return data
            }
        }
        catch {
            print(error)
        }
        return []
    }
    
    func saveFavourite(movie: Movie) {
        guard let mymoc = moc else {
            return
        }
        
        let fav = Favourite(context: mymoc)
        fav.id = Int32(movie.id)
        fav.title = movie.title
        fav.backdropPath = movie.backdropPath
        fav.genres = movie.genreText
        fav.posterPath = movie.posterPath
        fav.releaseDate = movie.releaseDate
        fav.voteAverage = movie.voteAverage
        fav.voteCount = Int32(movie.voteCount)
        fav.overview = movie.overview
        fav.popularity = movie.popularity
        
        movie.genreIDS.forEach { id in
            let gen = FavGenre(context: mymoc)
            gen.id = Int32(id)
            fav.addToGen(gen)
        }
        
        try? mymoc.save()
        
    }
    
    func deleteFavourite(movie: Favourite) {
        guard let mymoc = moc else {
            return
        }
        mymoc.delete(movie)
    }
    
    func getBy(id: Int) -> Favourite? {
        
        let favFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        favFetchRequest.predicate = NSPredicate(format: "id == %d", id )
        favFetchRequest.fetchLimit = 1
        do {
            if let data = try moc?.fetch(favFetchRequest).first as? Favourite  {
                return data
            }
            
        }
        catch (let err) {
            print(err)
        }
        return nil
    }
    
    
}
