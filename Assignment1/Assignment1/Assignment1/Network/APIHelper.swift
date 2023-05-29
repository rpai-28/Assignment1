//
//  APIHelper.swift
//  Assignment1
//
//  Created by Reshma Pai on 28/05/23.
//

import Foundation

class APIHelper {
    
    enum APIRequestType {
        case country
    }
    
    func getApiURL(type: APIRequestType) -> URL? {
        if type == .country {
            return URL(string: Constants.helperAPI)
        }
        return nil
    }
}
