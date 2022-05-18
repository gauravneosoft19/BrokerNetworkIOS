//
//  API.swift
//  BrokerNetworkIOS
//
//  Created by Gaurav on 17/05/22.
//

import Foundation

enum API {
    case getAllCards
}

extension API {
    
    enum Environment {
        case developement
        case production
    }
    
    fileprivate var environment: Environment {
        return .developement
    }
    
    fileprivate var baseURL: String {
        var baseurl = ""
        switch environment {
        case .developement:
            baseurl = "https://run.mocky.io/"
        case .production:
            //Change URL as per requirement
            baseurl = "https://run.mocky.io/"
        }
        return baseurl
    }
    
    fileprivate var apiVersion: String {
        return "v3/"
    }
    
    public var url : String {
        var serviceURL = ""
        var path = ""
        
        switch self {
        case .getAllCards:
            path = Constants.getEndPoint(api: self)
        }
        serviceURL = baseURL + apiVersion + path
        return serviceURL
    }
    
    
    var method: String {
        switch self {
        case .getAllCards:
            return HTTPMethod.GET.rawValue
        }
    }
}
