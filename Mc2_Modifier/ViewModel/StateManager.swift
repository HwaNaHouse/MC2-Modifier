//
//  StateManager.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/23.
//

import SwiftUI

class StateManager: ObservableObject {
    
    @Published var isSheetShow: Bool
    
    @Published var isFullScreenShow: Bool
    
    @Published var fullScreenType: fullType
    
    @Published var tnSheet: tnSheetType
    
    @Published var isPinListShow: Bool
    
    @Published var hideAimPin: Bool // 가운데 찍는 핀 숨기는 변수
    
    @Published var emotionSelectingMode: Bool // 이모션 찍는 모드
    
    @Published var isShowCategoryAlert: Bool
    
    
    init() {
        self.isSheetShow = false
        self.isFullScreenShow = false
        self.fullScreenType = .pinDetailView
        self.tnSheet = .low
        self.isPinListShow = false
        self.hideAimPin = false
        self.emotionSelectingMode = false
        self.isShowCategoryAlert = false
    }
}

enum fullType {
    case pinDetailView, pinAddView1, pinAddView2, PinAddView3, pinUpdate
}

enum tnSheetType {
    case low, high
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
