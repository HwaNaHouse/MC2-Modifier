//
//  MapView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import SwiftUI

struct MapView: View {
    
    @EnvironmentObject var sm: StateManager
    var body: some View {
        VStack {
            Text("여기는 맵뷰 입니다.")
            Button(action: {
                sm.isFullScreenShow = true
                sm.fullScreenType = .pinDetailView
            }, label: {
                Text("Go to Pin detail View")
            })
            
            Button(action: {
                sm.isFullScreenShow = true
                sm.fullScreenType = .pinAddView1
            }, label: {
                Text("Go to Pin Add View")
            })
            
            Button(action: {
                sm.tnSheet = .high
            }, label: {
                Text("TnSheet")
            })
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
