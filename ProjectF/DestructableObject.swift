//
//  DestructableObject.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/3/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import Foundation

class DestructableObject {
    
    var radius = 0.0
    var origin = (x: 0.0, y: 0.0)
    var position = (x: 0.0, y: 0.0)
    var velocity = (x: 0.0, y: 0.0)
    
    init(origin: (x: Double, y: Double), position: (x: Double, y: Double), radius: Double, velocity: (x: Double, y: Double)) {
        self.origin = origin
        self.position = position
        self.radius = radius
        self.velocity = velocity
    }
    
    init(dict: NSMutableDictionary) {
        origin = (x: dict.value(forKey: GameModel.ORIGIN_X) as! Double, y: dict.value(forKey: GameModel.ORIGIN_Y) as! Double)
        position = (x: dict.value(forKey: GameModel.POSITION_X) as! Double, y: dict.value(forKey: GameModel.POSITION_Y) as! Double)
        radius = dict.value(forKey: GameModel.RADIUS) as! Double
    }
    
    func destruct() {
        
    }
    
    func move(x: Double, y: Double) {
        
    }
    
    func toDict() -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(radius, forKey: GameModel.RADIUS)
        dict.setValue(origin.x, forKey: GameModel.ORIGIN_X)
        dict.setValue(origin.y, forKey: GameModel.ORIGIN_Y)
        dict.setValue(position.x, forKey: GameModel.POSITION_X)
        dict.setValue(position.y, forKey: GameModel.POSITION_Y)
        dict.setValue(velocity.x, forKey: GameModel.VELOCITY_X)
        dict.setValue(velocity.y, forKey: GameModel.VELOCITY_Y)
        return dict
    }
}
