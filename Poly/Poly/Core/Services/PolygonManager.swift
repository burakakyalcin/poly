import CoreLocation

struct PolygonManager {
    static let shared = PolygonManager()
    private init() { }

    private let kEarthRadius = 6378137.0

    private func radians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }

    func regionArea(_ locations: [CLLocationCoordinate2D]) -> Double {

        guard locations.count > 2 else { return 0 }
        var area = 0.0

        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]

            area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
        }
        area = -(area * kEarthRadius * kEarthRadius / 2)
        return max(area, -area) // In order not to worry about is polygon clockwise or counterclockwise defined.
    }

    private func signedPolygonArea(_ coordinates: [CLLocationCoordinate2D]) -> Double {
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
