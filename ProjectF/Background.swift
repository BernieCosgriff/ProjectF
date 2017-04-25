//
//  Background.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/7/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Background: Sprite {
    
    //MARK: - Initializers
    init(image: UIImage, position: (x: Float, y: Float), velocity: (x: Float, y: Float)) {
        super.init(image: image)
        self.position = position
        self.velocity = velocity
        self.scale = (x: 2.0, y: 2.0)
    }
    
    required init(dict: NSMutableDictionary) {
        //TODO: Actual Image
        super.init(image: UIImage())
        position = (x: dict.value(forKey: GameModel.POSITION_X) as! Float, y: dict.value(forKey: GameModel.POSITION_Y) as! Float)
        radius = dict.value(forKey: GameModel.RADIUS) as! Float
        velocity = (x: dict.value(forKey: GameModel.VELOCITY_X) as! Float, y: dict.value(forKey: GameModel.VELOCITY_Y) as! Float)
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
