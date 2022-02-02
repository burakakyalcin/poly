import Foundation
import CoreLocation
import CoreData

protocol HomeInteractorDelegate: AnyObject {
    func interactorDidLoadPolygons(_ interactor: HomeInteractor)
    func interactorFailedToLoadPolygons(_ interactor: HomeInteractor, error: Error)
}

final class HomeInteractor {
    weak var delegate: HomeInteractorDelegate?

    let mapZoomDistanceInMeters: Double = 500
    var isAddingOverlay: Bool = false

    private(set) var polygons: [Polygon] = []

    var currentCoordinates: [CLLocationCoordinate2D] = []

    func load() {
        let fetchRequest: NSFetchRequest<Polygon> = Polygon.fetchRequest()
        do {
            let polygons = try PersistenceService.context.fetch(fetchRequest)
            self.polygons = polygons
            delegate?.interactorDidLoadPolygons(self)
        } catch {
            delegate?.interactorFailedToLoadPolygons(self, error: error)
        }
    }

    func add(_ uiPolygon: UIPolygon) {
        let polygon = PolygonMapper.convertUIPolygonToPolygon(uiPolygon: uiPolygon)
        PersistenceService.saveContext()
        polygons.append(polygon)
    }
}
