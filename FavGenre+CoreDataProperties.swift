//
//  FavGenre+CoreDataProperties.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 16/10/2022.
//
//

import Foundation
import CoreData


extension FavGenre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavGenre> {
        return NSFetchRequest<FavGenre>(entityName: "FavGenre")
    }

    @NSManaged public var id: Int32
    @NSManaged public var relationship: Favourite?

}

extension FavGenre : Identifiable {

}
