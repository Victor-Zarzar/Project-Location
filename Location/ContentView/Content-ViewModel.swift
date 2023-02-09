//
//  Content-ViewModel.swift
//  Location
//
//  Created by Victor Zarzar on 08/02/23.
//

import Foundation
import SwiftUI
import MapKit

extension ContentView {
    final class ViewModel: ObservableObject {
        @Published var ipAddress: String = "Retrieving..."
        @Published var ipGeo = IPGeo(city: "City", country: "Country", timezone: "Timezone")
        @Published var location = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        private let api = APIManager()
        
        // Initializations
        init() {
            fetchIP()
        }
        
        //Helper function to make sure items get updated on the main thread
        func runOMain(_ method:@escaping () -> Void) {
            DispatchQueue.main.async {
                withAnimation {
                    method()
                }
            }
        }
        
        private func fetchIP() {
            api.fetchData(url: "https://api.ipify.org?format=json", model: IP.self) { result in
                self.runOMain {
                    self.ipAddress = result.ip
                    self.fetchGeoData(ip: result.ip)
                    self.fetchLocation(ip: result.ip)
                }
            } failure: { error in
                self.runOMain {
                    print("IP: \(error.localizedDescription)")
                    
                    //In case of error, try again after 10 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        print("Trying again to fetch IP...")
                        self.fetchIP()
                    }
                }
            }
        }
        
        private func fetchGeoData(ip: String) {
            api.fetchData(url: "https://ipinfo.io/\(ip)/geo", model: IPGeo.self) { result in
                self.runOMain {
                    self.ipGeo = result
                }
            } failure: { error in
                print("GeoData: \(error.localizedDescription)")
            }
        }
        
        // Fetch the location of the IP address
        private func fetchLocation(ip: String) {
            api.fetchData(url: "https://ipapi.co/\(ip)/json/", model: IPCoordinates.self) { result in
                self.runOMain {
                    self.location = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                }
            } failure: { error in
                print("IPCoordinates: \(error.localizedDescription)")
            }
        }
    }
}
