//
//  TitleImageView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/28.
//

import SwiftUI

struct TitleImageView: View {
    
    // 대표사진 그라디언트
    let linearGradinet = LinearGradient(gradient: Gradient(colors: [.black.opacity(0), .black.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
    // 날짜 변환기
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    
    var body: some View {
        
        VStack(spacing : 0){
            
            Spacer()
            // 핀 제목
            Text("NoNamed")
                .foregroundColor(.white).bold().font(Font.system(size: 28))
            
            // 명진이의 소원
            Circle()
                .frame(width: 8, height: 8)
                .foregroundColor(Color("default"))
                .padding(.bottom, 8).padding(.top, 7)
            // 핀 날짜
            Text("\(Date(), formatter: dateFormatter)")
                .fontWeight(.regular)
                .foregroundColor(.white)
                .font(.custom("Helvetica Neue", size: 18))
                .padding(.bottom, 28)
            
        }
        .frame(height: 520)
        .background(
    //            Image(selectedpin?.photoArray.randomElement()?.photoName ?? "0")
            Image("sample1")
                .resizable()
                .scaledToFill()
                .overlay(linearGradinet)
        )
    }
}

struct TitleImageView_Previews: PreviewProvider {
    static var previews: some View {
        TitleImageView()
    }
}
