//
//  LocationManager.swift
//  SwiftConcurrency-Study
//
//  Created by kazunori.aoki on 2022/08/17.
//

import Foundation
import CoreLocation

@MainActor
final class LocationManager: NSObject, ObservableObject {

    struct LocationError: Error {
        let message: String
    }

    @Published var showAuthorizationAlert: Bool = false
    @Published var coordinator: CLLocationCoordinate2D = .init()

    var asyncStreamTask: Task<Void, Never>?
    var asyncThrowingStreamTask: Task<Void, Never>?

    var locations: AsyncStream<CLLocationCoordinate2D> {
        AsyncStream { [weak self] continuation in
            self?.continuation = continuation
        }
    }

    var locationWithError: AsyncThrowingStream<CLLocationCoordinate2D, Error> {
        AsyncThrowingStream { [weak self] continuation in
            guard let s = self else { return }

            switch s.locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                continuation.finish(throwing: LocationError(message: "位置情報を許可してください"))
            default:
                break
            }

            continuationWithError = continuation
        }
    }

    private let locationManager = CLLocationManager()

    private var continuation: AsyncStream<CLLocationCoordinate2D>.Continuation? {
        didSet {
            continuation?.onTermination = { @Sendable [weak self] _ in
                self?.locationManager.stopUpdatingLocation()
            }
        }
    }

    private var continuationWithError: AsyncThrowingStream<CLLocationCoordinate2D, Error>.Continuation? {
        didSet {
            continuationWithError?.onTermination = { @Sendable [weak self] _ in
                self?.locationManager.stopUpdatingLocation()
            }
        }
    }

    func setup() {
        locationManager.delegate = self

        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showAuthorizationAlert = true
        @unknown default:
            break
        }
    }

    func startLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopLocation() {
        locationManager.stopUpdatingLocation()
        continuation?.finish()
        continuationWithError?.finish(throwing: nil)
    }

    func cleanup() {
        asyncStreamTask?.cancel()
        asyncThrowingStreamTask?.cancel()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            continuationWithError?.finish(throwing: LocationError(message: "位置情報がありません"))
            return
        }

        coordinator = lastLocation.coordinate

        continuation?.yield(lastLocation.coordinate)
        continuationWithError?.yield(lastLocation.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showAuthorizationAlert = true
        default:
            break
        }
    }
}
