//
//  HistoryItem.swift
//  simple monitoring
//
//  Created by Ivan Novobranets on 05.04.2022.
//

import SwiftUI

struct HistoryItemView: View {
    var historyItem:HistoryItem
    
    var body: some View {
        VStack{
            HStack{
                Text("\(historyItem.host)")
                Spacer()
                Text("\(historyItem.getAge())")
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            HStack{
                Text("\(historyItem.triggerDescription)")
                Spacer()
            }
        }
        .padding()
        .background(
            (
                historyItem.stopDate==nil
                ?Color.init(red: 1, green: 0.8, blue: 0.8)
                :Color.init(red: 0.8, green: 1, blue: 0.8)
            )
        )
    }
}

/*[{
 "operationData": "",
 "triggerName": "Boolean",
 "triggerDescription": "Boolean metric receive false",
 "host": "db.collaborator.jenkins.job.cron.collaborator_prod.app_update-moz-da",
 "isFiltered": true,
 "id": 495014252,
 "startDate": "2022-04-05T09:01:34.999992Z",
 "stopDate": "2022-04-05T09:11:36.835646Z"
}*/

struct HistoryItemView_Previews: PreviewProvider {
    static var historyItem:HistoryItem=HistoryItem(
        id: 102_123_423,
        operationData: "",
        triggerName: "Boolean",
        triggerDescription: "Boolean metric receive false",
        host: "db.collaborator.jenkins.job.cron.collaborator_prod.app_update-moz-da",
        isFiltered: false,
        startDate: "2022-04-05T08:51:35.070788Z",
        stopDate: "2022-04-05T09:25:35.266963Z"
    )
    static var previews: some View {
        HistoryItemView(historyItem: historyItem)
    }
}
