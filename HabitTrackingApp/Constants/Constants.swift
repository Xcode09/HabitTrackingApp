//
//  Constants.swift
//  Car Pool
//
//  Created by Muhammad Ali on 22/10/2021.
//

import UIKit

var golbalUser : User!
var currentPlan:Plan?
struct ApiEndPoints{
    private let baseURL = "http://codexit.xyz/api/" //"http://api.bilkoll.com/api/"
    static let signup = "\(ApiEndPoints().baseURL)signup"
    static let login = "\(ApiEndPoints().baseURL)login"
    static let habitLog = "\(ApiEndPoints().baseURL)habit_log"
    static let addLog = "\(ApiEndPoints().baseURL)addlog"
    static let addPlan = "\(ApiEndPoints().baseURL)addPlan"
    static let getPlans = "\(ApiEndPoints().baseURL)getPlans"
    static let getTracks = "\(ApiEndPoints().baseURL)getTracks"
    
    static let getCounter = "\(ApiEndPoints().baseURL)getcounter"
    static let updateTrack = "\(ApiEndPoints().baseURL)updateTrack"
    
    static let addTrack = "\(ApiEndPoints().baseURL)addTrack"
    static let planstatus = "\(ApiEndPoints().baseURL)planstatus"
    static let fetchCarUsedByUser = "\(ApiEndPoints().baseURL)get_my_plan_Tracks"
    static let leaveCarUsedByUser = "\(ApiEndPoints().baseURL)updateTrack"
}

extension UIColor{
    static let bgColor = UIColor(named: "BG")
    static let labelColor = UIColor(named: "LabelColor")
    static let s2 = UIColor(named: "S2")
    static let s3 = UIColor(named: "S3")
    static let s4 = UIColor(named: "S4")
}
extension Notification.Name{
    static let update = Notification.Name(rawValue: "update")
}
