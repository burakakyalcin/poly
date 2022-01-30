import CoreLocation

struct PolygonBuilder {
    static func build(from coordinates: [CLLocationCoordinate2D]) -> Polygon {
        return Polygon(
            coordinates: coordinates,
            centerCoordinate: PolygonManager.shared.polygonCenterOfMass(coordinates),
            area: PolygonManager.shared.signedPolygonArea(coordinates)
        )
    }
}
