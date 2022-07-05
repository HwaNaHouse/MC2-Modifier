//
//  MainView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var sm: StateManager
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        GeometryReader { geometry in // Need to check...
            ZStack {
                MapView() // 1층 -> LoopingPinView는 2층
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
                    Spacer().frame(height: .screenH / 9.3)
                } // 2층
                // PinPageView 들어갈 곳
                PinPageView()
                
                // DelayView 들어갈 곳
                
                TotalTripview() // 3층
            }
        }
        .ignoresSafeArea(.keyboard) //Need to check. 이 View가 keyboard area에 영향받지않도록 설정.
        
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
        
            .modifier(CreateCategoryAlert(isShowCategoryAlert: $sm.isShowCategoryAlert))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MapViewModel())
            .environmentObject(StateManager())
    }
}
