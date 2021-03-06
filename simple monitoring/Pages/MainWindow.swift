//
//  MainWindow.swift
//  simple monitoring
//
//  Created by Ivan Novobranets on 31.03.2022.
//

import SwiftUI

struct MainWindow: View {
    @Binding public var userData:UserData?

    var body: some View {
        TabView {
            DashboardTab(userData: $userData)
                .badge(10)
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("Dashboards")
                }
            MetricsTab(userData: $userData)
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Metrics")
                }
            HistoryTab(userData: $userData)
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("History")
                }
            SettingsTab(userData: $userData)
                .tabItem {
                    Image(systemName: "4.square.fill")
                    Text("Settings")
                }
        }
        .font(.headline)
        
    }
}

struct MainWindow_Previews: PreviewProvider {
    @State static private var userData:UserData?=nil
    static var previews: some View {
        MainWindow(userData: $userData)
    }
}
