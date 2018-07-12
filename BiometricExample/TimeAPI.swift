//
//  TimeAPI.swift
//  BiometricExample
//
//  Created by Andres Acevedo on 11/07/2018.
//  Copyright © 2018 Andres Acevedo. All rights reserved.
//

import Foundation
enum TimeResult {
    case success((String,String))
    case failure(String)
}

struct TimeAPI {
    //private static let baseURLString = "http://date.jsontest.com" //This server is not working right now
    private static let baseURLString = "http://www.mocky.io/v2/5b46ec543200006e00301cee"
    
    
    func parseDateTime(from data:Data)->TimeResult{
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [String:Any],
                let date = jsonDictionary["date"] as? String,
                let time = jsonDictionary["time"] as? String
                else {
                    return .failure("Invalid JSON data")
            }
            return .success((date,time))
        } catch let error {
            return .failure("Error trying to convert data to JSON - " + error.localizedDescription)
        }
        
    }
    
    func getDateTime(onComplete: @escaping (TimeResult)->Void){
        let request = NetworkUtilities.sharedInstance.createGetRequest(endpoint: TimeAPI.baseURLString)
        NetworkUtilities.sharedInstance.makeRequest(endPoint: request){
            (data, response, error) in
            
            guard error == nil else {
                return onComplete(.failure(error!.localizedDescription))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                
                if (statusCode != 200) {
                    return onComplete(.failure("Failed with code status: \(statusCode)"))
                }
            }
            
            if let data = data {
               return onComplete(self.parseDateTime(from: data))
            }
        }
    }
}
