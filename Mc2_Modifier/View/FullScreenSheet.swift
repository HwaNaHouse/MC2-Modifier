//
//  FullScreenSheet.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/23.
//

import SwiftUI

struct FullScreenSheet: View {
    
    @EnvironmentObject var sm: StateManager
    
    var body: some View {
        
        VStack {
            switch sm.fullScreenType {
            case .pinDetailView:
                PinDetailView()
            case .pinAddView1:
                PinAddView()
            case .pinAddView2:
//                PinAddView()
                Text("Hello Step2 View")
            case .pinAddView3:
                PinAddView()
            case .pinUpdate:
                PinUpdateView()
            }
        }
        
    }
}

struct FullScreenSheet_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenSheet()
    }
}
