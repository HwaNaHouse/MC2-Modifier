//
//  MapView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @EnvironmentObject var sm: StateManager
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var coreVM: CoreDataViewModel
    
    var body: some View {
        Map(coordinateRegion: $mapVM.region,
            interactionModes: .all, //[mapVM.canMove ? .all : .zoom]
            showsUserLocation: true, //오류나면 이것도 핸들링 예정
            annotationItems: coreVM.currentCategory?.pinArray ?? []) { pin in
            MapAnnotation(coordinate: CLLocationCoordinate2D(
                latitude: pin.latitude,
                longitude: pin.longitude)) {
                    //PinView
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
            .overlay(
                aimPin()
            )
    }
    
    @ViewBuilder
    private func aimPin() -> some View {
        if !sm.hideAimPin {
            if sm.emotionSelectingMode {
                Circle()
                    .fill(coreVM.currentCategory?.convertedColor ?? .clear)
                    .frame(width: .ten*3, height: .ten*3)
            } else {
                if coreVM.selectedPin == Optional(nil) {
                    //LoopingPinView()
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
