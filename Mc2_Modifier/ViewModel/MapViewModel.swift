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

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if locationManager.authorizationStatus == .authorizedWhenInUse {
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: .defaultSpan)
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
                    withAnimation { // 유저위치로 이동
                        region = MKCoordinateRegion(
                            center: locationManager.location!.coordinate,
                            span: .defaultSpan
                        )
                    }
                } else { // 권한 거절되어있으면
                    self.locationWhenInUseAlert.toggle() // alert (-> 설정창)
                }
            }
        }
    }
}


extension CLLocationCoordinate2D {
    static let defaultLocation = CLLocationCoordinate2D(latitude: 33.465256, longitude: 126.934102)
}

extension MKCoordinateSpan {
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
}
