//
//  PolygonCoordinate+CoreDataProperties.swift
//  Poly
//
//  Created by Burak Akyalcin on 2.02.2022.
//
//

import Foundation
import CoreData


extension PolygonCoordinate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PolygonCoordinate> {
        return NSFetchRequest<PolygonCoordinate>(entityName: "PolygonCoordinate")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var centerCoordinate: Polygon?
    @NSManaged public var coordinates: Polygon?

}

extension PolygonCoordinate : Identifiable {

}
