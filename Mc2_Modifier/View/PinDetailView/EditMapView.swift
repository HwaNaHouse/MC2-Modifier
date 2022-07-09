//
//  EditMapView.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/07/09.
//

import SwiftUI
import MapKit

struct EditMapView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coreVM: CoreDataViewModel
    @State private var region = MKCoordinateRegion(center: .defaultLocation, span: .defaultSpan)
    var latitude: Double
    var longitude: Double
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region)
                .ignoresSafeArea()
                .overlay(
                    LoopingPinView()
                )
                .onAppear {
                    region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
            
            VStack {
                Text("핀 위치 조정 모드")
                    .font(.title3.bold())
            
                Spacer()
                HStack(spacing: 20) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        bottomLabel(text: "취소하기", fontColor: .red, backColor: .white)
                    }
                    
                    Button {
                        coreVM.pinLatitude = region.center.latitude
                        coreVM.pinLongitude = region.center.longitude
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        bottomLabel(text: "현재위치로 변경", fontColor: .white, backColor: Color("default"))
                    }
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    private func bottomLabel(text: String, fontColor: Color, backColor: Color) -> some View {
        HStack {
            Spacer()
            Text(text)
                .bold()
                .foregroundColor(fontColor)
            Spacer()
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(backColor)
                .weakShadow()
        )
    }
}
