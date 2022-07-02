//
//  MainView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var sm: StateManager
    
    var body: some View {
        ZStack {
            MapView()
            VStack {
                HStack {
                    CategoryMenuBar()
                    Spacer()
                    PlusButton()
                }
                .padding(.ten*3)
                Spacer()
                ZStack {
                    HStack(spacing: 15) { // first floor
                        LocationButton()
                        Spacer().frame(width: sm.hideAimPin ? 0 : .ten*7, height: .ten*7) // dummy frame for spacing control
                        MapModeButton()
                    }
                    if !sm.hideAimPin {
                        EmotionPicker() // second floor
                        MakingPinButton() // third floor
                    }
                }
                Spacer().frame(height: .screenH / 9.3) // 왜 넣었는지 기억안나서 시뮬돌릴때 한번 빼보자.
            }
            // PinPageView 들어갈 곳
            
            // DelayView 들어갈 곳
            
            TotalTripview()
        }
        
        // 카테고리 추가는 sheet로
        .sheet(isPresented: $sm.isSheetShow, content: {
            CategoryAddView()
        })
        
        // 핀 추가, 업데이트는 풀스크린으로 상태값 관리로 이루어진다.
        .fullScreenCover(isPresented: $sm.isFullScreenShow, content: {
            FullScreenSheet()
        })
        
        .modifier(LocationAlert(locationServiceEnabled: $mapVM.locationServiceAlert,
                                locationWhenInUseEnabled: $mapVM.locationWhenInUseAlert))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MapViewModel())
            .environmentObject(StateManager())
    }
}
