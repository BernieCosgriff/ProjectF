//
//  Player.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import Foundation

class Player: DestructableObject {
    
    func fireBullet() -> Bullet {
        let origin = (x:self.origin.x, y: self.origin.y + radius)
        let velocity = (x: 0.0, y: 1.0)
        return Bullet(origin: origin, position: origin, velocity: velocity)
    }
}
