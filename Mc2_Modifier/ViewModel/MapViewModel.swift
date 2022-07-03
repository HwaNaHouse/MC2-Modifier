//
//  MapViewModel.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/07/01.
//

import MapKit
import SwiftUI

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // 앱의 핵심 region. 이 변수를 이용하여 각종 move를 핸들링
    @Published var region = MKCoordinateRegion(center: .defaultLocation, span: .defaultSpan)
    
    // 위치서비스가 off상태 or 위치 접근 권한이 설정되어있지않을 때 해당 alert을 띄우는 변수들
    @Published var locationServiceAlert: Bool = false
    @Published var locationWhenInUseAlert: Bool = false
    
    
    // 사용자의 위치를 관리하는 핵심 매니저 변수 (manager's type - NSObject type class)
    var locationManager: CLLocationManager?

    
    // 위치서비스 켜져있는지 check
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationManger()
        }
    }
    
    // locationManager check 후, 아직 nil이라면 초기화
    func checkLocationManger() {
        if locationManager == Optional(nil) {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func startUpdatingLocation() {
        guard let locationManager = locationManager else { return }
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        guard let locationManager = locationManager else { return }
        locationManager.stopUpdatingLocation()
    }

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if locationManager.authorizationStatus == .authorizedWhenInUse {
            guard let location = locationManager.location else { return }
            region = MKCoordinateRegion(center: location.coordinate, span: .defaultSpan)
            //1. locationManager가 처음 초기화될 때, 2. 위치 접근 권한이 안함 -> 사용으로 변경됐을 때 내 위치로 이동함.
        }
    }
    
    
    // MARK: Location-related Methods
    
    // user location
    func userLocationButtonTapped() {
        if !CLLocationManager.locationServicesEnabled() { // 위치서비스 꺼져있으면
            self.locationServiceAlert.toggle() // alert (-> 설정창)
        } else {
            if let locationManager = locationManager {
                if locationManager.authorizationStatus == .authorizedWhenInUse { // 권한되어있으면
                    guard let location = locationManager.location else { return }
                    withAnimation { // 유저위치로 이동
                        region = MKCoordinateRegion(
                            center: location.coordinate,
                            span: .calculateSpan(region)
                        )
                    }
                } else { // 권한 거절되어있으면
                    self.locationWhenInUseAlert.toggle() // alert (-> 설정창)
                }
            }
        }
    }
    
    func moveToPinLocation(_ pin: Pin) {
        withAnimation {
            region = .pinRegion(pin, region: region)
        }
    }
    
    //First pin's location in category
    //Map's center will move to first pin's location when category selection changed.
    func firstPinLocation(_ category: Category) {
        guard let pinSet = category.pin as? Set<Pin> else { return }
        let pinArray = pinSet.sorted { $0.createAt < $1.createAt }
        
        if !pinArray.isEmpty {
            region = .pinRegion(pinArray.first ?? Pin(), region: region)
        } else {
            guard let locationManager = locationManager else { return }
            guard let location = locationManager.location else { return } //위치서비스가 꺼져있으면 nil인 상태.
            withAnimation {
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: .calculateSpan(region)
                )
            }
        }
    }
}


extension CLLocationCoordinate2D {
    static let defaultLocation = CLLocationCoordinate2D(latitude: 33.465256, longitude: 126.934102)
}

extension MKCoordinateSpan {
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    
    static func calculateSpan(_ region: MKCoordinateRegion) -> MKCoordinateSpan {
        return region.span.longitudeDelta < MKCoordinateSpan.defaultSpan.longitudeDelta ? region.span : .defaultSpan
    }
}

extension MKCoordinateRegion {
    static func pinRegion(_ pin: Pin, region: MKCoordinateRegion) -> MKCoordinateRegion {
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude),
            span: .calculateSpan(region)
        )
    }
}
