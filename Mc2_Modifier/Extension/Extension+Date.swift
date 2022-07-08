//
//  Extension+Date.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/07/08.
//

import SwiftUI

extension Date {
    func convertToString(style format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko")
        return formatter.string(from: self)
    }
}
