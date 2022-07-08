//
//  CategoryAddView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/24.
//

import SwiftUI

struct CategoryAddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var coreVM: CoreDataViewModel

    @State var isShowTitleEmptyAlert: Bool = false
    @State var categoryTitle: String = ""
    
    @State var color = "red"
    @State var showToggle = false
    @State var startDate = Date()
    
    
    @State var isDeleteAlertShowing: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        
        let colorList: [String] = ["red", "orange", "yellow", "green", "default"]
        
        VStack() {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    if coreVM.editCategoryMode {
                        coreVM.editCategoryMode = false
                    }
                    coreVM.resetCategory()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                })
                Spacer()
                Text("새로운 카테고리")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
        
                Spacer()
                if coreVM.editCategoryMode {
                    Button(action: {
                        isDeleteAlertShowing = true
                    }, label: {
                        Image(systemName: "trash")
                            .foregroundColor(.black)
                    })
                    .alert("정말 삭제하시겠습니까", isPresented: $isDeleteAlertShowing) {
                        Button("취소", role: .cancel) {}
                        Button("삭제", role: .destructive) {
                            presentationMode.wrappedValue.dismiss()
                            coreVM.deleteCategory()
                        }
                    }
                } else {
                    Image(systemName: "trash")
                        .foregroundColor(.black.opacity(0))
                }
            }
            .padding()
            
            Image("sample1")
                .resizable()
                .scaledToFit()
                .overlay {
                    ZStack {
                        Color.black.opacity(0.2)
                        VStack {
                            HStack {
                                Spacer()
                                Text("여행 사진을 선택해 보세요")
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                                    .foregroundColor(.white)
                                    
                                Image(systemName: "camera")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                
                            }
                            .padding()
                            Spacer()
                        }
                        
                    }
                    
                }
            
            VStack(alignment:.leading) {
                Text("카테고리 이름")
                    .font(Font.system(size: 16, design: .rounded))
                    .padding(.bottom, 10)
                HStack {
                    TextField("나의 \(coreVM.categories.count+1)번째 여행", text: $coreVM.categoryTitle)
                        .font(Font.system(size: 16, design: .rounded).bold())
                        .modifier(ClearButton(text: $coreVM.categoryTitle))
                    Spacer()
                    Text("\(coreVM.categoryTitle.count)/15")
                        .font(Font.system(size: 16, design: .rounded))
                        .foregroundColor(.black.opacity(0.2))
                        .onChange(of: coreVM.categoryTitle) { _ in
                            coreVM.categoryTitle = String(coreVM.categoryTitle.prefix(15))
                        }
                        .frame(width: 50)
                }
                Divider()
            }
            .padding(.horizontal)
            .padding(.top, 10 )
            
            VStack(alignment: .leading) {
                Text("색상 선택")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                HStack(spacing: 23) {
                    ForEach(colorList, id: \.self) { i in
                        Circle()
                            .fill(Color(i))
                            .frame(width: 26, height: 26)
                            .background {
                                if coreVM.categoryColor == i {
                                    Circle()
                                        .strokeBorder(.gray)
                                        .padding(-5)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                coreVM.categoryColor = i
                            }
                        
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                
                Divider()
            }
            .padding(.horizontal)
            
            
            VStack {
                HStack{
                    Text("여행 시작일")
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                    Spacer()
                }
                HStack {
                    Text(coreVM.categoryStartDate.convertToString(style: "yyyy년 MM월 dd일"))
                        .font(.callout)
                        .fontWeight(.regular)
                        .padding(.top, 10)
                    Spacer()
                    
                }
            }
            .padding(.horizontal)
            .overlay(alignment: .bottomTrailing) {
                Button{
                    showToggle.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                        .padding(.horizontal)
                }
            }
                
            Divider()
            
            HStack {
                Spacer()
                Button {
                    if coreVM.categoryTitle.isEmpty { //for Alert
                        isShowTitleEmptyAlert.toggle()
                    } else {
                        coreVM.addCategory()
                        presentationMode.wrappedValue.dismiss()
                        if coreVM.editCategoryMode {
                            coreVM.editCategoryMode = false
                        }
                        coreVM.resetCategory()
                    }
                } label: {
                    RoundedRectangle(cornerRadius: CGFloat.ten*2)
                        .foregroundColor(Color("default"))
                        .frame(height: .ten*4)
                        .padding()
                        .overlay(
                            Text("작성완료")
                                .foregroundColor(.white).bold()
                                .padding(10)
                        )
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .overlay {
            ZStack {
                if showToggle {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showToggle = false
                        }
                    
                    DatePicker.init("", selection: $coreVM.categoryStartDate)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding()
                }
            }
            .animation(.easeInOut, value: showToggle)
        }
        .alert("카테고리 이름", isPresented: $isShowTitleEmptyAlert, actions: {}, message: {
            Text("카테고리 이름은 최소 한 글자 이상이어야 합니다.")
        })
        .onDisappear {
            coreVM.resetCategory()
        }
    }
}

struct CategoryAddView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryAddView()
    }
}

struct ClearButton: ViewModifier {
    
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack(alignment: .center) {
            
            content
                .disableAutocorrection(true) //MARK: 자동완성 없애주는 친구.
                .autocapitalization(.none) //MARK: 첫 글자 대문자 안나오게.
            
            if !text.isEmpty {
                Button {
                    self.text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 10)
            }
        }
    }
}
