//
//  PinPageView.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/07/05.
//

import SwiftUI
import SwiftUIPager


struct PinPageView: View {
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var coreVM: CoreDataViewModel
    
    var body: some View {
        if coreVM.currentMapPin != Optional(nil) {
            VStack {
                Spacer()
                Pager(page: .withIndex(coreVM.pins.firstIndex(where: {$0 == coreVM.currentMapPin}) ?? 0),
                      data: coreVM.pins) { pin in
                    PageView(pin: pin)
                }
                      .onPageWillChange { index in
                          coreVM.currentMapPin = coreVM.pins[index]
                          mapVM.moveToPinLocation(coreVM.currentMapPin ?? Pin())
                      }
                      .horizontal()
                      .alignment(.center)
                      .itemSpacing(.ten*2)
                      .preferredItemSize(CGSize(width: CGFloat.screenW*0.76, height: .screenW*0.41)) //Item Size
                      .frame(height: .screenW*0.5) //Pager frame size
                Spacer().frame(height: .screenH/8.7) //TNSheet 보다 높게
            }
            .ignoresSafeArea()
        }
    }
}


struct PageView: View {
    var pin: Pin
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Text(pin.placeName?.isEmpty ?? true ? "Title Please" : pin.placeName!)
                Spacer()
                DefaultPin(pin: pin)
            }
            Spacer()
            HStack {
                Circle()
                    .foregroundColor(Color("default"))
                    .frame(width: .ten*1.8, height: .ten*1.8)
                    .overlay(
                        Text("4")
                            .font(.caption2.bold())
                            .foregroundColor(.white)
                    )
                Text("포항 여행")
                    .font(.headline)
                    .foregroundColor(Color("default"))
            }
            Spacer()
            DefaultButton(text: pin.content?.isEmpty ?? true ? "핀 완성하기" : "핀 확인하기")
        }
        .padding()
        .background(.white)
        .cornerRadius(20)
        .weakShadow()
    }
}
