//
//  Utility.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/06/25.
//

import SwiftUI

extension CGFloat {
    static let screenW = UIScreen.main.bounds.width
    static let screenH = UIScreen.main.bounds.height
    
    static let ten = UIScreen.main.bounds.width / 39 //iPhon13기준 10... 세밀한 dynamic 크기 작업위해...
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
