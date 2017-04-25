//
//  Score.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/22/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Score {
    
    private var numbers1 = [Number]()
    private var numbers2 = [Number]()
    private var tens: Number?
    private var ones: Number?
    private var intScore = 0
    private let position1: (x: Float, y: Float) = (x: 0.83, y: 0.88)
    private let position2: (x: Float, y: Float) = (x: 0.93, y: 0.88)
    
    init() {
        for i in 0..<10 {
            numbers1.append(Number(number: i))
            numbers2.append(Number(number: i))
        }
        tens = numbers1[0]
        ones = numbers2[0]
        tens?.position = position1
        ones?.position = position2
    }
    
    var score: Int {
        get {
            return intScore
        }
        set {
            if(newValue >= 0) {
                intScore = newValue
                let first = newValue / 10
                let second = newValue % 10
                tens = numbers1[first]
                ones = numbers2[second]
                tens?.position = position1
                ones?.position = position2
            }
        }
    }
    
    func draw() {
        ones?.draw()
        tens?.draw()
    }
    
}
