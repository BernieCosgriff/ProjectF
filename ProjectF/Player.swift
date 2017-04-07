//
//  Player.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import Foundation

class Player: DestructableObject {
    
    //MARK: - Member Variables
    var radius = 0.0
    var origin = (x: 0.0, y: 0.0)
    var position = (x: 0.0, y: 0.0)
    var velocity = (x: 0.0, y: 0.0)
    let bulletVelocity = (x: 0.0, y: 1.0)
    
    //MARK: - Initializers
    init(origin: (x: Double, y: Double), position: (x: Double, y: Double), radius: Double, velocity: (x: Double, y: Double)) {
        self.origin = origin
        self.position = position
        self.radius = radius
        self.velocity = velocity
    }
    
    required init(dict: NSMutableDictionary) {
        origin = (x: dict.value(forKey: GameModel.ORIGIN_X) as! Double, y: dict.value(forKey: GameModel.ORIGIN_Y) as! Double)
        position = (x: dict.value(forKey: GameModel.POSITION_X) as! Double, y: dict.value(forKey: GameModel.POSITION_Y) as! Double)
        radius = dict.value(forKey: GameModel.RADIUS) as! Double
        velocity = (x: dict.value(forKey: GameModel.VELOCITY_X) as! Double, y: dict.value(forKey: GameModel.VELOCITY_Y) as! Double)
    }
    
    //MARK: - Actions
    func fireBullet() -> Bullet {
        let origin = (x:self.origin.x, y: self.origin.y + radius)
        return Bullet(origin: origin, position: origin, velocity: bulletVelocity)
    }
    
    func destruct() {
        
    }
    
    func move() {
        position.x = position.x + velocity.x
        position.y = position.y + velocity.y
    }
    
    //MARK: - Saving
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
