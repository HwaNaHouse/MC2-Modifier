//
//  Utility.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/06/25.
//

import SwiftUI


extension UIScreen {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}


extension View {
    func weakShadow() -> some View { //MainView components들의 shadow.
        self
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0.5, y: 0.5)
    }
    
    func maxFrame(_ width: CGFloat, _ height: CGFloat) -> some View {
        self
            .frame(maxWidth: width, maxHeight: height)
    }
}