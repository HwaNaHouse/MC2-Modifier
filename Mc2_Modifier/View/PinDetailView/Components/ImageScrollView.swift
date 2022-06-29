//
//  ImageScrollView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/28.
//

import SwiftUI

struct ImageScrollView: View {
    // 사진 크게보기를 위한 바인딩 값
    //SamllImageView - Bool Value
    @Binding var isActivated : Bool
    
    //클릭 시 클릭 사진을 보여주기 위한 인덱스값
    @Binding var indexValue : Int
    
    //이미지 파일 경로가 들어가있는 리스트
//    @Binding var imageList : String?
    
    
    var body: some View {
//        if let data = imageList {
//            if data.photoArray.count > 0 {
                //Layout
                VStack(spacing : 0){
                Spacer().frame(height: 22)
                Text("Trip Image")
                        .foregroundColor(Color("default"))
                        .font(Font.system(size: 20))
                        .bold()
                    .padding(.bottom, 20)
                    
                //Image Scroll
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing : 0){
                        Spacer().frame(width: 41.5)
                        //coredata matching 필요
                        ForEach(0..<10){ i in
                        Button {
                                indexValue = i
                                isActivated.toggle()
                        }label: {
                            Image("sample1")
                                .resizable()
                                .frame(width: 300, height: 300)
                                .cornerRadius(10)
                                }
                                .padding(.bottom,20).padding(.trailing,  19)
                            }
                        }
                    }
                
                    Spacer().frame(height: 10)
                    
                }
                .background(.white)
                .shadow(color: .black.opacity(0.08), radius: 26, y: 12)
//            }
            
//        }
    }
}

