//
//  MapView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var sm: StateManager
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var coreVM: CoreDataViewModel
    
    var body: some View {
        Map(coordinateRegion: $mapVM.region,
            interactionModes: .all,
            showsUserLocation: true,
            annotationItems: coreVM.pins) { pin in
            MapAnnotation(coordinate: CLLocationCoordinate2D(
                latitude: pin.latitude,
                longitude: pin.longitude)) {
                    PinView(pin: pin)
                }
        }
            .edgesIgnoringSafeArea(.all)
            .accentColor(.pink)
            .onTapGesture {
                coreVM.selectedPin = nil
            }
            .onAppear {
                mapVM.checkIfLocationServicesIsEnabled()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    mapVM.checkLocationManger()
                    mapVM.startUpdatingLocation()
                } else if newPhase == .background {
                    mapVM.stopUpdatingLocation()
                }
            }
            .overlay(
                aimPin()
            )
    }
    
    @ViewBuilder
    private func aimPin() -> some View {
        if !sm.hideAimPin {
            if sm.emotionSelectingMode {
                Circle()
                    .fill(Color(coreVM.currentCategory?.categoryColor ?? "default"))
                    .frame(width: .ten*3, height: .ten*3)
            } else {
                if coreVM.selectedPin == Optional(nil) {
                    LoopingPinView()
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(StateManager())
            .environmentObject(MapViewModel())
            .environmentObject(CoreDataViewModel())
    }
}
