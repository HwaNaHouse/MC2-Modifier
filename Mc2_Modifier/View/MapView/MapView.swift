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
            annotationItems: coreVM.mapPins) { pin in
            MapAnnotation(coordinate: CLLocationCoordinate2D(
                latitude: pin.latitude,
                longitude: pin.longitude)) {
                    PinView(pin: pin)
                        .environmentObject(coreVM) //MARK: TODO: KeyPoint...PinView가 annotation이라 그런 듯함.
                }
        }
            .edgesIgnoringSafeArea(.all)
            .accentColor(.pink)
            .onTapGesture {
                coreVM.currentMapPin = nil
            }
            .onAppear {
                mapVM.checkIfLocationServicesIsEnabled()
                setCurrentCategory() //MARK: Need to check
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
    
    private func setCurrentCategory() {
        if !coreVM.categories.isEmpty { //MARK: Need to check
            coreVM.currentCategory = coreVM.categories[coreVM.currentCategoryIndex]
        }
    }
    
    @ViewBuilder
    private func aimPin() -> some View {
        if !sm.hideAimPin {
            if sm.emotionSelectingMode {
                Circle()
                    .fill(Color(coreVM.currentCategory?.categoryColor ?? "default"))
                    .frame(width: .ten*3, height: .ten*3)
            } else {
                if coreVM.currentMapPin == Optional(nil) {
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
