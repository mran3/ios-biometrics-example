//
//  FormatUtilities.swift
//  BiometricExample
//
//  Created by Andres Acevedo on 12/07/2018.
//  Copyright © 2018 Andres Acevedo. All rights reserved.

import Foundation
class FormatUtilities {
    static func toCurrentTimeZone(date:String, format:String, fromTimeZone: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: fromTimeZone)
        guard
            let dt = dateFormatter.date(from: date)
            else {
                return "Invalid Date"
        }
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: dt)
    }

}

//func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = fromFormat
//    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//
//    let dt = dateFormatter.date(from: date)
//    dateFormatter.timeZone = TimeZone.current
//    dateFormatter.dateFormat = toFormat
//
//    return dateFormatter.string(from: dt!)
//}

//let localDateAsString = UTCToLocal(date: dateAsString!, fromFormat: "hh:mm a, dd MMM yyyy", toFormat: "hh:mm a, dd MMM yyyy"
