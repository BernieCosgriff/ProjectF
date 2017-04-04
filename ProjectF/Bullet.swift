//
//  Bullet.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import Foundation

class Bullet: DestructableObject {
    
    init(origin: (x: Double, y: Double), position: (x: Double, y: Double), velocity: (x: Double, y: Double)) {
        super.init(origin: origin, position: position, radius: 1.0, velocity: velocity)
    }
    
}
