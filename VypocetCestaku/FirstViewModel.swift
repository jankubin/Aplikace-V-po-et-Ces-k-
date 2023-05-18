//
//  FirstViewModel.swift
//  VypocetCestaku
//
//  Created by Jan Kubín on 17.05.2023.
//

import Foundation
import SwiftUI
import MapKit

class FirstViewModel: ObservableObject {
    @Published var startLocation: String = ""
    @Published var endLocation: String = ""
    @Published var spotreba: String = ""
    @Published var cenaPohonneHmoty: String = ""
    @Published var amortizace: String = ""
    @Published var distance: CLLocationDistance = 0.0
    @Published var celkovaCena: Double = 0.0
    @Published var isRoundTrip = false
    
    var doubleResult: Double {
            return isRoundTrip ? celkovaCena * 2 : celkovaCena
        }
    
    func calculate() {
        let spotreba = Double(spotreba) ?? 0.0
        let cenaPohonneHmoty = Double(cenaPohonneHmoty) ?? 0.0
        let amortizace = Double(amortizace) ?? 0.0

        let projeto = (spotreba / 100) * distance
        let cenaProjetychPh = projeto * cenaPohonneHmoty
        let celkovaCena = cenaProjetychPh + (amortizace * distance)

        self.celkovaCena = Double(String(format: "%.2f", celkovaCena)) ?? 0.0
        
        
        
    }
    
    func calculateDistance() {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(self.startLocation) { startPlacemarks, startError in
            geocoder.geocodeAddressString(self.endLocation) { endPlacemarks, endError in
                if let startPlacemark = startPlacemarks?.first,
                   let endPlacemark = endPlacemarks?.first {
                    if let startLocation = startPlacemark.location,
                       let endLocation = endPlacemark.location {
                        let startCoordinate = startLocation.coordinate
                        let endCoordinate = endLocation.coordinate
                        
                        // Výpočet trasy pomocí MKDirectionsRequest
                        let request = MKDirections.Request()
                        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startCoordinate))
                        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endCoordinate))
                        request.transportType = .automobile
                        
                        let directions = MKDirections(request: request)
                        directions.calculate { response, error in
                            guard let route = response?.routes.first else {
                                // Pokud se nepodaří vypočítat trasu, nastavíme vzdálenost na 0
                                self.distance = 0.0
                                return
                            }
                            
                            // Získání vzdálenosti z trasy
                            let routeDistance = route.distance
                            self.distance = routeDistance / 1000 // Převod na kilometry
                            self.calculate()
                        }
                    }
                }
            }
        }
    }
    
    func navigateToDestination() {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(self.startLocation) { startPlacemarks, startError in
            geocoder.geocodeAddressString(self.endLocation) { endPlacemarks, endError in
                if let startPlacemark = startPlacemarks?.first,
                   let endPlacemark = endPlacemarks?.first {
                    let startMapItem = MKMapItem(placemark: MKPlacemark(placemark: startPlacemark))
                    let endMapItem = MKMapItem(placemark: MKPlacemark(placemark: endPlacemark))
                    
                    let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    MKMapItem.openMaps(with: [startMapItem, endMapItem], launchOptions: options)
                }
            }
        }
    }
}
