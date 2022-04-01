//
//  MetricsTab.swift
//  simple monitoring
//
//  Created by Ivan Novobranets on 01.04.2022.
//

import SwiftUI

struct Metric:Codable {
    var path:String
}

struct MetricsTab: View {
    @Binding public var userData:UserData?
    @State private var metrics:[Metric]=[]
    
    var body: some View {
        ScrollView{
            VStack{
                Button("load"){
                    guard let userData = userData else {
                        return
                    }
                    
                    do {
                        try Server.get(userData: userData, url: "/gui/metrics/allMetrics",hook: loadData(data:response:error:))
                    } catch {
                        print("Error metrics loading \(error)")
                    }
                }
                ForEach(metrics, id: \.path){ metric in
                    Text(metric.path)
                }
            }
        }
    }
    
    /*[
     {"path":"collectd.collaborator.valorans.cpu"},
     {"path":"collectd.collaborator.valorans.df"},
     {"path":"collectd.collaborator.valorans.interface"},
     {"path":"collectd.collaborator.valorans.load"},
     */
    func loadData(data:Data?,response:URLResponse?,error:Error?) -> Void {
        guard error == nil else {
            print("Error metrics loading \(error!.localizedDescription)")
            return
        }
        guard let data = data else {
            print("Error Empty data")
            return
        }
        guard let str = String(data: data, encoding: .utf8) else {
            print("Error parsing data to str")
            return
        }
        do {
            try metrics=JSONDecoder().decode([Metric].self,from: str.data(using: String.Encoding.utf8)!)
        } catch {
            print("Error parsing JSON \(error)")
        }
    }
    
}

struct MetricsTab_Previews: PreviewProvider {
    @State static private var userData:UserData?=nil
    static var previews: some View {
        MetricsTab(userData: $userData)
    }
}