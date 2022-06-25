//
//  PinDetailView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import SwiftUI

struct PinDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("PinDetailView")
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("뒤로가기")
            })
        }
        
    }
}

struct PinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PinDetailView()
    }
}
