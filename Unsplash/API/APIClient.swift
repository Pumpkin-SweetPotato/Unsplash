//
//  APIClient.swift
//  PokemonLibrary
//
//  Created by Minsoo Kim on 2020/11/13.
//

import Foundation

class APIClient {
//    let shared: APIClient = APIClient()
//
//    init() {}
    
    let session: URLSession = URLSession.shared
    typealias APISearchResult = (Data?, URLResponse?, Error?)
    typealias APICompletionHandler = ((Data?, URLResponse?, Error?) -> Void)

    func makeRequest(apiRouter: APIRouter, completionHandler: @escaping APICompletionHandler) -> URLSessionDataTask? {
        guard let url = apiRouter.asURL else { return nil }
        return session.dataTask(with: url, completionHandler: completionHandler)
    }
   
    @discardableResult
    func reqeust<T: Codable>(_ type: T.Type, apiRouter: APIRouter, completionHandler: @escaping (Result<T, Error>) -> Void) -> URLSessionTask? {
        let request = makeRequest(apiRouter: apiRouter) { (data, response, requestError) in
            if let requestError = requestError {
                completionHandler(.failure(requestError))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                print("response \(String(describing: response))")
                completionHandler(.failure(NSError(domain: "Response is invalid", code: 404, userInfo: nil)))
                return
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                completionHandler(.failure(NSError(domain: "Status code is invalid", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
                       
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                let jsonObject = try jsonDecoder.decode(T.self, from: data)
                
                switch apiRouter {
                case .getPhoto:
                    if let links = httpResponse.allHeaderFields["Link"] as? String {
                        if !links.contains("next"), var response = jsonObject as? PaginationResponse {
                            response.isLastPage = true
                            completionHandler(.success(response as! T))
                        }
                    }
                default:
                    break;
                }
                
                completionHandler(.success(jsonObject))
            } catch let error as DecodingError {
                switch error {
                case let .typeMismatch(type, errorContext):
                    print("Type '\(type)' mismatch:", errorContext.debugDescription)
                    print("CodingPath:", errorContext.codingPath)
                    
                case let .keyNotFound(key, errorContext):
                    print("'\(key)' not found:", errorContext.debugDescription)
                    print("CodingPath:", errorContext.codingPath)
                    
                case let .valueNotFound(value, errorContext):
                    print("'\(value)' not found:", errorContext.debugDescription)
                    print("CodingPath:", errorContext.codingPath)
                    
                case .dataCorrupted(let key):
                    print("Data corrupted \(key)")
                    
                @unknown default:
                    print("Decoding Error \(error.localizedDescription)")
                }
                completionHandler(.failure(error))
            } catch let unknownError {
                completionHandler(.failure(unknownError))
            }
        }
       
        request?.resume()
        
        return request
    }
}

extension DateFormatter {
    
}
