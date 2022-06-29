//
//  PinDetailView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import SwiftUI

//offset을 저장하기 위한 class
class HomeViewModel: ObservableObject {
    @Published var offset: CGFloat = 0
}


class ImageViewModel : ObservableObject {
    @Published var allImages : [String] = ["1", "1", "1", "1"]
}

struct PinDetailView: View {
    
    // offset 저장
    @StateObject var homeData = HomeViewModel()
    
    //allImages
    @StateObject var ImageData = ImageViewModel()
    @State var indexValue : Int = 0
    let mainWidth = UIScreen.main.bounds.width
    // 사진 크게보기 트리거
    @State var isActivatedShowImageView = false
    
    @State var isActivatedEditView = false
    
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var sm: StateManager
    
    var body: some View {
        VStack {
            if let data = sm.selectedPin {
                ZStack{
                        ScrollView(showsIndicators: false){
                                
                        VStack(alignment : .center, spacing: 0){
                                
                            
//                                    GeometryReader{ render -> AnyView in
//
//                                        // offset을 설정해주기 위한 작업
//                                        let offset = render.frame(in: .global).minY
//
//                                        // 스크롤뷰를 일정 수준 이상으로 끌어내렸을 경우 dismiss되기 위한 조건문
//                                        if offset >= UIScreen.main.bounds.height*0.15{
//                                            presentationMode.wrappedValue.dismiss()
//                                        }
//                                        // offset의 부호를 바꿔주기 위한 작업. < 스크롤을 내리면 -, 올리면 + > (기존)
//                                        if -offset >= 0{
//                                            DispatchQueue.main.async {
//                                                self.homeData.offset = -offset
//                                            }
//                                        }
//                                        // GeometryReader에 해당하는 뷰 반환
//                                        return AnyView(
//
//                                            TitleImageView()
//                                                // 위로 스크롤 시 자연스러운 애니메이션을 위해 크기와 offset값이 변하도록 조정
//                                                .overlay(Color.black.opacity(homeData.offset > 0 ? homeData.offset / 400 : 0).frame(width: UIScreen.main.bounds.width))
//                                                .frame(width: 390, height: 400)
//                                        )
//                                    }.frame(height: 450)

                                        //속임수
                                        
                                        VStack(spacing: 0) {
                                            TitleImageView()
                                            RecordedMemoView().padding(.bottom, 52).padding(.top, 46)
                                            
                                            ImageScrollView(isActivated: $isActivatedShowImageView, indexValue : $indexValue ).padding(.bottom, 33).background(Color("backgroundColor"))
                                        
                                            Rectangle()
                                                .foregroundColor(.white)
                                                .frame(height: 300)
                                                .overlay(
                                                    SmallMapView()
                                                    )
                                                    .padding(.bottom, 41)
                                                
                                        }
                                                
                                }
                                
                        }.ignoresSafeArea()
                        .overlay(
                            //Section처럼 활용된 view
                            
                            
                            Text("NoNamed")
                                //글자 폰트 사이즈 조정
                                .font(Font.system(size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .opacity(homeData.offset > 240 ? 1:0)
                                //프레임 관련
                                
                                .frame(width:
                                        UIScreen.main.bounds.width, height: 72)
                                .background(VStack(spacing : 0){
                                    Color.white.opacity(homeData.offset > 240 ? 1 : 0)
                                    Divider()
                                }.ignoresSafeArea()), alignment: .top).animation(.linear(duration: 0.5), value: homeData.offset > 240)
                
                                //overlay의 애니메이션
                        
                        
                                .background(Color.white)
                        // 창닫기 편집
                        VStack {
                            HStack {
                                Circle()
                                    .foregroundColor(.black)
                                    .opacity(0.4)
                                    .frame(width: 40, height: 40)
                                
                                    //dismiss버튼
                                    .overlay(Button{
                                        self.presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        //네비게이션 시 : chevron.backward, 모달 시 : xmark
                                        Image(systemName: "xmark")
                                            .foregroundColor(.white)
                                            .font(Font.system(size: 20))
                                    })
                                    .padding(.leading, 20)
                                Spacer()
                                Circle()
                                    .foregroundColor(.black)
                                    .opacity(0.4)
                                    .frame(width: 40, height: 40)
                                    .overlay(Button{
                                        self.isActivatedEditView.toggle()
                                    } label: {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.white)
                                            .font(Font.system(size: 20))
                                    })
                                    .padding(.trailing, 20)
                            }.padding(.top, 16)
                            Spacer()
                        }
                        // 사진 크게 보기
//                    if isActivatedShowImageView {
//                        ImageDetailView(isActivatedShowImageView: $isActivatedShowImageView, indexValue: $indexValue, selectedPin: $data).transition(AnyTransition.scale.animation(.easeInOut(duration: 0.2)))
//                    }
                }
            } else {
                Text("PinDetailView")
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("뒤로가기")
                })
            }
            
        }
        
    }
}

struct PinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PinDetailView()
    }
}
