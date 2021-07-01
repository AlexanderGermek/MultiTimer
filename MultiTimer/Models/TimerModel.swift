//
//  TimerModel.swift
//  MultiTimer
//
//  Created by iMac on 01.07.2021.
//

import Foundation

struct TimerModel {
    var name: String
    var timeInSeconds: Int
    var creationDate: Date
    
    var endDate: Date {
        get {
            return creationDate.addingTimeInterval(TimeInterval(timeInSeconds))
        }
    }
    
    var timeLeft: Int {
        get {
            return  Calendar.current.dateComponents(
                [.second], from: Date(), to: endDate).second!
        }
    }
    
    var timeLeftString: String {
        get {
            let t = timeLeft
            let hours = Int(t) / 3600
            let minutes = Int(t) / 60 % 60
            let seconds = Int(t) % 60
            
            var times: [String] = []
            if hours > 0 {
                if hours < 10 {
                    times.append("0\(hours)")
                } else {
                    times.append("\(hours)")
                }
            }
 
            if minutes > 0 {
                
                if minutes < 10 {
                    times.append("0\(minutes)")
                } else {
                    times.append("\(minutes)")
                }
            }
  
            if !times.isEmpty && seconds < 10  {
                times.append("0\(seconds)")
            }else {
            times.append("\(seconds)")
            }
            
            return times.joined(separator: ":")
        }
    }
}
