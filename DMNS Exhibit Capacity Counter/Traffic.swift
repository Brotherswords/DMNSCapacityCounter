//
//  Traffic.swift
//  Testing
//
//  Created by Lavan Vivek on 7/19/20.
//  Copyright © 2020 Lavan Vivek. All rights reserved.
//

import Foundation

class Traffic: Codable{
    private var flow: Flow

    
    init(fl: Flow) {
        self.flow = fl
    }
}

