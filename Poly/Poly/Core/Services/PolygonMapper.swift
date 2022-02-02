import Foundation
import CoreLocation

class PolygonMapper {
    static func convertUIPolygonToPolygon(uiPolygon: UIPolygon) -> Polygon {
        let polygon = Polygon(context: PersistenceService.context)
        polygon.area = uiPolygon.area

        let centerCoordinate = PolygonCoordinate(context: PersistenceService.context)
        centerCoordinate.latitude = uiPolygon.centerCoordinate.latitude
        centerCoordinate.longitude = uiPolygon.centerCoordinate.longitude
        polygon.centerCoordinate = centerCoordinate

        uiPolygon.coordinates.forEach { coordinate in
            let polygonCoordinate = PolygonCoordinate(context: PersistenceService.context)
            polygonCoordinate.latitude = coordinate.latitude
            polygonCoordinate.longitude = coordinate.longitude
            polygon.addToCoordinates(polygonCoordinate)
        }

        return polygon
    }

    static func convertPolygonToUIPolygon(polygon: Polygon) -> UIPolygon {
        let polygonCoordinates: [PolygonCoordinate] = polygon.coordinates.toArray()
        let coordinates = polygonCoordinates.map { polygonCoordinate in
            return CLLocationCoordinate2D(
                latitude: polygonCoordinate.latitude,
                longitude: polygonCoordinate.longitude
            )
        }

        let centerCoordinate = CLLocationCoordinate2D(
            latitude: polygon.centerCoordinate.latitude,
            longitude: polygon.centerCoordinate.longitude
        )

        let area = polygon.area

        return UIPolygon(coordinates: coordinates, centerCoordinate: centerCoordinate, area: area)
    }
}
