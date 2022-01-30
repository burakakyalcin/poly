import Foundation
import CoreLocation

final class HomeInteractor {
    let mapZoomDistanceInMeters: Double = 500
    var isAddingOverlay: Bool = false
    private var polygons: [Polygon] = []
    var currentCoordinates: [CLLocationCoordinate2D] = []

    
}
