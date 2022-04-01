//
//  UserData.swift
//  simple monitoring
//
//  Created by Ivan Novobranets on 31.03.2022.
//

import Foundation

struct UserData{
    enum UserDataError: Error{
        case accountNotFound
        case unexceptedError
    }
    
    var userName:String = ""
    var password:String = ""
    
    static func loadFromDevice() throws -> UserData {
        let defaults=UserDefaults.standard
        let keychain=KeyChain()
        var userData=UserData()
        
        guard let account = defaults.string(forKey: "account") else {
            throw UserDataError.accountNotFound
        }
        userData.userName=account
        
        do {
            try userData.password=keychain.getItem(account: account)
        } catch KeyChain.KeychainError.itemNotFound {
            throw UserDataError.accountNotFound
        } catch {
            throw UserDataError.unexceptedError
        }
        
        return userData
    }
    static func saveToDevice(newUserData:UserData) throws -> Void {
        let defaults=UserDefaults.standard
        let keychain=KeyChain()
        
        defaults.set(newUserData.userName,forKey: "account")
        do {
            try keychain.addItem(account: newUserData.userName, password: newUserData.password)
        } catch KeyChain.KeychainError.duplicateItem {
            do{
                try keychain.delItem(account: newUserData.userName)
                try keychain.addItem(account: newUserData.userName, password: newUserData.password)
            } catch {
                throw UserDataError.unexceptedError
            }
        } catch {
            throw UserDataError.unexceptedError
        }
    }
    static func deleteFromDevice(oldUserData:UserData) throws -> Void {
        let defaults=UserDefaults.standard
        let keychain=KeyChain()
        
        defaults.removeObject(forKey: "account")
        do {
            try keychain.delItem(account: oldUserData.userName)
        } catch {
            throw UserDataError.unexceptedError
        }
    }

}
