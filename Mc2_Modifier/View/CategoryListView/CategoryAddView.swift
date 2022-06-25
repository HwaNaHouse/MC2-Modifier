//
//  CategoryAddView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import SwiftUI

struct CategoryAddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Category Add View")
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Back")
            })
        }
    }
}

struct CategoryAddView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryAddView()
    }
}
