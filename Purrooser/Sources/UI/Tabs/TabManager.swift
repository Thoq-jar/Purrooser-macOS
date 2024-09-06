//
//  TabManager.swift
//  Purrooser
//
//  Created by Tristan on 9/5/24.
//

import SwiftUI

class TabManager: ObservableObject {
    @Published var tabs: [Tab] = []
    @Published var activeTabIndex: Int = 0

    func addTab(_ tab: Tab) {
        tabs.append(tab)
        activeTabIndex = tabs.count - 1
    }

    func removeTab(at index: Int) {
        tabs.remove(at: index)
        if activeTabIndex >= tabs.count {
            activeTabIndex = tabs.count - 1
        }
    }

    func getActiveTab() -> Tab? {
        guard activeTabIndex < tabs.count else { return nil }
        return tabs[activeTabIndex]
    }
}
