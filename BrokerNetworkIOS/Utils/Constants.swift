//
//  Constants.swift
//  BrokerNetworkIOS
//
//  Created by Neosoft on 17/05/22.
//

import Foundation

struct Constants {
    static let optionsTapped = "Options Tapped "
    static let callTapped = "Call Tapped "
    static let sendMessageTapped = "Send Message Tapped "
    static let closeTapped = "Close Tapped "
    static let refresh = "Refresh"
    static let noDataFound = "No Data Found"
    static let noInternet = "No Internet"
    static let writeMessage = "Write Message"
    
    //MARK: NIB Names
    struct NibNames {
        static let cardTableViewCell = "CardTableViewCell"
        static let cardCollectionViewCell = "CardCollectionViewCell"
    }
    
    //MARK: CellIdentifiers
    struct CellIdentifiers {
        static let kTableCardCellIdentifier = "TableCardCellIdentifier"
        static let kCollectionCardCellIdentifier = "CardCollectionViewCell"
    }
    
    //MARK: Network
    struct Network {
        static let baseDevUrl = "https://run.mocky.io/"
        static let baseProductionUrl = "https://run.mocky.io/"
    }
    
    static func getEndPoint(api: API) -> String {
        switch api {
        case .getAllCards:
            return "c52cf4ce-a639-42d7-a606-2c0a8b848536"
        }
    }
}
