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
    var lives = 3
    private var fireSprite: Fire?
    private var timer: Timer?
    private var timerCount = 0
    var hittable = true
    var display = true
    var destructionHandler: (() -> Void)?
    
    //MARK: - Initializers
    init(lives: Int) {
        super.init(image: UIImage(named: "Player")!)
        self.position = PLAYER_START
        self.radius = 0.1
        self.velocity = (x: 0.0, y: 0.0)
        self.scale = GameModel.SHIP_SIZE
        self.lives = lives
    }
    
    required init(dict: NSMutableDictionary) {
        super.init(image: UIImage(named: "Player")!)
        position = (x: dict.value(forKey: GameModel.POSITION_X) as! Float, y: dict.value(forKey: GameModel.POSITION_Y) as! Float)
        radius = dict.value(forKey: GameModel.RADIUS) as! Float
        velocity = (x: dict.value(forKey: GameModel.VELOCITY_X) as! Float, y: dict.value(forKey: GameModel.VELOCITY_Y) as! Float)
        lives = dict.value(forKey: GameModel.LIVES) as! Int
        scale = GameModel.SHIP_SIZE
    }
    
    //MARK: - Actions
    func fireBullet() -> Bullet {
        var position = self.position
        position.y = position.y + radius
        return PlayerBullet(position: position, velocity: bulletVelocity, image: laser, rotation: 0.0)
    }
    
    func hit() {
        lives -= 1
        hittable = false
        display = false
        if lives < 0 {
            destructionHandler?()
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {
            [weak self] timer in
            self?.display = !self!.display
            self?.timerCount += 1
            if(self?.timerCount == 7) {
                self?.timerCount = 0
                self?.hittable = true
                self?.display = true
                timer.invalidate()
            }
        })
    }
    
    func move() {
        if position.x + radius + velocity.x < 1 && position.x - radius + velocity.x > -1 {
            position.x = position.x + velocity.x
            if let fire = fireSprite {
                fire.position.x = fire.position.x + velocity.x
            }
        }
        if position.y + radius + velocity.y < 1 && position.y - radius + velocity.y > -1 {
            position.y = position.y + velocity.y
            if let fire = fireSprite {
                fire.position.y = fire.position.y + velocity.y
            }
        }
    }
    
    var fire: Bool {
        get {
            return self.fireSprite != nil
        }
        set {
            if newValue == true {
                let firePos = (x: position.x, y: position.y - (radius * 1.7))
                fireSprite = Fire(position: firePos)
            } else {
                self.fireSprite = nil
            }
        }
    }
    
    override func draw() {
        if display {
            super.draw()
            fireSprite?.draw()
        }
    }
    
    //MARK: - Saving
    func toDict() -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(radius, forKey: GameModel.RADIUS)
        dict.setValue(position.x, forKey: GameModel.POSITION_X)
        dict.setValue(position.y, forKey: GameModel.POSITION_Y)
        dict.setValue(velocity.x, forKey: GameModel.VELOCITY_X)
        dict.setValue(velocity.y, forKey: GameModel.VELOCITY_Y)
        dict.setValue(lives, forKey: GameModel.LIVES)
        return dict
    }
}
