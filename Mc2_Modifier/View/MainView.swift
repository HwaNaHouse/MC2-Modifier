//
//  MainView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/23.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var sm: StateManager
    
    
    var body: some View {
        ZStack {
            MapView()
            
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
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
