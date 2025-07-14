//
//  City.swift
//  ClockDemo
//
//  Created by Zeynep Cankaya on 15.01.2025.
//

import Foundation

struct City: Identifiable {
    let id  = UUID()
    let cityname: String
    let timeZone: TimeZone
    var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = timeZone
        return formatter.string(from: Date())
    }
    
    func timeDifference(from userTimeZone: TimeZone) -> String {
        let userOffset = userTimeZone.secondsFromGMT()
        let cityOffset = timeZone.secondsFromGMT()
        let hoursFromUTC = (cityOffset - userOffset) / 3600
        
        if hoursFromUTC == 0 {
            return "Today, +0HRS"
        } else if hoursFromUTC > 0 {
            return " Today, +\(hoursFromUTC)HRS"
        }else {
            return " Today, \(hoursFromUTC)HRS"
        }
        
    }
}

let cityList = [
    City(cityname: "New York", timeZone: TimeZone(identifier: "America/New_York")!),
    City(cityname: "Tokyo", timeZone: TimeZone(identifier: "Asia/Tokyo")!),
    City(cityname: "London", timeZone: TimeZone(identifier:"Europe/London")!),
    City(cityname: "Berlin", timeZone: TimeZone(identifier: "Europe/Berlin")!),
    City(cityname: "Moscow", timeZone: TimeZone(identifier: "Europe/Moscow")!),
    City(cityname: "Madrid", timeZone: TimeZone(identifier: "Europe/Madrid")!),
    City(cityname: "Istanbul", timeZone: TimeZone(identifier: "Asia/Istanbul")!)
]
