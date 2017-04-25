//
//  Bullet.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Bullet: Sprite, DestructableObject {
    
    //MARK: - Member Variables
    var destructionHandler: ((_ object: DestructableObject, _ index: Int) -> Void)?
    
    //MARK: - Initializers
    init(position: (x: Float, y: Float), velocity: (x: Float, y: Float), image: UIImage, rotation: Float) {
        //TODO: Actual Image
        super.init(image: image)
        self.position = position
        self.velocity = velocity
        self.scale = (x: 0.03,y: 0.03)
    }
    
    required init(dict: NSMutableDictionary) {
        super.init(image: UIImage(named: "PlayerLaser")!)
        self.scale = (x: 0.03,y: 0.03)
        position = (x: dict.value(forKey: GameModel.POSITION_X) as! Float, y: dict.value(forKey: GameModel.POSITION_Y) as! Float)
        radius = dict.value(forKey: GameModel.RADIUS) as! Float
        velocity = (x: dict.value(forKey: GameModel.VELOCITY_X) as! Float, y: dict.value(forKey: GameModel.VELOCITY_Y) as! Float)
    }
    
    //MARK: - Actions
    func destruct() {
//        destructionHandler?(self)
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
