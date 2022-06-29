//
//  SmallMapView.swift
//  Mc2_Modifier
//
//  Created by Sooik Kim on 2022/06/28.
//

import SwiftUI
import MapKit

struct Location : Identifiable, Codable, Equatable{
    let id : UUID
    var name : String
    var description : String
    var latitude : Double
    var longtitude : Double
}

enum SmallMapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 36.012181, longitude: 129.323627)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
}



struct SmallMapView: View {
    
//    @Binding var selectedPin: Pin?
    
    @State var region = MKCoordinateRegion(center: SmallMapDetails.startingLocation, span: SmallMapDetails.defaultSpan)
    
    
    var body: some View {
        VStack(spacing : 0){
            Spacer().frame(height: 22)
        Text("Map")
                .bold()
                .font(Font.system(size: 20))
                .foregroundColor(Color("default"))
            .padding(.bottom, 20)
            
            Map(coordinateRegion: $region, interactionModes: [])
                .overlay(EmoticonView(emoticonColor: Color("default"), emotionFace: "love"))
            .frame(width: 344, height: 200)
            
        }
//        .onAppear{
//            if let data = selectedPin {
//                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longtitude), span: SmallMapDetails.defaultSpan)
//            }
//        }
    }
}

struct EmoticonView : View {
    var emoticonColor : Color
    var emotionFace : String
    
    var body: some View{
        Circle()
            .frame(width : 40,height: 40, alignment: .center)
            .foregroundColor(emoticonColor)
            .overlay(Image(emotionFace).font(.system(size: 32)))
    }

}

