//
//  qTracker.swift
//  DMNS Exhibit Capacity Counter
//
//  Created by Lavan Vivek on 8/10/20.
//  Copyright © 2020 Lavan Vivek. All rights reserved.
//

import Foundation

class Qtracker: Codable{
    private var groupinit: groupInfo

    
    init(gr: groupInfo) {
        self.groupinit = gr
    }
}
