//
//  TypeClass.swift
//  BrokerNetworkIOS
//
//  Created by Neosoft on 18/05/22.
//

import Foundation
import UIKit
enum TypeClassEnum: String {
    case Resale
    case Rent
    
    func getTypeColor() -> UIColor {
        switch self {
        case .Resale:
            return UIColor(red: 199 / 255, green: 89 / 255, blue: 80 / 255, alpha: 1)
        case .Rent:
            return UIColor(red: 31 / 255, green: 97 / 255, blue: 234 / 255 , alpha: 1)
        }
    }
}
