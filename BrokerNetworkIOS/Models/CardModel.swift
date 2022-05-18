//
//  CardModel.swift
//  BrokerNetworkIOS
//
//  Created by Gaurav on 17/05/22.
//

import Foundation

// MARK: - CardModel
struct CardModel: Codable {
    var cards: [Card]?
}

// MARK: - Card
struct Card: Codable {
    var data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    var totalMatchesCount: Int?
    var mainPost: MainPost?
    var horizontalCards: [HorizontalCard]?

    enum CodingKeys: String, CodingKey {
        case totalMatchesCount = "total_matches_count"
        case mainPost = "main_post"
        case horizontalCards = "horizontal_cards"
    }
}

// MARK: - HorizontalCard
struct HorizontalCard: Codable {
    var uuid: String?
    var type: TypeClass?
    var title: String?
    var subInfo: [HorizontalCardSubInfo]?
    var price: Int?
    var postUUID, info: String?
    var assignedTo: AssignedTo?
    var updationTime, rentExpected: Int?

    enum CodingKeys: String, CodingKey {
        case uuid, type, title
        case subInfo = "sub_info"
        case price
        case postUUID = "post_uuid"
        case info
        case assignedTo = "assigned_to"
        case updationTime = "updation_time"
        case rentExpected = "rent_expected"
    }
}

// MARK: - AssignedTo
struct AssignedTo: Codable {
    var uuid: String?
    var profilePicURL: String?
    var phoneNumber, orgName, name: String?

    enum CodingKeys: String, CodingKey {
        case uuid
        case profilePicURL = "profile_pic_url"
        case phoneNumber = "phone_number"
        case orgName = "org_name"
        case name
    }
}

// MARK: - HorizontalCardSubInfo
struct HorizontalCardSubInfo: Codable {
    var text: String?
    var perfectMatch: Bool?

    enum CodingKeys: String, CodingKey {
        case text
        case perfectMatch = "perfect_match"
    }
}

// MARK: - TypeClass
struct TypeClass: Codable {
    var name, id: String?
}

// MARK: - MainPost
struct MainPost: Codable {
    var uuid: String?
    var type: TypeClass?
    var title: String?
    var subInfo: [MainPostSubInfo]?
    var postUUID: String?
    var maxBudget, matchCount: Int?
    var info: String?
    var assignedTo: AssignedTo?
    var maxRent: Int?

    enum CodingKeys: String, CodingKey {
        case uuid, type, title
        case subInfo = "sub_info"
        case postUUID = "post_uuid"
        case maxBudget = "max_budget"
        case matchCount = "match_count"
        case info
        case assignedTo = "assigned_to"
        case maxRent = "max_rent"
    }
}

// MARK: - MainPostSubInfo
struct MainPostSubInfo: Codable {
    var text: String?
}
