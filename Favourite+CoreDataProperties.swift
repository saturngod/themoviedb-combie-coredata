//
//  Favourite+CoreDataProperties.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 16/10/2022.
//
//

import Foundation
import CoreData


extension Favourite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged public var backdropPath: String?
    @NSManaged public var genres: String?
    @NSManaged public var id: Int32
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int32
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var gen: NSSet?

}

// MARK: Generated accessors for gen
extension Favourite {

    @objc(addGenObject:)
    @NSManaged public func addToGen(_ value: FavGenre)

    @objc(removeGenObject:)
    @NSManaged public func removeFromGen(_ value: FavGenre)

    @objc(addGen:)
    @NSManaged public func addToGen(_ values: NSSet)

    @objc(removeGen:)
    @NSManaged public func removeFromGen(_ values: NSSet)

}

extension Favourite : Identifiable {

}
