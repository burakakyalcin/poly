//
//  Polygon+CoreDataProperties.swift
//  Poly
//
//  Created by Burak Akyalcin on 31.01.2022.
//
//

import Foundation
import CoreData


extension Polygon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Polygon> {
        return NSFetchRequest<Polygon>(entityName: "Polygon")
    }

    @NSManaged public var area: Double
    @NSManaged public var centerCoordinate: PolygonCoordinate
    @NSManaged public var coordinates: NSSet

}

// MARK: Generated accessors for coordinates
extension Polygon {

    @objc(addCoordinatesObject:)
    @NSManaged public func addToCoordinates(_ value: PolygonCoordinate)

    @objc(removeCoordinatesObject:)
    @NSManaged public func removeFromCoordinates(_ value: PolygonCoordinate)

    @objc(addCoordinates:)
    @NSManaged public func addToCoordinates(_ values: NSSet)

    @objc(removeCoordinates:)
    @NSManaged public func removeFromCoordinates(_ values: NSSet)

}

extension Polygon : Identifiable {

}
