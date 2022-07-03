//
//  PinView.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/07/03.
//

import SwiftUI

struct PinView: View {
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var coreVM: CoreDataViewModel
    var pin: Pin
    
    var body: some View {
        Button {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
                coreVM.currentMapPin = pin //map과 동시에 눌리는 것 방지위해.
                //pin위치로 이동함수 구현
                mapVM.moveToPinLocation(pin)
            }
        } label: {
            //모든 pin들 공통사항
            if pin == coreVM.currentMapPin {
                SelectedPin(pin: pin)
            } else {
                DefaultPin(pin: pin)
            }
        }
    }
}
