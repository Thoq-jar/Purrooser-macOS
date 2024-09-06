//
//  Buttons.swift
//  Purrooser
//
//  Created by Tristan on 9/5/24.
//

import SwiftUI

struct Buttons: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(0)
            .background(Color.clear)
            .foregroundColor(.primary)
            .padding(0)
    }
}
