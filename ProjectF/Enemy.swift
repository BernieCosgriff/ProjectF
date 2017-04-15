//
//  Enemy.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Enemy: Sprite {
    
    //MARK: - Initializers
    init(position: (x: Float, y: Float), radius: Float, velocity: (x: Float, y: Float)) {
        //TODO: Actual Image
        super.init(image: UIImage())
        self.position = position
        self.radius = radius
        self.velocity = velocity
    }
    
    required init(dict: NSMutableDictionary) {
        //TODO: Actual Image
        super.init(image: UIImage())
        position = (x: dict.value(forKey: GameModel.POSITION_X) as! Float, y: dict.value(forKey: GameModel.POSITION_Y) as! Float)
        radius = dict.value(forKey: GameModel.RADIUS) as! Float
        velocity = (x: dict.value(forKey: GameModel.VELOCITY_X) as! Float, y: dict.value(forKey: GameModel.VELOCITY_Y) as! Float)
    }
    
    //MARK: - Actions
    func fireBullet(velocity: (x: Float, y: Float)) -> Bullet {
        //TODO: Actual Image
        return Bullet(position: position, velocity: velocity)
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
        dict.setValue(position.x, forKey: GameModel.POSITION_X)
        dict.setValue(position.y, forKey: GameModel.POSITION_Y)
        dict.setValue(velocity.x, forKey: GameModel.VELOCITY_X)
        dict.setValue(velocity.y, forKey: GameModel.VELOCITY_Y)
        return dict
    }
}
