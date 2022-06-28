//
//  PinListView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import SwiftUI

struct PinListView: View {
    
    @EnvironmentObject var sm: StateManager
    
    @State var isTitleToggle: Bool = false
    @State var title: String = ""
    @State var isOffset:CGFloat = .zero
    
    @Binding var effectID: Int

    let namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 70)
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    Color.clear.frame(height: 68)
                    
                    //사진 위에 타이틀
                    VStack {
                        HStack {
                            Text("Category Title")
                                .foregroundColor(.white)
                                .font(.system(size:22))
                                .fontWeight(.bold)
                            Circle()
                                .foregroundColor(.mint)
                                .frame(width: 8, height: 8)
                                .offset(y: 5)
                            Spacer()
                        }
                        .padding(.horizontal, 23)
                        .padding(.top, 5)
                        .opacity(1)
                        HStack {
                            Text("2022.06.12")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .fontWeight(.regular)
                            Spacer()
                        }
                        .padding(.leading, 23)
                    }
                    
                    //타이틀과의 공백
                    Color.clear.frame(height: 10)
                        .padding(.bottom, 10)
                    
                    //핀 카드 뷰
                    ForEach(0..<15) { i in
                        PinCardView()
                            .onTapGesture(perform: {
                                sm.isFullScreenShow = true
                                sm.fullScreenType = .pinDetailView
                                sm.selectedPin = "selectedPin_ \(i)"
                            })
                    }
                }
                .background(GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self,
                        value: -$0.frame(in: .named("scroll")).origin.y)
                })
                // 스크롤 값 변화에 따른 연산
                .onPreferenceChange(ViewOffsetKey.self) {
                    isOffset = $0
                    print(isOffset)
                    if $0 > 95 {
                        withAnimation {
                            isTitleToggle = true
                            title = "Category Title"
                        }
                    } else {
                        withAnimation{
                            isTitleToggle = false
                        }
                    }
                    if $0 < -150 {
                        withAnimation {
                            sm.isPinListShow = false
                        }
                    }
                }
                
            }
            .coordinateSpace(name: "scroll")
            
            
            
        }
        .overlay{
            PinNavbar(isTitleToggle: $isTitleToggle, title: $title)
                .offset(y: isOffset < 0 ? -isOffset : 0)
        }
        
        //BackGround 사진 영역
        .background {
            ZStack {
                
                VStack(spacing: 0) {
                    Image("sample1")
                        .resizable()
                        .frame(height: 333)
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: effectID, in: namespace)
                    Color.clear
                }
                ZStack {
                    VStack(spacing: 0) {
                        Color.white.opacity(0.30)
                        Color.clear.opacity(0.5)
                            .frame(height: 50)
                    }
                    VStack(spacing: 0) {
                        Color.clear
                        Color.white.opacity(0.30)
                            .frame(height: 100)
                    }
                    .offset(y: 50)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .offset(y:isOffset > 212 ? -262.7 : -50 - isOffset)
            
        }
        
    }
    
}
