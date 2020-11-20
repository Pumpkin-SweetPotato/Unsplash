//
//  APIRouter.swift
//  PokemonLibrary
//
//  Created by Minsoo Kim on 2020/11/13.
//

import Foundation

enum OrderBy: String {
    case relevant
    case latest
    case popular
}

enum APIRouter {
    case getPhoto(page: Int = 1, perPage: Int = 10, orderBy: OrderBy = .latest)
    case searchPhoto(keyword: String, page: Int = 1, perPage: Int = 10, orderBy: OrderBy = .relevant)
    
    var host: String {
        APIConstants.baseURL
    }
    
    var queryItems: [URLQueryItem] {
        var _queryItems: [URLQueryItem] = []
        switch self {
        case let .getPhoto(page, perPage, orderBy):
            _queryItems.append(.init(name: "page", value: String(page)))
            
            _queryItems.append(.init(name: "per_page", value: String(perPage)))
            _queryItems.append(.init(name: "order_by", value: orderBy.rawValue))
            
            _queryItems.append(.init(name: "client_id", value: clientKey))
        case let .searchPhoto(keyword, page, perPage, orderBy):
            _queryItems.append(.init(name: "query", value: keyword))
            _queryItems.append(.init(name: "page", value: String(page)))
            
            _queryItems.append(.init(name: "per_page", value: String(perPage)))
            _queryItems.append(.init(name: "order_by", value: orderBy.rawValue))
            _queryItems.append(.init(name: "client_id", value: clientKey))
        }
        
        return _queryItems
    }
    
    var clientKey: String {
        "cmEl0LL8LSMnvjLQiLgc-pEe_Mabz6RAMb9qIegA_hY"
    }
    
    var authorization: [String: String] {
        return ["Authorization": clientKey]
    }
    
    var path: String {
        switch self {
        case .getPhoto:
            return "/photos/"
        case .searchPhoto:
            return "/search/photos"
        }
    }
    
    var method: String {
        switch self {
        case .getPhoto:
            return "get"
        case .searchPhoto:
            return "get"
        }
    }

    var asURL: URL? {
        var urlComponents: URLComponents = .init()
        
        urlComponents.scheme = "https"
        urlComponents.host = self.host
        urlComponents.path = self.path
        urlComponents.queryItems = self.queryItems
        
        return urlComponents.url
    }
    
}
