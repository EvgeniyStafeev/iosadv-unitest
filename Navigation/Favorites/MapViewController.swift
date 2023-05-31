//
//  MapViewController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 23.04.2023.
//

import CoreLocation
import MapKit

final class MapViewController: UIViewController {

    private let mapView = MKMapView()
    var locationManager: CLLocationManager? = nil

    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.8)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearButtonTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        configureMapView()
        addPin(59.959043, 30.406162, title: "офис Яндекс\nСанкт-Петербург")
        addRoute(59.220532, 39.891287)
        addGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupMapView() {
        self.view.addSubview(mapView)
        self.view.addSubview(clearButton)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            clearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            clearButton.heightAnchor.constraint(equalToConstant: 40),
            clearButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func configureMapView() {
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false

        guard let location = locationManager?.location?.coordinate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.mapView.setCenter(location, animated: true)
        }
    }

    private func addPin(_ latitude: Double, _ longitude: Double, title: String?) {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        pin.title = title
        mapView.addAnnotation(pin)
    }

    private func addRoute(_ latitude: Double, _ longitude: Double) {

        let start = locationManager?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 59.565195, longitude: 150.806375)
        let finish = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: finish))

        let directions = MKDirections(request: request)

        directions.calculate { [weak self] response, error in
            guard let self else { return }
            guard let response else {
                if error != nil {
                    print("Ошибка рассчёта маршрута: \(error!.localizedDescription)")
                }
                return
            }

            if let route = response.routes.first {
                self.mapView.delegate = self
                self.mapView.addOverlay(route.polyline)
            }
        }
    }

    private func addGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(action))
        longPress.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(longPress)
    }
    @objc private func action(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newDestination = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        mapView.removeOverlays(mapView.overlays)
        addRoute(newDestination.latitude, newDestination.longitude)
        addPin(newDestination.latitude, newDestination.longitude, title: nil)
    }

    @objc private func clearButtonTap() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }

}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .red
        render.lineWidth = 3
        return render
    }

}
