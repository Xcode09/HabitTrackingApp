//
//  GeneralModel.swift
//  HabitTrackingApp
//
//  Created by Muhammad Ali on 02/11/2021.
//

import Foundation
struct ErrorModel:Codable{
    let code:Int?
    let message:String?
}
struct SuccessModel:Codable{
    let response:String?
    let message:String?
}

struct HabitLogModel:Codable{
    let response:String?
    let result:[HabitLog]?
}

struct HabitLog:Codable,Hashable{
    let user_id:String?
    let tool_used:String?
    let other_things:String?
    let urge:String?
    let bite:String?
    let feeling:String?
    let activity:String?
    let created_at:String?
    let updated_at:String?
}


struct TrackModel:Codable{
    let response:String?
    let result:[Track]?
}

struct UserModel:Codable {
    let response:String?
    let result:[User]?
}
struct User:Codable {
    let id : Int?
    let name:String?
    let email:String?
}

struct TrackCounter:Codable{
    let response:String?
    let nail_bite_counter:Int?
    let tool_used_counter:Int?
    let pro_times:String?
}


struct Track:Codable,Hashable{
    let id, nailBiteCounter, toolUsedCounter, day: String?
        let userID, planID, recordDate, createdAt: String?
        let updatedAt: String?

        enum CodingKeys: String, CodingKey {
            case id
            case nailBiteCounter = "nail_bite_counter"
            case toolUsedCounter = "tool_used_counter"
            case day
            case userID = "user_id"
            case planID = "plan_id"
            case recordDate = "record_date"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
}



struct PlanModel: Codable {
    let response: String?
    let result: [Plan]?
}

// MARK: - Result
struct Plan: Codable {
    let id, focus, product1, product2: String?
    let helpMe, userID: String?
    let resultWhere: String?
    let startDate, endDate, eventTime, tryProduct: String?
    let pTotalTimes, pLocation: String?
    let reminderTime, reminderDetail: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, focus
        case product1 = "product_1"
        case product2 = "product_2"
        case helpMe = "help_me"
        case userID = "user_id"
        case resultWhere = "where"
        case startDate = "start_date"
        case endDate = "end_date"
        case eventTime = "event_time"
        case tryProduct = "try_product"
        case pTotalTimes = "p_total_times"
        case pLocation = "p_location"
        case reminderTime = "reminder_time"
        case reminderDetail = "reminder_detail"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
