//
//  SettingsTab.swift
//  simple monitoring
//
//  Created by Ivan Novobranets on 01.04.2022.
//

import SwiftUI

struct SettingsTab: View {
    @Binding public var userData:UserData?
    
    var body: some View {
        NavigationView{
            Form{
                NavigationLink(destination: AccountSettings(userData: $userData)) {
                    Text("Account")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsTab_Previews: PreviewProvider {
    @State static private var userData:UserData?=UserData(userName: "User2", password: "asdasd")
    static var previews: some View {
        SettingsTab(userData: $userData)
    }
}
