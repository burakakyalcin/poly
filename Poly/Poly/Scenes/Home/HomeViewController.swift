import UIKit
import MapKit

protocol HomeViewControllerDelegate: AnyObject {
    func viewControllerWantsToNavigateToLocationSettings(_ viewController: HomeViewController)
}

class HomeViewController: UIViewController {
    var interactor: HomeInteractor
    weak var delegate: HomeViewControllerDelegate?

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        return mapView
    }()

    private lazy var addOverlayButton: AddOverlayButton = {
        let button: AddOverlayButton = AddOverlayButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAddButton(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()

    init(interactor: HomeInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        interactor.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addComponents()
        layoutComponents()
        requestLocationPermission()
    }

    private func addComponents() {
        view.addSubview(mapView)
        view.addSubview(addOverlayButton)
    }

    private func layoutComponents() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addOverlayButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addOverlayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addOverlayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addOverlayButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            interactor.load()
        }
    }

    func drawPolygons() {
        let uiPolygons = interactor.polygons.map { PolygonMapper.convertPolygonToUIPolygon(polygon: $0) }
        uiPolygons.forEach { uiPolygon in
            let polygon = MKPolygon(coordinates: uiPolygon.coordinates, count: uiPolygon.coordinates.count)
            mapView.addOverlay(polygon)
            addCenterPin(to: uiPolygon)
        }
        locationManager.requestLocation()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, interactor.isAddingOverlay {
            let coordinate = mapView.convert(touch.location(in: mapView), toCoordinateFrom: mapView)
            interactor.currentCoordinates.append(coordinate)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, interactor.isAddingOverlay {
            let coordinate = mapView.convert(touch.location(in: mapView), toCoordinateFrom: mapView)
            interactor.currentCoordinates.append(coordinate)
            let polyline = MKPolyline(coordinates: interactor.currentCoordinates, count: interactor.currentCoordinates.count)
            mapView.addOverlay(polyline)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if interactor.isAddingOverlay {
            let polygon = MKPolygon(coordinates: &interactor.currentCoordinates, count: interactor.currentCoordinates.count)
            mapView.addOverlay(polygon)
            let latestPolygon = PolygonBuilder.build(from: interactor.currentCoordinates)
            interactor.add(latestPolygon)
            addCenterPin(to: latestPolygon)
            interactor.currentCoordinates = [] // Reset points
        }
    }

    func centerMapToLatestPolygon(_ polygon: UIPolygon) {
        let minLatitudinalCoordinate: CLLocationCoordinate2D = polygon.coordinates.min(by: { $0.latitude < $1.latitude })!
        let maxLatitudinalCoordinate: CLLocationCoordinate2D = polygon.coordinates.max(by: { $0.latitude < $1.latitude })!
        let minLongitudinalCoordinate: CLLocationCoordinate2D = polygon.coordinates.min(by: { $0.longitude < $1.longitude })!
        let maxLongitudinalCoordinate: CLLocationCoordinate2D = polygon.coordinates.max(by: { $0.longitude < $1.longitude })!

        let maxDistance = max(
            minLatitudinalCoordinate.distance(to: maxLatitudinalCoordinate),
            minLongitudinalCoordinate.distance(to: maxLongitudinalCoordinate)
        )

        let viewRegion = MKCoordinateRegion(
            center: PolygonManager.shared.polygonCenterOfMass(polygon.coordinates),
            latitudinalMeters: maxDistance,
            longitudinalMeters: maxDistance
        )

        mapView.setRegion(viewRegion, animated: true)
    }

    @objc func didTapAddButton(_ sender: UIButton) {
        interactor.isAddingOverlay.toggle()
        mapView.isUserInteractionEnabled = !interactor.isAddingOverlay
        addOverlayButton.isEditing.toggle()

        if let latestPolygon = interactor.polygons.last, !interactor.isAddingOverlay {
            centerMapToLatestPolygon(PolygonMapper.convertPolygonToUIPolygon(polygon: latestPolygon))
        }
    }

    func addCenterPin(to polygon: UIPolygon) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = polygon.centerCoordinate
        annotation.title = String(format: "Area is: %.2f square metres", polygon.area)
        annotation.subtitle = String(
            format: "Lat: %f, Lon: %f",
            polygon.centerCoordinate.latitude,
            polygon.centerCoordinate.longitude
        )
        mapView.addAnnotation(annotation)
    }
}

extension HomeViewController: HomeInteractorDelegate {
    func interactorDidLoadPolygons(_ interactor: HomeInteractor) {
        drawPolygons()
    }

    func interactorFailedToLoadPolygons(_ interactor: HomeInteractor, error: Error) {
        print(error.localizedDescription)
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .blue
            polylineRenderer.lineWidth = 1
            return polylineRenderer
        } else if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = .blue.withAlphaComponent(0.5)
            polygonView.strokeColor = .blue
            polygonView.lineWidth = 1
            return polygonView
        }
        return MKPolylineRenderer(overlay: overlay)
    }

}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        let latestLocationCoordinate = latestLocation.coordinate
        let viewRegion = MKCoordinateRegion(
            center: latestLocationCoordinate,
            latitudinalMeters: interactor.mapZoomDistanceInMeters,
            longitudinalMeters: interactor.mapZoomDistanceInMeters
        )
        mapView.setRegion(viewRegion, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .denied, .restricted:
            showLocationServicesAreDisabledError()
        case .notDetermined:
            requestLocationPermission()
        @unknown default:
            break
        }
    }

    func showLocationServicesAreDisabledError() {
        let alertController = LocationServicesDisabledAlertBuilder { [weak self] in
            guard let self = self else { return }
            self.delegate?.viewControllerWantsToNavigateToLocationSettings(self)
        }
        present(alertController.make(), animated: true)
    }
}
