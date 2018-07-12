//
//  NetworkUtilities.swift
//  Class for networking
//
//  Created by Andres Acevedo on 2017.
//  Copyright © 2017 troquer. All rights reserved.
//

import Foundation

class NetworkUtilities {
    static let sharedInstance = NetworkUtilities() //This class is a Singleton
    enum NetworkError: Error {
        case badResponse(String)
    }
    
    /// Creates a request with the parameters and headers received as dictionaries.
    ///
    /// - Parameters:
    ///   - endpoint: URL
    ///   - params: get parameters
    ///   - headers: additonal headers
    /// - Returns: request object
    func createGetRequest(endpoint:String, params:[String:String]? = nil, headers:[String:String]? = nil)->URLRequest{
        let urlComponents = NSURLComponents(string:endpoint)!
        var queryItems = [URLQueryItem]()
        if params != nil {
            for (param, paramValue) in params! {
                queryItems.append(URLQueryItem(name: param, value: paramValue))
            }
            urlComponents.queryItems = queryItems
        }
        var request = URLRequest(url: urlComponents.url!)
        if headers != nil {
            for (header, headerValue) in headers! {
                request.addValue(headerValue, forHTTPHeaderField: header)
            }
        }
        return request
    }
    
    
    /// Makes HTTP Request.
    ///
    /// - Parameters:
    ///   - endpoint: endpoint
    ///   - onSuccess: completion closure
    ///   - onError: failure closure
    /// - Returns: Void
    //@escaping (Data?, URLResponse?, Error?) ->
    func makeRequest(endPoint: URLRequest, onComplete:@escaping (Data?, URLResponse?, Error?)->Void)->Void{
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        
        let task = session.dataTask(with: endPoint, completionHandler: onComplete)
        task.resume()
    }
}
