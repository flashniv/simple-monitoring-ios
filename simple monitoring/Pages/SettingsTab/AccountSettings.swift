//
//  AccountSettings.swift
//  simple monitoring
//
//  Created by Ivan Novobranets on 01.04.2022.
//

import SwiftUI

struct AccountSettings: View {
    @Binding public var userData:UserData?
    @State private var presentingConfirmationDialog:Bool = false

    var body: some View {
        Form{
            if userData==nil {
                Text("You not logged in")
            }else{
                Text("Your account is "+userData!.userName)
                Button("Logout"){
                    presentingConfirmationDialog=true
                }
                .confirmationDialog("", isPresented: $presentingConfirmationDialog) {
                    Button("Logout", role: .destructive, action: {
                        do{
                            try UserData.deleteFromDevice(oldUserData: userData!)
                            userData=nil
                        }catch{
                            print("Error logout \(error)")
                        }
                    })
                    Button("Cancel", role: .cancel, action: { })
                  }
                .foregroundColor(.red)
                .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}

struct AccountSettings_Previews: PreviewProvider {
    @State static private var userData:UserData?=UserData(userName: "User2", password: "asdasd")
    
    static var previews: some View {
        AccountSettings(userData: $userData)
    }
}
