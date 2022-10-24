//
//  Exhibit.swift
//  Testing
//
//  Created by Lavan Vivek on 7/19/20.
//  Copyright © 2020 Lavan Vivek. All rights reserved.
//

import Foundation

class Exhibit: Codable{
    private var capHits: CapHits? = nil
    private var traffic: Traffic? = nil
    private var max: Int? = nil
    private var name: String? = nil
    private var numPeople: Int? = nil
    private var numCapReach: Int? = nil
    private var total: Int? = nil
    private var queueTracker: Qtracker? = nil
    
    init(capHit:CapHits, traf: Traffic, mx:Int, nme:String, numCount:Int, numCapReach:Int, tots:Int, qTracker:Qtracker) {
        self.capHits = capHit
        self.traffic = traf
        self.max = mx
        self.name = nme
        self.numPeople = numCount
        self.total = tots
        self.numCapReach = numCapReach
        self.queueTracker = qTracker
    }
}

