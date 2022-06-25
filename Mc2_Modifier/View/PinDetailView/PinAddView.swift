//
//  PinAddView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import SwiftUI

struct PinAddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var sm: StateManager
    var body: some View {
        VStack {
            Text("PinAddView")
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Go back")
            })
        }
        
    }
}

struct PinAddView_Previews: PreviewProvider {
    static var previews: some View {
        PinAddView()
    }
}
