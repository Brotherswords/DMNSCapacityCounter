//
//  TheDay.swift
//  Testing
//
//  Created by Lavan Vivek on 7/23/20.
//  Copyright © 2020 Lavan Vivek. All rights reserved.
//

import Foundation

class TheDay: Codable{
    private var theExhibit: Exhibit
    private var date: String
    
    init(capHit:CapHits, traf: Traffic, mx:Int, nme:String, numCount:Int, numCapReach:Int, tots:Int, qTracker: Qtracker) {
        self.theExhibit = Exhibit(capHit: capHit, traf: traf,mx: mx, nme: nme, numCount: numCount, numCapReach: numCapReach, tots: tots, qTracker: qTracker)
        var formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        let today = Date()
        var tiempo = formatter1.string(from: today)
        date = tiempo
    }
    
    func getDate() -> String {
        return date
    }
    func getExhibit() -> Exhibit {
        return theExhibit
    }
    func setExhibit(exh: Exhibit) -> Void{
        self.theExhibit = exh
    }
    func setDate(dte:String) -> Void {
        self.date = dte
    }
    
}

