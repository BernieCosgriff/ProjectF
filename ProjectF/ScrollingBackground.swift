//
//  ScrollingBackground.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/24/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class ScrollingBackground {
    
    let b1: Background
    let b2: Background
    
    init (level: Int) {
        b1 = Background(image: UIImage(named: "Background1")!, position: (x: 0, y: 0), velocity: (x: 0, y: -0.01))
        b2 = Background(image: UIImage(named: "Background1")!, position: (x: 0, y: 2.0), velocity: (x: 0, y: -0.01))
        if level == 1 {
            
        }
    }
    
    func move() {
        b1.move()
        if b1.position.y <= -2.0 {
            b1.position.y = 2.0
        }
        b2.move()
        if b2.position.y <= -2.0 {
            b2.position.y = 2.0
        }
    }
    
    func draw() {
        b1.draw()
        b2.draw()
    }
    
}
