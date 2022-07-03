//
//  Alerts.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/07/01.
//

import Foundation
import SwiftUI

// locationServiceEnabled - 위치 서비스가 꺼져있을 때의 Alert 불리언 값
// locationWhenInUseEnabled - 위치 서비스는 켜져있으나 권한이 없을 때의 Alert 불리언 값
struct LocationAlert: ViewModifier {
    @Binding var locationServiceEnabled: Bool
    @Binding var locationWhenInUseEnabled: Bool
    func body(content: Content) -> some View {
        content
            .alert("위치 서비스", isPresented: $locationServiceEnabled) {
                Button(role: .cancel) {} label: { Text("취소") }
                Button {
                    //설정창으로 이동
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text("설정")
                }
            } message: {
                Text("위치 서비스가 켜져있어야 사용가능한 기능입니다.")
            }
            .alert("위치 접근 권한", isPresented: $locationWhenInUseEnabled) {
                Button(role: .cancel) {} label: { Text("취소") }
                Button {
                    //설정창으로 이동
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text("설정")
                }
            } message: {
                Text("위치 접근 권한을 앱을 사용할 때 허용으로 변경해주십시오.")
            }
    }
}

//삭제 - case 1. 카테고리 delete. case 2. 핀 delete
struct DeleteAlert: ViewModifier {
    @Binding var isShowDeleteAlert: Bool
    var deleteCase: DataCase
    func body(content: Content) -> some View {
        content
            .alert("삭제하시겠습니까", isPresented: $isShowDeleteAlert) {
                Button(role: .cancel) {} label: { Text("취소") }
                Button(role: .destructive) {
                    switch deleteCase {
                    case .category:
                        // 해당 category 삭제
                        print()
                    case .pin:
                        // 해당 pin 삭제
                        print()
                    }
                } label: {
                    Text("삭제")
                }
            } message: {
                Text("저장한 모든 기록이 삭제됩니다.")
            }
    }
}

enum DataCase {
    case category
    case pin
}

struct CreateCategoryAlert: ViewModifier {
    @Binding var isShowCategoryAlert: Bool
    func body(content: Content) -> some View {
        content
            .alert("선택된 카테고리 없음", isPresented: $isShowCategoryAlert) {
                Button(role: .cancel) {} label: { Text("취소") }
                Button {
                    //카테고리 생성 Sheet 띄우는 bool값 control
                } label: {
                    Text("카테고리 생성")
                }
            } message: {
                Text("카테고리를 먼저 생성한 후 해당 카테고리에 핀을 남길 수가 있습니다")
            }
    }
}
