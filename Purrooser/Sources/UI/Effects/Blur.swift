//
//  Blur.swift
//  Purrooser
//
//  Created by Tristan on 9/5/24.
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSVisualEffectView()
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
