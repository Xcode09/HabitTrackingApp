//
//  Local.swift
//  Car Pool
//
//  Created by Muhammad Ali on 22/10/2021.
//

import Foundation
struct UserState {
    static func saveUserLogin(user:User){
        //
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            UserDefaults.standard.setValue(true, forKey: "login")
            defaults.set(encoded, forKey: "SavedPerson")
            UserDefaults.standard.synchronize()
        }
    }
    static func isUserPickACar(){
        UserDefaults.standard.setValue(true, forKey: "carPick")
        UserDefaults.standard.synchronize()
    }
    static func getUserState()->Bool{
        if let user = UserDefaults.standard.value(forKey: "login") as? Bool{
            if let savedPerson = UserDefaults.standard.object(forKey: "SavedPerson") as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                    golbalUser = loadedPerson
                    return user
                }else{
                    return false
                }
            }else{
                return false
            }
        }else{
            return false
        }
    }
    static func getUserCar()->Bool{
        if let user = UserDefaults.standard.value(forKey: "carPick") as? Bool{
            return user
        }else{
            return false
        }
    }
    
    static func settimeReminder(date:Date){
        UserDefaults.standard.removeObject(forKey: "setTimeReminder")
        UserDefaults.standard.setValue(date, forKey: "setTimeReminder")
        UserDefaults.standard.synchronize()
    }
    
    static func gettimeReminder()->Date?{
       
        if let date = UserDefaults.standard.value(forKey: "setTimeReminder") as? Date{
            return date
        }else{
            return nil
        }
     
    }
}
