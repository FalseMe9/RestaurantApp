//
//  ContentView.swift
//  Restaurant_Tab
//
//  Created by Billie Hartanto on 21/06/25.
//

import SwiftUI
import MapKit
import CoreLocation
@Observable
@MainActor
class RestaurantViewModel{
    let user = MainData.shared.user
    var itemSheet : MapItem?
    var searchResto : Bool = false
    let house = CLLocationCoordinate2D(latitude: -7.496370828312913, longitude: 110.21012275909308)
    var location = LocationService.shared
    var camera : MapCameraPosition = .automatic
    var restaurant = [MapItem]()
    var coordinate : CLLocationCoordinate2D{
        camera.camera?.centerCoordinate ?? house
    }
    func fetchPlace(){
        let location = coordinate
        let searchSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let searchRegion = MKCoordinateRegion(center: location, span: searchSpan)
        let searchRequest = MKLocalSearch.Request()
        searchRequest.region = searchRegion
        searchRequest.resultTypes = .pointOfInterest
        searchRequest.naturalLanguageQuery = "Restaurant"
        let search = MKLocalSearch(request: searchRequest)
        search.start{response, error in
            guard let mapItems = response?.mapItems else{return}
            self.restaurant = mapItems.map({MapItem(item: $0)})
        }
    }
    func home(){
        guard let coordninate = location.locationManager.location?.coordinate else{
            print("Failed")
            return}
        goto(coordninate)
    }
    func fullView(){
        guard let coordninate = location.locationManager.location?.coordinate else{
            print("Failed")
            return}
        camera = .region(MKCoordinateRegion(center: coordninate, span: .init(latitudeDelta: 0.5, longitudeDelta: 0.5)))
    }
    func goto(_ coordinate : CLLocationCoordinate2D){
        camera = .region(MKCoordinateRegion(
            center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200))
    }
   
    static let shared = RestaurantViewModel()
}
struct RestaurantView: View {
    @Bindable var user : UserData
    @State var model = RestaurantViewModel.shared
    var body: some View {
        ZStack{
            Map(position: $model.camera){
                ForEach(model.restaurant){item in
                    let selected = user.map == item
                    let label = selected ? "mappin.and.ellipse.circle" : "fork.knife.circle"
                    let color : Color = selected ? .yellow : .green
                    Annotation("", coordinate: item.coordinate){
                        VStack{
                            Image(systemName: label)
                                .resizable()
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(color)
                                .clipShape(Circle())
                                .onTapGesture {
                                    model.itemSheet = item
                                }
                            Text(item.name)
                                .lineLimit(1)
                                .font(.footnote)
                        }
                    }
                }
                Marker("Home", systemImage: "house.circle.fill", coordinate: model.coordinate)
            }
            .ignoresSafeArea()
            HStack{
                VStack{
                    Button{
                        model.fetchPlace()
                    }label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    Button{
                        model.searchResto = true
                    }label: {
                        Image(systemName: "magnifyingglass")
                    }
                    Spacer()
                }
                Spacer()
                VStack{
                    Button{
                        model.home()
                    }label: {
                        Image(systemName: "house.fill")
                    }
                    Button{
                        model.fullView()
                    }label: {
                        Image(systemName: "arrow.down.left.and.arrow.up.right")
                    }
                    if let map = user.map{
                        Button{
                            model.goto(map.coordinate)
                        }label: {
                            Image(systemName: "mappin.and.ellipse")
                        }
                    }
                    Spacer()
                }
            }
            .buttonStyle(WhiteButton(clip: .circle))
            .padding()
            .sheet(item: $model.itemSheet){ item in
                RestaurantSheet(item: item)
            }
            .sheet(isPresented: $model.searchResto){
                SearchRestaurant()
            }
            .onAppear(){
                model.home()
                model.fetchPlace()
                model.user?.checkTime()
            }
            
        }
    }
    init(user: UserData) {
        _user = Bindable(user)
    }
}

extension MKMapItem: @retroactive Identifiable{
    public var id : String? {identifier?.rawValue}
}

#Preview {
    ContentView()
}
