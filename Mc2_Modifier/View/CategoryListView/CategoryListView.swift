//
//  CategoryListView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import SwiftUI

struct CategoryListView: View {
    
    @EnvironmentObject var sm: StateManager
    
    @State var isOffset: CGFloat = .zero
    @State var isNavbarOffset: CGFloat = .zero
    
    @Namespace private var namespace
    
    @State var effectID = 0
    
    var body: some View {
        ScrollView {
            VStack {
                //Safetyarea와 Navbar 영역을 보완
                Color.clear.frame(height: sm.tnSheet == .low ? 50 : 110 )
                
                HStack {
                    Text("Total Trip")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        
                    Spacer()
                }
                .padding(.leading, 23)
                .padding(.bottom, 19)
                .padding(.top, 33)
                
                ForEach(0..<10) { _ in
                    categoryCard()
                }
                
            }
            .background(GeometryReader {
                Color.clear.preference(key: ViewOffsetKey.self,
                    value: -$0.frame(in: .named("scroll")).origin.y)
            })
            // 스크롤 값 변화에 따른 연산
            .onPreferenceChange(ViewOffsetKey.self) {
                isOffset = $0
                if sm.tnSheet == .high && (isOffset - isNavbarOffset) < -140 {
                    withAnimation {
                        sm.tnSheet = .low
                    }
                    
                }
            }

            Button(action: {
                sm.tnSheet = .low
            }, label: {
                Text("TNSheet go to low")
            })
            
            Button(action: {
                sm.isPinListShow = true
            }, label: {
                Text("PinList Show")
            })
        }
        .coordinateSpace(name: "scroll")
        .background{
            Color("backgroundColor")
        }
        .overlay(alignment: .top) {
            VStack {
                //Category Sheet 상단 네브바 역할
                HStack {
                    Text("My Moment")
                        .font(.system(size: sm.tnSheet == .low ? 20 : 24))
                        .fontWeight(.bold)
                    Spacer()
                    if sm.tnSheet == .high {
                        Button(action: {
                            sm.isSheetShow = true
                        }, label: {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.black)
                                .background{
                                    Circle()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.12), radius: 26, x: 0, y: 0)
                                }
                        })
                        .padding(.trailing, 10)
                    }
                    
                    
                }
                //TNSheet가 low에 있을 때 offset을 통해 위치를 조정해 준다
                .offset(y: sm.tnSheet == .low ? -20 : 0)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self,
                        value: -$0.frame(in: .named("navbar")).origin.y)
                })
                // 스크롤 값 변화에 따른 연산
                .onPreferenceChange(ViewOffsetKey.self) {
                    isNavbarOffset = $0
                }
                .padding(.top, 30)
                .padding(.horizontal, 21)
                .padding(.bottom, 4)
                }
                .coordinateSpace(name: "navbar")
                //TNSheet가 low에 있을 때 offset을 통해 크기를 조정해 준다
                .frame(height: sm.tnSheet == .low ? 50 : 110)
                .background{
                    Color.white.frame(maxWidth: .infinity)
                Spacer()
            }
            
            
        }.ignoresSafeArea()
        
        
    }
    
    
    @ViewBuilder
    func categoryCard() -> some View {
        ZStack {
            Image("sample1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120, alignment: .center)
                .cornerRadius(10)
            
            LinearGradient(colors: [.black.opacity(0.4), .black.opacity(0.34),.black.opacity(0.25), .white.opacity(0)], startPoint: .top, endPoint: .bottom)
                .frame(height: 120)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                HStack (spacing: 1){
                    Text("Category Title")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    
                    Circle()
                        .frame(width: 6.0, height: 6.0)
                        .foregroundColor(.mint)
                        .offset(y: 5)
                    Spacer()
                }
                Text("2022-01-01")
                    .foregroundColor(.white)
                    .font(.system(size: 11.22))
                    .fontWeight(.medium)
            }.padding(.leading, 24)
        }
        .shadow(color: .black.opacity(0.08), radius: 26, y: 12)
        .padding(.vertical, 8)
        .padding(.horizontal, 23 / 390 * UIScreen.main.bounds.width)
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
