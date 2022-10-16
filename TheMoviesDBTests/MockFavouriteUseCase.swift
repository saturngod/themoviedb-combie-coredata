//
//  TestCoreDataStack.swift
//  TheMoviesDBTests
//
//  Created by Htain Lin Shwe on 16/10/2022.
//

import Foundation
import CoreData
@testable import TheMoviesDB

class MockFavouriteUseCase: FavouriteUseCase {
    override func makeContainer() -> NSPersistentContainer {
        //use mmory type for testing
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: FavouriteUseCase.containerName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }
}
