//
//  SubViewsTree.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/06/25.
//
/*  Layout Size
 
 1. 고정 size
    - PinView
 
 2. Dynamic size
    - 그 외
 */

import SwiftUI

//MARK: - MainView's subviews...

//category menu picker label
struct MenuLabel: View {
    var title: String
    
    var body: some View {
        WhiteBackground(RoundedRectangle(cornerRadius: 10, style: .continuous), w: .infinity, h: .ten*4.4) {
                HStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.callout.bold())
                        .layoutPriority(1)
                }
                .foregroundColor(.blue)
            }
    }
}

//beside menulabel. create category
struct PlusLabel: View {
    var body: some View {
        WhiteBackground(RoundedRectangle(cornerRadius: 10), w: .ten*4.4, h: .ten*4.4) {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(.blue)
        }
    }
}

//pin making button label
struct PinButtonLabel: View {
    var isActive: Bool
    
    var body: some View {
        if isActive {
            Circle()
                .frame(width: .ten*7, height: .ten*7)
                .foregroundColor(.red)
                .overlay(
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                )
        } else {
            WhiteBackground(Circle(), w: .ten*7+1, h: .ten*7+1) {
                Image("redPin")
            }
        }
    }
}

//location.fill & map.fill button label
struct SideButtonLabel: View {
    var systemImage: String
    
    init(image systemImage: String) {
        self.systemImage = systemImage
    }
    var body: some View {
        WhiteBackground(Circle(), w: .ten*5, h: .ten*5) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(.black)
        }
    }
}

//white color background and weak shadow
struct WhiteBackground<S: Shape, Content: View>: View {
    var shape: S
    var width: CGFloat
    var height: CGFloat
    var content: () -> Content

    init(_ shape: S, w shapeWidth: CGFloat, h shapeHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.shape = shape
        self.width = shapeWidth
        self.height = shapeHeight
        self.content = content
    }
    var body: some View {
        content()
            .maxFrame(width, height) //extension
            .background(
                shape
                    .foregroundColor(.white)
                    .weakShadow() //extension
            )
    }
}


//MARK: - PinView's subviews
//2 types
struct DefaultPin: View { //mapView & detailView will use...
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

struct SelectedPin: View { //mapView will use...
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
