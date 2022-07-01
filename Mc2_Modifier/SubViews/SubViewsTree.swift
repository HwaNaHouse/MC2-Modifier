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
struct CategoryMenuBar: View {
    @EnvironmentObject var coreVM: CoreDataViewModel
    @State var selection: Int?
    
    var body: some View {
        Menu {
            Picker(selection: $selection) {
                if !coreVM.categories.isEmpty {
                    ForEach(0..<coreVM.categories.count, id: \.self) { index in
                        Text(coreVM.categories[index].title)
                    }
                }
            } label: {} //If only use Picker, cannot customize
        } label: {
            if !coreVM.categories.isEmpty { //category가 1개라도 있을 때만 나타남.
                WhiteBackground(RoundedRectangle(cornerRadius: 10, style: .continuous), w: .infinity, h: .ten*4.4) {
                    HStack {
                        Text(coreVM.currentCategory?.title ?? "") //categories가 1개라도 있는 이상 핸들링 실수없이는 currentCategory가 있음.
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
    }
}

//beside menulabel. create category
struct PlusButton: View {
    @EnvironmentObject var sm: StateManager
    @EnvironmentObject var coreVM: CoreDataViewModel
    
    var body: some View {
        Button {
            sm.isCreateCategorySheetShow.toggle()
        } label: {
            WhiteBackground(RoundedRectangle(cornerRadius: 10),
                            w: coreVM.categories.isEmpty ? .infinity : .ten*4.4, //category 0개면 쭉 늘어나도록.
                            h: .ten*4.4) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
    }
}

//pin making button label
struct MakingPinButton: View {
    @EnvironmentObject var sm: StateManager
    @EnvironmentObject var coreVM: CoreDataViewModel
    
    var body: some View {
        Button {
            if !coreVM.categories.isEmpty {
                withAnimation {
                    sm.emotionSelectingMode.toggle()
                    //isRemove = false
                }
            } else {
                //Category부터 추가하라는 Alert 내놔야지.
            }
        } label: {
            if sm.emotionSelectingMode {
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
}

struct EmotionPicker: View {
    @EnvironmentObject var sm: StateManager
    @EnvironmentObject var coreVM: CoreDataViewModel
    
    @State private var pinModel = PinModel()
    var emotions: [String] = ["smile", "love", "sad", "soso"] //추후 미리 지정한 이모티콘들로 관리할 예정.
    var offsetRatios: [CGFloat] = [-3.4, -2, 2, 3.4]
    
    var body: some View {
        ZStack {
            ForEach(0...3, id: \.self) { index in //이렇게해야 버튼많아져도 줄 안길어진다.
                emotionButton(emotions[index], offset: .screenW * offsetRatios[index])
            }
        }
        .background(
            Capsule()
                .foregroundColor(.white)
                .maxFrame(sm.emotionSelectingMode ? .infinity : 70, 70) //frame안맞는다면 기존 코드 참고.
                .weakShadow()
        )
    }
    
    @ViewBuilder
    private func emotionButton(_ emotion: String, offset: CGFloat) -> some View {
        Button {
            withAnimation {
                pinModel.emotion = emotion
                sm.emotionSelectingMode.toggle()
                coreVM.addPin(pinModel, category: coreVM.currentCategory!) //edit 때는 addPin 함수에 지정된 category넘기면된다.
            }
        } label: {
            Image(emotion)
                .resizable()
                .frame(width: .ten*2.8, height: .ten*2.8)
        }
        .opacity(sm.emotionSelectingMode ? 1 : 0)
        .offset(x: sm.emotionSelectingMode ? offset : 0)
    }
}

//location.fill & map.fill button label
struct SideButtonLabel: View {
    var systemImage: String
    var body: some View {
        WhiteBackground(Circle(), w: .ten*5, h: .ten*5) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(.black)
        }
    }
}

struct LocationButton: View {
    @EnvironmentObject var mapVM: MapViewModel
    var body: some View {
        Button {
            mapVM.userLocationButtonTapped()
        } label: {
            SideButtonLabel(systemImage: "location.fill")
        }
    }
}

struct MapModeButton: View {
    @EnvironmentObject var sm: StateManager
    var body: some View {
        Button {
            sm.hideAimPin.toggle()
        } label: {
            SideButtonLabel(systemImage: sm.hideAimPin ? "map" : "map.fill")
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
            .fill(Color(pin.category.categoryColor!))
            .frame(width: 30, height: 30)
            .overlay(
                Image(pin.emotion)
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
            .fill(Color(pin.category.categoryColor!))
            .frame(width: 36, height: 45)
            .overlay(
                Image(pin.emotion)
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
