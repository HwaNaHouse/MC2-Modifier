//
//  PinAddView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import SwiftUI
import CoreLocation

struct PinAddView: View {
    @EnvironmentObject var sm: StateManager
    @EnvironmentObject var coreVM: CoreDataViewModel
    
    @State private var addressName: String = ""
    @State private var showCalendar: Bool = false
    @State private var isShowTitleEmptyAlert: Bool = false
    
    var emotions: [String] = ["smile", "love", "sad", "soso"]
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading, spacing: .ten*2) {
                    Spacer().frame(height: .ten*2)
                    
                    Text("핀 완성하기")
                        .font(.largeTitle.bold())
                    
                    Spacer()
                    
                    Group {
                        EditSectionView(title: "카테고리") {
                            CategoryEditBar()
                        }
                        
                        EditSectionView(title: "핀 제목") {
                            HStack {
                                TextField("핀의 제목을 입력해주세요", text: $coreVM.pinTitle) //
                                    .submitLabel(.done)
                                    .modifier(ClearButton(text: $coreVM.pinTitle))
                                Spacer()
                                Text("\(coreVM.pinTitle.count)/15")
                                    .font(Font.system(size: 16, design: .rounded))
                                    .foregroundColor(.black.opacity(0.2))
                                    .onChange(of: coreVM.pinTitle) { _ in
                                        coreVM.pinTitle = String(coreVM.pinTitle.prefix(15))
                                    }
                            }
                        }
                        
                        EditSectionView(title: "핀의 날짜") {
                            Button {
                                withAnimation {
                                    showCalendar.toggle()
                                }
                            } label: {
                                HStack(spacing: .ten*1.5) {
                                    Text(coreVM.pinCreateAt.convertToString(style: "yyyy년 MM월 dd일 HH시 mm분"))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .resizable()
                                        .foregroundColor(.green)
                                        .frame(width: .ten*2, height: .ten*2)
                                }
                            }
                        }
                        
                        EditSectionView(title: "핀의 위치") {
                            NavigationLink {
                                // 새로운 위치조절용 지도뷰
                            } label: {
                                HStack(spacing: .ten*1.5) {
                                    Text(addressName).foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "mappin.and.ellipse")
                                        .resizable()
                                        .foregroundColor(.red)
                                        .frame(width: .ten*2, height: .ten*2)
                                }
                            }
                        }
                        
                        EditSectionView(title: "핀의 감정") {
                            HStack(spacing: .ten*4) {
                                ForEach(emotions, id: \.self) {
                                    emotionButton($0)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                    HStack {
                        Button {
                            sm.isFullScreenShow = false
                            //취소 로직
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) { //sheet내려가는동안 순간적으로 초기화되는 모습 보이는 것이 눈에 밟혀서.
                                coreVM.selectedPin = nil
                                coreVM.resetPin()
                                coreVM.editPinMode = false
                                coreVM.selectedCategory = nil
                            }
                        } label: {
                            Text("취소하기")
                        }
                        .buttonStyle(PreviousButtonStyle())
                        
                        Button {
                            if coreVM.pinTitle.isEmpty {
                                isShowTitleEmptyAlert.toggle()
                            } else {
                                withAnimation {
                                    sm.fullScreenType = .pinAddView2
                                }
                            }
                        } label: {
                            Text("다음 단계로")
                        }
                        .buttonStyle(NextButtonStyle())
                    }
                    
                    Spacer().frame(height: .ten)
                }
                .padding()
                // 주소값 렌더링
                .onAppear {
                    locate()
                }
                .onChange(of: coreVM.selectedPin) { _ in
                    locate()
                }
                if showCalendar {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showCalendar = false
                        }
                    
                    DatePicker.init("", selection: $coreVM.pinCreateAt)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding()
                }
            }
            .alert("핀 제목", isPresented: $isShowTitleEmptyAlert, actions: {}, message: {
                Text("핀 제목은 최소 한 글자 이상이어야 합니다.")
            })
        }
        .ignoresSafeArea(.keyboard)
    }
    
    // 해당 위치의 주소값을 가져오는 함수.
    private func locate() {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coreVM.selectedPin?.latitude ?? 30, longitude: coreVM.selectedPin?.longitude ?? 120), preferredLocale: Locale(identifier: "Ko_kr"), completionHandler: {(placemarks, error) in
            addressName = ""
            if let address: [CLPlacemark] = placemarks {
                if let admin: String = address.last?.administrativeArea {
                    if !self.addressName.contains(admin) {
                        self.addressName += "\(admin) "
                    }
                }
                if let locality: String = address.last?.locality {
                    if !self.addressName.contains(locality) {
                        self.addressName += "\(locality) "
                    }
                }
                if let name: String = address.last?.name {
                    if !self.addressName.contains(name) {
                        self.addressName += "\(name) "
                    }
                }
            }
            if self.addressName.isEmpty {
                self.addressName += "알 수 없는 주소"
            }
        })
    }
    
    @ViewBuilder
    private func emotionButton(_ emotion: String) -> some View {
        Button {
            coreVM.pinEmotion = emotion
        } label: {
            Image(emotion)
                .resizable()
                .frame(width: .ten*2.8, height: .ten*2.8)
                .padding(3)
                .background(
                    Circle()
                        .fill(Color(coreVM.selectedPin?.category.categoryColor ?? "default"))
                )
                .opacity(
                    emotion == coreVM.pinEmotion ? 1 : 0.2
                )
        }
    }
}


struct PreviousButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: .ten*4.2, maxHeight: .ten*4.2)
            .font(.title3.bold())
            .foregroundColor(Color("default"))
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("default"), lineWidth: 1)
            )
    }
}

struct NextButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: .ten*4.2, maxHeight: .ten*4.2)
            .font(.title3.bold())
            .foregroundColor(.white)
            .background(Color("default"))
            .cornerRadius(10)
    }
}
