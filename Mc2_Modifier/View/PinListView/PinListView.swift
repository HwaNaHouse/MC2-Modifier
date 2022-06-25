//
//  PinListView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import SwiftUI

struct PinListView: View {
    
    @EnvironmentObject var sm: StateManager
    
    var body: some View {
        VStack(spacing: 30) {
            Text("PinListView")
            Button(action: {
                sm.isFullScreenShow = true
                sm.fullScreenType = .pinDetailView
            }, label: {
                Text("PinDetailShow in PinListView")
            })
            
            Button(action: {
                sm.isFullScreenShow = true
                sm.fullScreenType = .pinUpdate
            }, label: {
                Text("Go to PinUpdate in PinListView")
            })
            Button(action: {
                sm.isPinListShow = false
            }, label: {
                Text("Go to CategoryList")
            })
        }
        
    }
}

struct PinListView_Previews: PreviewProvider {
    static var previews: some View {
        PinListView()
    }
}
