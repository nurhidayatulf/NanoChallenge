//
//  SummaryView.swift
//  Traddy
//
//  Created by Hafidz Ismail Hidayat on 08/06/23.
//

import SwiftUI
import CoreLocation

struct SummaryView: View {
    @StateObject private var viewModelSummary = SummaryViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var itemsCount : Int
    @Binding var itemsCount2: Int
    @Binding var text: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack (spacing: 20){
                    Image("Gunung")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 185)
                    ZStack{
                        RoundedRectangle(cornerRadius: 32)
                            .frame(width: 247, height: 58)
                            .foregroundColor(Color(.white))
                            .opacity(0.85)
                            .shadow(radius: 4, x: 0, y: 2)
                        VStack {
                            Text("Summary")
                                .font(.body)
                                .fontWeight(.semibold)
                            
                        }.foregroundColor(Color("Text"))
                    }.padding(.top, -60)
                    MyDestination(selectedCoordinate: $viewModelSummary.selectedCoordinate, isShowingMapView: $viewModelSummary.isShowingMapView, text: $text)
                    HStack (spacing: 20){
                        //NavigationLink(destination: OnMyBodyView(itemsCount: $onMyBodyItemCount)){
                        OnMyBodyCard(title: "On My Body", itemCount: $viewModelSummary.onMyBodyItemCount)
                        //}
                        //NavigationLink(destination: Traddy.MyLuggage(itemsCount2: $MyLuggage)){
                        MyLuggageCard(title: "My Luggage", itemCount2: $viewModelSummary.MyLuggage)
                        //}
                    }
                    Spacer()
                }
            }.ignoresSafeArea()
                .background(Color(.white))
        }
    }
}

struct MyDestination: View{
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var isShowingMapView: Bool
    @Binding var text: String
    
    var body: some View{
        NavigationView{
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 350, height: 327)
                    .foregroundColor(Color("Button"))
                    .shadow(radius: 4, x: 0, y: 2)
                MapView(selectedCoordinate: $selectedCoordinate)
                    .frame(width: 350, height: 327)
                    .cornerRadius(15)
                    .onTapGesture {
                        isShowingMapView = true
                    }
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 350, height: 40)
                        .foregroundColor(Color("Button"))
                    HStack (spacing: 5) {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(Color(.white))
                        Text("Live Location")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.white))
                        Spacer()
                    }.padding(.horizontal, 40)
                }.padding(.top, -163)
                NavigationLink(destination: MapView(selectedCoordinate: $selectedCoordinate), isActive: $isShowingMapView) {
                    EmptyView()
                }
                .hidden()
            }
            .ignoresSafeArea()
        }
    }
}

struct OnMyBodyCard: View{
    var title: String
    @Binding var itemCount: Int // Tambahkan itemCount
    
    var body: some View{
        NavigationLink(destination: OnMyBodyView(itemsCountOnMyBody: $itemCount)){
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 165, height: 240)
                    .foregroundColor(Color("Button"))
                    .shadow(radius: 4, x: 0, y: 2)
                Image("OnMyBodyBackground")
                    .resizable()
                    .frame(width: 165, height: 240)
                VStack{
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 165, height: 40)
                            .foregroundColor(Color("Button"))
                        HStack (spacing: 5) {
                            Image(systemName: "applewatch")
                                .foregroundColor(Color(.white))
                            Text("On My Body")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(.white))
                        }
                    }
                    ZStack{
                        Circle()
                            .frame(width: 75, height: 75)
                            .foregroundColor(Color(.white))
                            .opacity(0.85)
                        VStack{
                            Text("\(itemCount)")
                                .foregroundColor(Color(.black))
                                .font(.body)
                                .fontWeight(.bold)
                            Text(itemCount <= 1 ? "Item" : "Items")
                                .foregroundColor(Color(.black))
                                .font(.caption)
                                .fontWeight(.light)
                        }
                    }
                    .padding(.vertical, 35)
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 90, height: 20)
                            .foregroundColor(Color("Button"))
                        Text("Tap to Edit")
                            .foregroundColor(Color(.white))
                            .font(.caption)
                            .fontWeight(.semibold)
                    }.padding(.bottom, 20)
                }
            }
        }
    }
}

struct MyLuggageCard: View{
    var title: String
    @Binding var itemCount2: Int // Tambahkan itemCount
    
    var body: some View{
        NavigationLink(destination: Traddy.MyLuggage(itemsCountMyLuggage: $itemCount2)){
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 165, height: 240)
                    .foregroundColor(Color("Button"))
                    .shadow(radius: 4, x: 0, y: 2)
                Image("MyLuggageBackground")
                    .resizable()
                    .frame(width: 165, height: 240)
                VStack{
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 165, height: 40)
                            .foregroundColor(Color("Button"))
                        HStack (spacing: 5) {
                            Image(systemName: "bag.fill")
                                .foregroundColor(Color(.white))
                            Text("My Luggage")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(.white))
                        }
                    }
                    ZStack{
                        Circle()
                            .frame(width: 75, height: 75)
                            .foregroundColor(Color(.white))
                            .opacity(0.85)
                        VStack{
                            Text("\(itemCount2)")
                                .foregroundColor(Color(.black))
                                .font(.body)
                                .fontWeight(.bold)
                            Text(itemCount2 <= 1 ? "Item" : "Items")
                                .foregroundColor(Color(.black))
                                .font(.caption)
                                .fontWeight(.light)
                        }
                    }.padding(.vertical, 35)
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 90, height: 20)
                            .foregroundColor(Color("Button"))
                        Text("Tap to Edit")
                            .foregroundColor(Color(.white))
                            .font(.caption)
                            .fontWeight(.semibold)
                    }.padding(.bottom, 20)
                }
            }
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(itemsCount: .constant(0), itemsCount2: .constant(0), text: .constant("text"))
    }
}
