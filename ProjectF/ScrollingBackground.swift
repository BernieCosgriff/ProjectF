//
//  ScrollingBackground.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/24/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class ScrollingBackground {
    
    var b1: Background
    var b2: Background
    var transitionString = ""
    var counter = 3
    var levelUpHandler: (() -> Void)?
    let backgroundVelocity: (x: Float, y: Float) = (x: 0, y: -0.05)
    
    init (level: Int) {
        b1 = Background(image: UIImage(named: "Background\(level)")!, position: (x: 0, y: 0), velocity: backgroundVelocity)
        b2 = Background(image: UIImage(named: "Background\(level)")!, position: (x: 0, y: 2.0), velocity: backgroundVelocity)
    }
    
    func setBackground(level: Int) {
        transitionString = "Background\(level)"
        counter = 0
    }
    
    func move() {
        if counter == 2 {
            levelUpHandler?()
            counter += 1
        }
        b1.move()
        if b1.position.y <= -2.0 {
            if counter < 2 {
                b1 = Background(image: UIImage(named: transitionString)!, position: (x: 0, y: 2.0), velocity: backgroundVelocity)
                counter += 1
            } else {
                b1.position.y = 2.0
            }
        }
        b2.move()
        if b2.position.y <= -2.0 {
            if counter < 2 {
                b2 = Background(image: UIImage(named: transitionString)!, position: (x: 0, y: 2.0), velocity: backgroundVelocity)
                counter += 1
            } else {
                b2.position.y = 2.0
            }
        }
    }
    
    func draw() {
        b1.draw()
        b2.draw()
    }
    
}
