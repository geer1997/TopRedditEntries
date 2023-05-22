//
//  EntriesEndpoints.swift
//  TopRedditEntries
//
//  Created by Germano Rojas on 21/5/23.
//

import Foundation
import Alamofire

enum EntriesEndpoints {
    case getTopEntries(count: String, after: String)
}

extension EntriesEndpoints: EndpointType {
    var url: String {
        switch self {
        case .getTopEntries(let count, let after):
            return "top.json?count=\(count)&after=\(after)"
        }
    }
    
    var method: HTTPMethod {
        switch self{
        case .getTopEntries:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getTopEntries:
            return nil
        }
    }
    
    var header: HTTPHeaders? {
        switch self {
        case .getTopEntries:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
