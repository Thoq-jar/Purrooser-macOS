//
//  ContentView.swift
//  Purrooser
//
//  Created by Tristan on 9/5/24.
//

import SwiftUI
import WebKit

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainUI()
    }
}

struct ContentView: View {
    var body: some View {
        MainUI()
            .background(VisualEffectView())
            .frame(minWidth: 700, minHeight: 700)
    }
}

struct MainUI: View {
    @State private var clearDataOnClose = true
    
    var body: some View {
        VStack {
            Toggle(isOn: $clearDataOnClose) {
                Text("Paranoid Mode")
            }
            .padding()
            .onChange(of: clearDataOnClose) { oldValue, newValue in
                windowTitle()
            }
            .onAppear {
                windowTitle()
            }

            let logoscale = 10;
            Image("Purrooser")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 3840 / CGFloat(logoscale), height: 2160 / CGFloat(logoscale))
                .padding(.bottom)
                .padding(.top)
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 5) {
                    ForEach(websites, id: \.self) { website in
                        Button(action: {
                            openURL(website.urlString, title: website.name)
                        }) {
                            VStack {
                                Image(website.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                Text(website.name)
                            }
                        }
                    }
                }
                .buttonStyle(Buttons())
                .padding()
            }
        }
    }
    
    func windowTitle() {
        switch (clearDataOnClose) {
            case true: NSApp.mainWindow?.title = "Purrooser (Paranoid mode) - Welcome"
            case false: NSApp.mainWindow?.title = "Purrooser - Welcome"
        }
    }
    
    func openURL(_ urlString: String, title: String) {
        if let url = URL(string: urlString) {
            let webView = createWebViewWithDNT()
            webView.load(URLRequest(url: url))
            let hostingController = NSHostingController(rootView: WebView(webView: webView))
            let window = NSWindow(contentViewController: hostingController)
            
            switch (clearDataOnClose) {
                case true: window.title = "Purrooser (Paranoid mode) - \(title)"
                case false: window.title = "Purrooser - \(title)"
            }
            window.setFrame(NSRect(x: 0, y: 0, width: 1600, height: 900), display: true)
            window.makeKeyAndOrderFront(nil)
            window.center()
        }
    }
    
    struct WebView: NSViewRepresentable {
        let webView: WKWebView
        
        func makeNSView(context: Context) -> WKWebView { return webView }
        func updateNSView(_ nsView: WKWebView, context: Context) { return }
    }

    func createWebViewWithDNT() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let dntScript = WKUserScript(source: "navigator.doNotTrack = '1';", injectionTime: .atDocumentStart, forMainFrameOnly: true)
        let webView = WKWebView(frame: .zero, configuration: configuration)
        let dnsmpiScript = WKUserScript(source: "navigator.globalPrivacyControl = '1';", injectionTime: .atDocumentStart, forMainFrameOnly: true)

        out(put: "Sending 'DO NOT TRACK' request...")
        configuration.userContentController.addUserScript(dntScript)
        
        out(put: "Sending 'DO NOT SELL' request...")
        configuration.userContentController.addUserScript(dnsmpiScript)
        if (clearDataOnClose) {
            out(put: "Stopping cookies...")
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        } else {
            out(put: "Allowing cookies...")
        }
        return webView
    }
}
