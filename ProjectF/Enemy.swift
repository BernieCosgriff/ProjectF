//
//  Enemy.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Enemy: Sprite {
    
    var entered = false
    private let laser = UIImage(named: "EnemyLaser")!
    let bulletVelocity: (x: Float, y: Float) = (x: 0.02, y: 0.02)
    
    //MARK: - Initializers
    init(position: (x: Float, y: Float), radius: Float, velocity: (x: Float, y: Float)) {
        super.init(image: UIImage(named: "Enemy")!)
        self.position = position
        self.radius = radius
        self.velocity = velocity
        self.scale = GameModel.SHIP_SIZE
        
    }
    
    required init(dict: NSMutableDictionary) {
        super.init(image: UIImage(named: "Enemy")!)
        position = (x: dict.value(forKey: GameModel.POSITION_X) as! Float, y: dict.value(forKey: GameModel.POSITION_Y) as! Float)
        radius = dict.value(forKey: GameModel.RADIUS) as! Float
        velocity = (x: dict.value(forKey: GameModel.VELOCITY_X) as! Float, y: dict.value(forKey: GameModel.VELOCITY_Y) as! Float)
    }
    
    //MARK: - Actions
    func fireBullet(playerPosition: (x: Float, y: Float)) -> Bullet {
        //TODO: Enemy Bullet Image
        let firingPosition = (x: position.x, y: position.y - radius)
        let v = (x: (playerPosition.x - position.x) * bulletVelocity.x, y: (playerPosition.y - position.y) * bulletVelocity.y)
        let rotation = atan2(v.x, v.y)
        return Bullet(position: firingPosition, velocity: v, image: laser, rotation: rotation)
    }
    
    func destruct() {
        
    }
    
    func move() {
        if(position.x + radius < 1.0 && position.x - radius > -1.0) {
            entered = true
        }
        if entered {
            if position.x + radius > 1.0 || position.x - radius < -1.0 {
                velocity.x = -velocity.x
            }
        }
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
