//
//  ButtonStyle.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 07/07/25.
//

import SwiftUI
struct WhiteButton<S:Shape> : ButtonStyle{
    let clip : S
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.padding(5).background(.white).clipShape(clip)
    }
}
