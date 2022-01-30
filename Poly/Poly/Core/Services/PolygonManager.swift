import CoreLocation

struct PolygonManager {
    static let shared = PolygonManager()

    func signedPolygonArea(_ coordinates: [CLLocationCoordinate2D]) -> Double {
        let nr = coordinates.count
        var area: Double = 0
        for i in 0 ..< nr {
            let j = (i + 1) % nr
            area = area + coordinates[i].latitude * coordinates[j].longitude
            area = area - coordinates[i].longitude * coordinates[j].latitude
        }
        area = area/2.0
        return area
    }

    func polygonCenterOfMass(_ coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        let nr = coordinates.count
        var centerX: Double = 0
        var centerY: Double = 0
        var area = signedPolygonArea(coordinates)
        for i in 0 ..< nr {
            let j = (i + 1) % nr
            let factor1 = coordinates[i].latitude * coordinates[j].longitude - coordinates[j].latitude * coordinates[i].longitude
            centerX = centerX + (coordinates[i].latitude + coordinates[j].latitude) * factor1
            centerY = centerY + (coordinates[i].longitude + coordinates[j].longitude) * factor1
        }
        area = area * 6.0
        let factor2 = 1.0/area
        centerX = centerX * factor2
        centerY = centerY * factor2
        let center = CLLocationCoordinate2D(latitude: centerX, longitude: centerY)
        return center
    }
}
