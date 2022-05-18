//
//  APIService.swift
//  BrokerNetworkIOS
//
//  Created by Gaurav on 17/05/22.
//

import Foundation
class APIService {
    
    static func callService<T: Codable>(service: API, appendingPara: String = "", jsonBody: [String:Any] = ["" : ""], completionHandler: @escaping (Swift.Result<T,CustomError>) -> () ){
        
        var url = service.url
        
        if !appendingPara.isEmpty {
            url = url + appendingPara
        }
        
        guard let urls = URL(string: url) else { return }
        
        var urlRequest = URLRequest(url: urls)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody)
        
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        urlRequest.httpMethod = service.method
        
        let method = HTTPMethod(rawValue: urlRequest.httpMethod ?? "GET") ?? .GET
        
        switch method {
        case .GET:
            print("Get method")
        case .PUT, .POST, .DELETE:
            urlRequest.httpBody = jsonData
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error == nil{
                do {
                    guard let data = data else { return }
                                        
                    let object = try JSONDecoder().decode(T.self, from: data)
                    
                    completionHandler(.success(object))
                    
                    return
                    
                } catch (let exception) {
                    completionHandler(.failure(CustomError.serviceError(exception.localizedDescription)))
                    return
                }
            } else {
                completionHandler(.failure(CustomError.serviceError(error?.localizedDescription ?? "")))
                return
            }
        }.resume()
    }
}


public enum CustomError: Error {
    case serviceError(String)
    case apiError(String)
    case tokenExpire(String)
    case successMsg(String)
    case cancel(String)
    case noInternetError(String)
    
    var getErrorMsg: String {
        switch self {
        case .serviceError(let error):
            return error
        case .apiError(let error):
            return error
        case .tokenExpire(let error):
            return error
        case .successMsg(let msg):
            return msg
        case .cancel(let msg):
            return msg
        case .noInternetError(let msg):
            return msg
        }
    }
}
