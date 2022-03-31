//
//  simple_monitoringApp.swift
//  simple monitoring
//
//  Created by Ivan Novobranets on 29.03.2022.
//

import SwiftUI

@main
struct simple_monitoringApp: App {
    @State public var userData:UserData?
    
    var body: some Scene {
        WindowGroup {
            if userData == nil {
                LoginWindow(userData: $userData)
            } else {
                MainWindow()
            }
        }
    }
}
