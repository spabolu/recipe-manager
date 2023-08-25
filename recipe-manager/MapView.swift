import CoreLocation
import Foundation
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}

extension MKPointAnnotation: Identifiable {
    public var id: UUID {
        UUID()
    }
}

struct MapView: View {
    @ObservedObject private var locationManager = LocationManager()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.83834587046632,
            longitude: 14.254053016537693),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03)
    )

    @State private var searchQuery: String = ""
    @State private var searchResults: [MKPointAnnotation] = []

    var body: some View {
        VStack {
            HStack {
                TextField(
                    "Search for grocery stores...", text: $searchQuery,
                    onCommit: {
                        searchNearbyGroceryStores()
                    }
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                Button(action: {
                    searchNearbyGroceryStores()
                }) {
                    Image(systemName: "magnifyingglass")
                }
                .padding(.trailing)
            }

            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: searchResults)
            { result in
                MapAnnotation(coordinate: result.coordinate) {
                    VStack {
                        Text(result.title ?? "")
                            .bold()
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.black.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .font(.system(size: 12))
                        Image(systemName: "mappin")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 12, height: 32, alignment: .center)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            if let userLocation = locationManager.location?.coordinate {
                region = MKCoordinateRegion(
                    center: userLocation,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.03,
                        longitudeDelta: 0.03)
                )
            }
        }
    }

    private func searchNearbyGroceryStores() {
        guard let userLocation = locationManager.location else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "grocery store " + searchQuery
        request.region = MKCoordinateRegion(
            center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            searchResults = response.mapItems.map { item in
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                annotation.subtitle = item.phoneNumber
                return annotation
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
