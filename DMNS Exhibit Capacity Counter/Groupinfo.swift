//
//  queueTracker.swift
//  DMNS Exhibit Capacity Counter
//
//  Created by Lavan Vivek on 8/10/20.
//  Copyright © 2020 Lavan Vivek. All rights reserved.
//

import Foundation


class groupInfo: Codable{
    private var numPeople: Int? = nil
    private var timeTaken: Int? = nil
    private var minsFrom: Int? = nil
    private var estGsize: Int? = nil
    private var time: String? = nil
    private var timeTakenInMins: Float? = nil
    
    init(numPatrons: Int, eGroupSize: Int, timetaken: Int) {
        numPeople = numPatrons
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
        estGsize = eGroupSize
        timeTaken = timetaken
        timeTakenInMins = (Float)(timetaken)/60
    }
}
