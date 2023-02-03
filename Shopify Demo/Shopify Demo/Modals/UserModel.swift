//
//  UserModel.swift
//  Shopify Demo
//
//  Created by MacBook on 30/11/2021.
//  Copyright © 2021 Intempt. All rights reserved.
//

import Foundation
let savedUser  = "SavedUser"
let savedAllUsers  = "savedAllUsers"
let savedAllAddresses  = "savedAllAddresses"

class UserModel: Codable {
    var email:String?
    var fname:String?
    var lname:String?
    var phone:String?
    var password:String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case fname
        case lname
        case phone
        case password
        
    }
    init() {
        
    }
    
}
class UserSession {
    static func saveUser(user: UserModel){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: savedUser)
            defaults.synchronize()
            
        }
    }
    
    static func getUser() -> UserModel?{
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: savedUser) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserModel.self, from: savedPerson) {
                return loadedPerson
            }
        }
        return nil
    }
    static func logoutUser(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: savedUser)
        defaults.synchronize()
    }
    static func saveNewUser(user: [UserModel]){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: savedAllUsers)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getAllUsers() -> [UserModel]{
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: savedAllUsers) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode([UserModel].self, from: savedPerson) {
                return loadedPerson
            }
        }
        return [UserModel]()
    }
    
    static func saveNewAdress(obj: [AddressModel]){
        let key = UserSession.getUser()?.email ?? "address"
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(obj) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getAllAddresses() -> [AddressModel]{
        
        let key = UserSession.getUser()?.email ?? "address"
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let list = try? decoder.decode([AddressModel].self, from: savedData) {
                return list
            }
        }
        return [AddressModel]()
    }
}

class AddressModel: Codable {
    var street:String?
    var house:String?
    var city:String?
    var state:String?
    var zipcode:String?
    
    enum CodingKeys: String, CodingKey {
        case street
        case house
        case city
        case state
        case zipcode
        
    }
    init() {
        
    }
    
}
