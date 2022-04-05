//
//  HistoryTab.swift
//  simple monitoring
//
//  Created by Ivan Novobranets on 05.04.2022.
//

import SwiftUI

/*[{
 "operationData": "",
 "triggerName": "Boolean",
 "triggerDescription": "Boolean metric receive false",
 "host": "db.collaborator.jenkins.job.cron.collaborator_prod.app_update-moz-da",
 "isFiltered": true,
 "id": 495014252,
 "startDate": "2022-04-05T09:01:34.999992Z",
 "stopDate": "2022-04-05T09:11:36.835646Z"
}, {
 "operationData": "",
 "triggerName": "Boolean",
 "triggerDescription": "Boolean metric receive false",
 "host": "db.vova500.bots.responses",
 "isFiltered": true,
 "id": 494999021,
 "startDate": "2022-04-05T08:51:35.070788Z",
 "stopDate": "2022-04-05T09:25:35.266963Z"
},
 */

struct HistoryItem:Codable {
    var id:Int
    var operationData:String
    var triggerName:String
    var triggerDescription:String
    var host:String
    var isFiltered:Bool
    var startDate:String
    var stopDate:String?
    
    func getStartDate() -> Date? {
        let javaDateFormatter = DateFormatter()
        javaDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        javaDateFormatter.timeZone = TimeZone(abbreviation: "GMT+00:00")
        
        return javaDateFormatter.date(from: startDate)
    }
    
    func getAge() -> String {
        guard let startDate = getStartDate() else {
            return "!ERROR!"
        }
        
        let diffComponents:DateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: startDate, to: Date.now)
        if let year = diffComponents.year, year > 0 {
            return "\(year) years"
        }
        if let mon = diffComponents.month, mon > 0 {
            return "\(mon) month"
        }
        if let day = diffComponents.day, day > 0 {
            return "\(day) days"
        }
        if let hour = diffComponents.hour, hour > 0 {
            return "\(hour) hours"
        }
        if let minute = diffComponents.minute, minute > 0 {
            return "\(minute) mins"
        }

        return "just now"
    }
}

struct HistoryTab: View {
    enum HistoryTab: Error{
        case errorJSONParsing
    }
    
    @Binding public var userData:UserData?
    @State private var loadind:Bool=true
    @State private var historyItems:[HistoryItem]=[]
    //
    @State private var filter:String=""
    @State private var onlyFiltered:Bool=true
    @State private var onlyAlerted:Bool=false
    //for alerting
    @State private var showingAlert:Bool=false
    @State private var errorMessage:String=""

    var body: some View {
            Form{
                Section(){
                    Toggle("Only filtered", isOn: $onlyFiltered)
                    Toggle("Only alerted", isOn: $onlyAlerted)
                    TextField("Search", text: $filter)
                }
                Section("History"){
                    if(loadind){
                        ProgressView()
                            .frame(minWidth: 0,maxWidth: .infinity, alignment: .center)
                    }
                    ForEach(historyItems.filter(filter), id: \.id) { historyItem in
                        HistoryItemView(historyItem: historyItem)
                    }
                }
                .alert(errorMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
        .onAppear(perform: onLoad)
    }
    
    func filter(_ historyItem:HistoryItem) -> Bool {
        if onlyAlerted && historyItem.stopDate != nil {
            return false
        }
        if onlyFiltered && historyItem.isFiltered {
            return false
        }
        if filter.isEmpty {
            return true
        }
        return historyItem.host.contains(filter)
    }
    
    func onLoad() -> Void {
        guard let userData = userData else {
            return
        }
        
        do {
            try Server.get(userData: userData, url: "/gui/history/allProblems",hook: loadData)
        } catch {
            showError("Error metrics loading \(error)")
        }
    }
    
    func showError(_ message:String) -> Void {
        print("Error \(message)")
        errorMessage=message
        showingAlert=true
    }

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
            try historyItems=JSONDecoder().decode([HistoryItem].self,from: str.data(using: String.Encoding.utf8)!)
            loadind=false
        } catch {
            showError("Error parsing JSON \(error)")
        }
    }
}

struct HistoryTab_Previews: PreviewProvider {
    @State static private var userData:UserData?=nil
    static var previews: some View {
        HistoryTab(userData: $userData)
    }
}
