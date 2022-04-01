//
//  LoginWindow.swift
//  simple monitoring
//
//  Created by Ivan Novobranets on 31.03.2022.
//

import SwiftUI

struct LoginWindow: View {
    @Binding public var userData:UserData?
    @State private var account:String=""
    @State private var password:String=""
    
    var body: some View {
        VStack{
            Text("Login")
            Form {
                TextField(text: $account, prompt: Text("Login")) {
                    Text("Username")
                }
                .padding()
                SecureField(text: $password, prompt: Text("Password")) {
                    Text("Password")
                }
                .padding()
                Button("Login"){
                    print("Login clk \(account) \(password)")
                    do{
                        try UserData.saveToDevice(newUserData: UserData(userName: account, password: password))
                        userData=UserData(userName: account, password: password)
                    } catch {
                        print("Error save userData \(error)")
                    }
                }
                .frame(minWidth:0,maxWidth: .infinity)
                .padding()
            }
        }
    }
}

struct LoginWindow_Previews: PreviewProvider {
    @State static var userData:UserData?
    
    static var previews: some View {
        LoginWindow(userData: $userData)
    }
}
