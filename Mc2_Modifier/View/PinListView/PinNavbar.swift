//
//  PinNavbar.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/27.
//

import SwiftUI

struct PinNavbar: View {
    
    @EnvironmentObject var sm: StateManager
    
    @Binding public var isTitleToggle: Bool
    @Binding public var title: String
    
    
    var body: some View {
        ZStack {
            Color.clear
                .background {
                    Color.clear
                }
            HStack {
                Button(action: {
                    withAnimation {
                        sm.isPinListShow = false
                    }
                }, label: {
                    Image(systemName:"xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width:14, height:21)
                        .background{
                            Circle()
                                .foregroundColor(.black)
                                .opacity(0.4)
                                .frame(width: 40, height: 40)
                        }
                        .padding(.leading, 38)
                })
                
                if isTitleToggle {
                    Spacer()
                    Text(title)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                    Spacer()
                } else {
                    Spacer()
                }
                // write sheet 불러오기
                Button(action: {
                    sm.isFullScreenShow = true
                    sm.fullScreenType = .pinAddView1
                }, label: {
                    Image(systemName:"pencil")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width:14, height:21)
                        .background{
                            Circle()
                                .foregroundColor(.black)
                                .opacity(0.4)
                                .frame(width: 40, height: 40)
                        }
                        .padding(.trailing, 38)
                })
                
            }
        }
        .frame(height: 70)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
