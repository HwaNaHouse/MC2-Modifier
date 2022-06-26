//
//  SubViewsTree.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/06/25.
//

import SwiftUI

//MARK: - MainView's subviews...
struct CircleView: View { //location, pin, map buttons...etc...
    var imageName: String
    var size: CGFloat
    var font: Font
    
    var body: some View {
        Circle()
            .frame(width: size, height: size)
            .foregroundColor(.white)
            .weakShadow()
            .overlay(
                Image(systemName: imageName)
                    .font(font)
                    .foregroundColor(.black)
            )
    }
}


//MARK: - PinView's subviews...
//two shapes - default shape & selected shape
struct DefaultPin: View {
    var pin: Pin
    
    var body: some View {
        Circle()
            .fill(Color(pin.category!.categoryColor!))
            .frame(width: 30, height: 30)
            .overlay(
                Image(pin.emotion ?? "smile")
                    .resizable()
                    .frame(width: 23, height: 23)
            )
            .padding()
    }
}

struct SelectedPin: View {
    var pin: Pin
    
    var body: some View {
        PinShape()
            .fill(Color(pin.category!.categoryColor!))
            .frame(width: 36, height: 45)
            .overlay(
                Image(pin.emotion ?? "smile")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .offset(y: -4)
            )
            .offset(y: -22)
            .padding()
    }
}

struct PinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: width, y: 0.40909*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: height), control1: CGPoint(x: width, y: 0.72727*height), control2: CGPoint(x: 0.5*width, y: height))
        path.addCurve(to: CGPoint(x: 0, y: 0.40909*height), control1: CGPoint(x: 0.5*width, y: height), control2: CGPoint(x: 0, y: 0.72727*height))
        path.addCurve(to: CGPoint(x: 0.14645*width, y: 0.11982*height), control1: CGPoint(x: 0, y: 0.30059*height), control2: CGPoint(x: 0.05268*width, y: 0.19654*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0), control1: CGPoint(x: 0.24021*width, y: 0.0431*height), control2: CGPoint(x: 0.36739*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.85355*width, y: 0.11982*height), control1: CGPoint(x: 0.63261*width, y: 0), control2: CGPoint(x: 0.75979*width, y: 0.0431*height))
        path.addCurve(to: CGPoint(x: width, y: 0.40909*height), control1: CGPoint(x: 0.94732*width, y: 0.19654*height), control2: CGPoint(x: width, y: 0.30059*height))
        path.closeSubpath()
        return path
    }
}
