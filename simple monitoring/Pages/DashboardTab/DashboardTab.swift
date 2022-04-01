//
//  DashboardTab.swift
//  simple monitoring
//
//  Created by Ivan Novobranets on 01.04.2022.
//

import SwiftUI

struct DashboardTab: View {
    @Binding public var userData:UserData?
    var body: some View {
        Button("test"){
            guard let myUserData = userData else {
                return
            }
            do{
                try Server.get(userData: myUserData, url: "/gui/dashboard/currentProblems",hook: loadData(data:response:error:))
            }catch{
                print("Error \(error)")
            }
        }
    }
    
    func loadData(data:Data?,response:URLResponse?,error:Error?) -> Void {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        guard let data = data else {
            print("Empty data")
            return
        }
        
        if let str = String(data: data, encoding: .utf8) {
            print(str)
        }
    }
}

struct DashboardTab_Previews: PreviewProvider {
    @State static private var userData:UserData?=nil
    
    static var previews: some View {
        DashboardTab(userData: $userData)
    }
}
