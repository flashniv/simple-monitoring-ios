//
//  Server.swift
//  simple monitoring
//
//  Created by Ivan Novobranets on 01.04.2022.
//

import Foundation

class Server{
    enum ServerError: Error{
        case urlError
        case unexceptedError
    }
    
    static private var serverURL:String="https://simple.flash.biz.ua/apiv1"
    
    static private func buildAuthString(userData:UserData) throws -> String {
        let loginString = "\(userData.userName):\(userData.password)"
        
        guard let loginData = loginString.data(using: .utf8) else {
            throw ServerError.unexceptedError
        }
        let encoded = loginData.base64EncodedString()
        
        return "Basic \(encoded)"
    }

    static public func get(userData:UserData,url:String,hook: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> Void {
        var basicAuth:String
        guard let url = URL(string: serverURL+url) else {
            throw ServerError.urlError
        }
        do {
            try basicAuth = buildAuthString(userData: userData)
        } catch {
            throw ServerError.unexceptedError
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(basicAuth, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request,completionHandler: hook).resume()
    }
    
}
