//
//  Flow.swift
//  Testing
//
//  Created by Lavan Vivek on 7/22/20.
//  Copyright © 2020 Lavan Vivek. All rights reserved.
//

import Foundation

class Flow: Codable{
    private var numPeople:Int
    private var time: String
    private var minsFrom: Int
    
    init(numPatrons: Int) {
        self.numPeople = numPatrons
        let today = Date()
        let formatter1 = DateFormatter()
        let formatterhr = DateFormatter()
        let formattermin = DateFormatter()
        formatterhr.dateFormat = "HH"
        formattermin.dateFormat = "mm"
        formatter1.dateFormat = "HH-mm"
        var tiempo = formatter1.string(from: today)
        var hr = formatterhr.string(from: today)
        var min = formattermin.string(from: today)
        var hour = Int(hr) ?? 0
        var minute = Int(min) ?? 0
        print("minute: \(min)")
        print("hour: \(hr)")
        minsFrom = (hour * 60) + minute
        time = tiempo
    }
    func getMinsFrom() -> Int {
        return minsFrom
    }
    func getNumPeople() -> Int {
        return numPeople
    }
    func getTime() -> String {
        return time
    }
    
}

