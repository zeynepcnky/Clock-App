//
//  Item.swift
//  ClockDemo
//
//  Created by Zeynep Cankaya on 6.01.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
