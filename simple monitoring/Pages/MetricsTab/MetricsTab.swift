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
    enum MetricsTab: Error{
        case errorJSONParsing
    }
    
    @Binding public var userData:UserData?
    @State private var loadind:Bool=true
    @State private var metrics:[Metric]=[]
    @State private var filter:String=""
    //for alerting
    @State private var showingAlert:Bool=false
    @State private var errorMessage:String=""
    
    var body: some View {
        NavigationView{
            Form{
                Section("Search"){
                    TextField("Search", text: $filter)
                }
                Section("Metrics"){
                    if(loadind){
                        ProgressView()
                            .frame(minWidth: 0,maxWidth: .infinity, alignment: .center)
                    }
                    ForEach(metrics.filter(){metric in
                        if filter.isEmpty {
                            return true
                        }
                        return metric.path.contains(filter)
                    }, id: \.path){ metric in
                        NavigationLink(destination: Text("Second View")) {
                            Text(metric.path)
                        }
                    }
                }
                .alert(errorMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .onAppear(perform: onLoad)
    }
    
    func onLoad() -> Void {
        guard let userData = userData else {
            return
        }
        
        do {
            try Server.get(userData: userData, url: "/gui/metrics/allMetrics",hook: loadData)
        } catch {
            showError("Error metrics loading \(error)")
        }
    }
    
    func showError(_ message:String) -> Void {
        print("Error \(message)")
        errorMessage=message
        showingAlert=true
    }
    /*[
     {"path":"collectd.collaborator.valorans.cpu"},
     {"path":"collectd.collaborator.valorans.df"},
     {"path":"collectd.collaborator.valorans.interface"},
     {"path":"collectd.collaborator.valorans.load"},
     */
    func loadData(data:Data?,response:URLResponse?,error:Error?) -> Void {
        guard error == nil else {
            showError("Error metrics loading \(error!.localizedDescription)")
            return
        }
        guard let data = data else {
            showError("Error Empty data")
            return
        }
        guard let str = String(data: data, encoding: .utf8) else {
            showError("Error parsing data to str")
            return
        }
        do {
            try metrics=JSONDecoder().decode([Metric].self,from: str.data(using: String.Encoding.utf8)!)
            loadind=false
        } catch {
            showError("Error parsing JSON \(error)")
        }
    }
    
}

struct MetricsTab_Previews: PreviewProvider {
    @State static private var userData:UserData?=nil
    static var previews: some View {
        MetricsTab(userData: $userData)
    }
}
