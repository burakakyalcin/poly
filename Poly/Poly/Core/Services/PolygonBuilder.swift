import CoreLocation

struct PolygonBuilder {
    static func build(from coordinates: [CLLocationCoordinate2D]) -> UIPolygon {
        return UIPolygon(
            coordinates: coordinates,
            centerCoordinate: PolygonManager.shared.polygonCenterOfMass(coordinates),
            area: PolygonManager.shared.signedPolygonArea(coordinates)
        )
    }
}
