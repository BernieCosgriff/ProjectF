//
//  Bullet.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Bullet: Sprite, DestructableObject {
    
    //MARK: - Initializers
    init(position: (x: Float, y: Float), velocity: (x: Float, y: Float), image: UIImage, rotation: Float) {
        super.init(image: image)
        self.position = position
        self.velocity = velocity
        self.scale = (x: 0.03,y: 0.03)
    }
    
    required init(dict: NSMutableDictionary, playerBullet: Bool) {
        let imgString = playerBullet ? "PlayerLaser" : "EnemyLaser"
        super.init(image: UIImage(named: imgString)!)
        self.scale = (x: 0.03,y: 0.03)
        self.position = (x: dict.value(forKey: GameModel.POSITION_X) as! Float, y: dict.value(forKey: GameModel.POSITION_Y) as! Float)
        self.radius = dict.value(forKey: GameModel.RADIUS) as! Float
        self.velocity = (x: dict.value(forKey: GameModel.VELOCITY_X) as! Float, y: dict.value(forKey: GameModel.VELOCITY_Y) as! Float)
    }
    
    //MARK: - Actions
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
