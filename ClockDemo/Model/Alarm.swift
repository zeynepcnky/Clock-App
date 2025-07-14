
//
//  AlarmModel.swift
//  ClockDemo
//
//  Created by Zeynep Cankaya on 7.02.2025.
//
import Foundation

struct Alarm : Identifiable, Codable{
    var id = UUID()
    var time: String
    var label: String
    var repeatDay: String?
    var isEnabled : Bool 
    
}
