//
//  Debris.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/20/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Debris: Sprite {
    
    init(position: (x: Float, y: Float), velocity: (x: Float, y: Float), scale: (x: Float, y: Float)) {
        super.init(image: UIImage(named: "EnemyDamage")!)
        self.position = position
        self.velocity = velocity
        self.scale = scale
    }
    
    func move() {
        position.x = position.x + velocity.x
        position.y = position.y + velocity.y
    }
}
