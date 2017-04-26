//
//  Enemy.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Enemy: Sprite, DestructableObject {
    
    //MARK: - Member Variables
    let laser = UIImage(named: "EnemyLaser")!
    let bulletVelocity: (x: Float, y: Float) = (x: 0.02, y: 0.02)
    var entered = false
    var bulletHandler: ((_ bullet: EnemyBullet) -> Void)?
    var bulletTimer: Timer?
    var exitHandler: ((_ sender: Enemy) -> Void)?
    var path: Path = Path.standard
    let shipVelocity: (x: Float, y: Float) = (x: 0.01, y: 0.0)
    
    enum Path: Int {
        case standard = 0
        case zigzag = 1
        case loop = 2
    }
    
    //MARK: - Initializers
    init(position: (x: Float, y: Float), radius: Float, path: Path) {
        super.init(image: UIImage(named: "Enemy")!)
        self.position = position
        self.radius = radius
        self.velocity = shipVelocity
        self.path = path
        initRest()
    }
    
    required init(dict: NSMutableDictionary) {
        super.init(image: UIImage(named: "Enemy")!)
        position = (x: dict.value(forKey: GameModel.POSITION_X) as! Float, y: dict.value(forKey: GameModel.POSITION_Y) as! Float)
        radius = dict.value(forKey: GameModel.RADIUS) as! Float
        velocity = (x: dict.value(forKey: GameModel.VELOCITY_X) as! Float, y: dict.value(forKey: GameModel.VELOCITY_Y) as! Float)
        path = Path(rawValue: dict.value(forKey: GameModel.PATH) as! Int)!
        initRest()
    }
    
    func initRest() {
        if position.x > 0 {
            velocity.x = -velocity.x
        }
        if path == Path.zigzag {
            velocity.y = 0.01
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
                [weak self] timer in
                self?.velocity.y = -self!.velocity.y
            })
        }
        scale = GameModel.SHIP_SIZE
    }
    
    //MARK: - Actions
    func fireBullet(playerPosition: (x: Float, y: Float)) -> EnemyBullet {
        let firingPosition = (x: position.x, y: position.y - radius)
        let v = (x: (playerPosition.x - position.x) * bulletVelocity.x, y: (playerPosition.y - position.y) * bulletVelocity.y)
        let rotation = atan2(v.x, v.y)
        return EnemyBullet(position: firingPosition, velocity: v, image: laser, rotation: rotation)
    }
    
    func move() {
        if(!entered && position.x + radius < 1.0 && position.x - radius > -1.0) {
            entered = true
        }
        if entered {
            if position.x - radius > 1.0 || position.x + radius < -1.0 {
                exitHandler?(self)
            }
        }
        var newPosition: (x: Float, y: Float) = (x: 0.0, y: 0.0)
        if path == Path.loop {
            newPosition.x = (position.x + (0.01 * Float(cos(GameModel.timePassed.magnitude)))) + velocity.x
            newPosition.y = position.y + (0.01 * Float(sin(GameModel.timePassed.magnitude)))
        } else {
            newPosition.x = position.x + velocity.x
            newPosition.y = position.y + velocity.y
        }
        newPosition.y = newPosition.y + radius > 1.0 ? 1.0 - radius : newPosition.y
        newPosition.y = newPosition.y - radius < -1.0 ? -1.0 + radius : newPosition.y
        position.x = newPosition.x
        position.y = newPosition.y
    }
    
    func setTimer(fireRate: Double) {
        bulletTimer = Timer.scheduledTimer(withTimeInterval: fireRate, repeats: true, block: {
            [weak self] timer in
            self?.bulletHandler?((self!.fireBullet(playerPosition: GameModel.player!.position)))
        })
    }
    
    //MARK: - Saving
    func toDict() -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(radius, forKey: GameModel.RADIUS)
        dict.setValue(position.x, forKey: GameModel.POSITION_X)
        dict.setValue(position.y, forKey: GameModel.POSITION_Y)
        dict.setValue(velocity.x, forKey: GameModel.VELOCITY_X)
        dict.setValue(velocity.y, forKey: GameModel.VELOCITY_Y)
        dict.setValue(path.rawValue, forKey: GameModel.PATH)
        return dict
    }
}
