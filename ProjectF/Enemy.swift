//
//  Enemy.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import Foundation

class Enemy: DestructableObject {
    
    var radius = 0.0
    var origin = (x: 0.0, y: 0.0)
    var position = (x: 0.0, y: 0.0)
    let velocity = 0.0
    
    init(x: Double, y: Double, radius: Double) {
        self.origin.x = x
        self.origin.y = y
        self.radius = radius
    }
    
    required init(dict: NSMutableDictionary) {
        
    }
    
    func destruct() {
        
    }
    
    func move(x: Double, y: Double) {
        
    }
    
    func toDict() -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(radius, forKey: "radius")
        dict.setValue(origin.x, forKey: "originX")
        dict.setValue(origin.y, forKey: "originY")
        dict.setValue(position.x, forKey: "positionX")
        dict.setValue(position.y, forKey: "positionY")
        dict.setValue(velocity, forKey: "velocity")
        return dict
    }
}
