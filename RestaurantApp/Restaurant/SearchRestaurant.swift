//
//  SearchRestaurant.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 07/07/25.
//

import SwiftUI

struct SearchRestaurant: View {
    let model : RestaurantViewModel = .shared
    @State private var searchText: String = ""
    @Environment(\.dismiss) var dismiss
    var filteredRestaurtant: [MapItem]{
        if searchText.isEmpty{model.restaurant}
        else{model.restaurant.filter{
            $0.name.localizedStandardContains(searchText)
        }}
    }
    var body: some View {
        NavigationStack{
            List(filteredRestaurtant){item in
                Text(item.name)
                    .onTapGesture {
                        model.goto(item.coordinate)
                        dismiss()
                    }
            }
            .searchable(text: $searchText, prompt: "Search Restaurant")
        }
    }
}
