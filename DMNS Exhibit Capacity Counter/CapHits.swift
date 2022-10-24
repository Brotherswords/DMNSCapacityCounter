//
//  CapHit.swift
//  Testing
//
//  Created by Lavan Vivek on 7/19/20.
//  Copyright © 2020 Lavan Vivek. All rights reserved.
//

import Foundation

class CapHits: Codable{
    private var eight: Int
    private var nine: Int
    private var ten: Int
    private var eleven: Int
    private var twelve: Int
    private var thirteen: Int
    private var fourteen: Int
    private var fifteen: Int
    private var sixteen: Int
    private var seventeen: Int
    private var eighteen: Int
    private var nineteen: Int
    private var twenty: Int
    private var twentyone: Int
    
    init() {
        self.eight = 0
        self.nine = 0
        self.ten = 0
        self.eleven = 0
        self.twelve = 0
        self.thirteen = 0
        self.fourteen = 0
        self.fifteen = 0
        self.sixteen = 0
        self.seventeen = 0
        self.eighteen = 0
        self.nineteen = 0
        self.twenty = 0
        self.twentyone = 0
    }
    func setEight(n: Int) -> Void{
        self.eight = n
    }
    func setNine(n: Int) -> Void{
        self.nine = n
    }
    func setTen(n: Int) -> Void{
        self.ten = n
    }
    func setEleven(n: Int) -> Void{
        self.eleven = n
    }
    func setTwelve(n: Int) -> Void{
        self.twelve = n
    }
    func setThirteen(n: Int) -> Void{
        self.thirteen = n
    }
    func setFourteen(n: Int) -> Void{
        self.fourteen = n
    }
    func setFifteen(n: Int) -> Void{
        self.fifteen = n
    }
    func setSixteen(n: Int) -> Void{
        self.sixteen = n
    }
    func getEight() -> Int{
        return eight
    }
    func getNine() -> Int{
        return nine
    }
    func getTen() -> Int{
        return ten
    }
    func getEleven() -> Int{
        return eleven
    }
    func getTwelve() -> Int{
        return twelve
    }
    func getThirteen() -> Int{
        return thirteen
    }
    func getFourteen() -> Int{
        return fourteen
    }
    func getFifteen() -> Int{
        return fifteen
    }
    func getSixteen() -> Int{
        return sixteen
    }
    func getSeventeen() -> Int{
        return seventeen
    }
    
    
    
}
