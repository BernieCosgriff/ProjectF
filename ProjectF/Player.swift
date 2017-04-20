//
//  Player.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Player: Sprite, DestructableObject {
    
    //MARK: - Member Variables
    private let laser = UIImage(named: "PlayerLaser")!
    private let bulletVelocity: (x: Float, y: Float) = (x: 0.0, y: 0.04)
    private let PLAYER_START: (x: Float, y: Float) = (x: 0.0, y: -0.45)
    private var lives = 5
    var destructionHandler: ((_ object: DestructableObject, _ index: Int) -> Void)?
    
    //MARK: - Initializers
    init() {
        super.init(image: UIImage(named: "Player")!)
        self.position = PLAYER_START
        self.radius = 0.1
        self.velocity = (x: 0.0, y: 0.0)
        self.scale = GameModel.SHIP_SIZE
    }
    
    required init(dict: NSMutableDictionary, index: Int) {
        super.init(image: UIImage(named: "Player")!)
        position = (x: dict.value(forKey: GameModel.POSITION_X) as! Float, y: dict.value(forKey: GameModel.POSITION_Y) as! Float)
        radius = dict.value(forKey: GameModel.RADIUS) as! Float
        velocity = (x: dict.value(forKey: GameModel.VELOCITY_X) as! Float, y: dict.value(forKey: GameModel.VELOCITY_Y) as! Float)
    }
    
    //MARK: - Actions
    func fireBullet(index: Int) -> Bullet {
        var position = self.position
        position.y = position.y + radius
        return PlayerBullet(position: position, velocity: bulletVelocity, image: laser, rotation: 0.0, index: index)
    }
    
    func destruct() {
        //TODO: Show Damage
        lives -= 1
        if lives == 0 {
            destructionHandler?(self, 0)
        }
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
