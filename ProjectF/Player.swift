//
//  Player.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Player: Sprite {
    
    let laser = UIImage(named: "PlayerLaser")!
    
    //MARK: - Member Variables
    let bulletVelocity: (x: Float, y: Float) = (x: 0.0, y: 0.04)
    let PLAYER_START: (x: Float, y: Float) = (x: 0.0, y: -0.45)
    
    //MARK: - Initializers
    init() {
        super.init(image: UIImage(named: "Player")!)
        self.position = PLAYER_START
        self.radius = 0.1
        self.velocity = (x: 0.0, y: 0.0)
        self.scale = GameModel.SHIP_SIZE
    }
    
    required init(dict: NSMutableDictionary) {
        super.init(image: UIImage(named: "Player")!)
        position = (x: dict.value(forKey: GameModel.POSITION_X) as! Float, y: dict.value(forKey: GameModel.POSITION_Y) as! Float)
        radius = dict.value(forKey: GameModel.RADIUS) as! Float
        velocity = (x: dict.value(forKey: GameModel.VELOCITY_X) as! Float, y: dict.value(forKey: GameModel.VELOCITY_Y) as! Float)
    }
    
    //MARK: - Actions
    func fireBullet() -> Bullet {
        var position = self.position
        position.y = position.y + radius
        return Bullet(position: position, velocity: bulletVelocity, image: laser, rotation: 0.0)
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
