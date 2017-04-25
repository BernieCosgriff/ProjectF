//
//  Boss.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/24/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import UIKit

class Boss: Enemy {
    
    private var numbers = [Number]()
    private var intLives = 3
    private var lifeSprite: Number!
    var hittable = true
    var display = true
    var timer: Timer?
    var timerCount = 0
    var destructionHandler: ((_ object: DestructableObject) -> Void)?
    
    init(position: (x: Float, y: Float), radius: Float, path: Path, invertX: Bool, lives: Int) {
        super.init(position: position, radius: radius, path: path, invertX: invertX)
        for i in 1...lives {
            numbers.append(Number(number: i))
        }
        lifeSprite = numbers.last!
        lifeSprite.position = (x: position.x, y: position.y + radius + 0.01)
        lifeSprite.velocity = velocity
        self.lives = lives
    }
    
    var lives: Int {
        get {
            return intLives
        }
        set {
            intLives = newValue
            if(newValue > 0) {
                let pos = lifeSprite.position
                let v = lifeSprite.velocity
                lifeSprite = numbers[newValue - 1]
                lifeSprite.position = pos
                lifeSprite.velocity = v
            }
        }
    }
    
    func hit() {
        lives -= 1
        hittable = false
        display = false
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: {
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
        if lives == 0 {
            destructionHandler?(self)
        }
    }
    
    required init(dict: NSMutableDictionary) {
        super.init(dict: dict)
    }
    
    override func move() {
        if(!entered && position.x + radius < 1.0 && position.x - radius > -1.0) {
            entered = true
        }
        var newPosition: (x: Float, y: Float) = (x: 0.0, y: 0.0)
        if entered {
            if (position.x >= 1.0 - radius && velocity.x > 0) || (position.x <= -1.0 + radius && velocity.x < 0){
                velocity.x = -velocity.x
                lifeSprite.velocity.x = -velocity.x
            }
            if (lifeSprite.position.y >= 1.0 - radius) || (lifeSprite.position.y <= -1.0 + radius) {
                velocity.y = -velocity.y
                lifeSprite.velocity.y = -lifeSprite.velocity.y
            }
            
            if path == Path.loop {
                newPosition.x = (position.x + (0.01 * Float(cos(GameModel.timePassed.magnitude)))) + velocity.x
                newPosition.y = position.y + (0.01 * Float(sin(GameModel.timePassed.magnitude)))
            } else {
                newPosition.x = position.x + velocity.x
                newPosition.y = position.y + velocity.y
            }
            newPosition.x = newPosition.x + radius > 1.0 ? 1.0 - radius : newPosition.x
            newPosition.x = newPosition.x - radius < -1.0 ? -1.0 + radius : newPosition.x
            newPosition.y = newPosition.y + radius > 1.0 ? 1.0 - radius : newPosition.y
            newPosition.y = newPosition.y - radius < -1.0 ? -1.0 + radius : newPosition.y
            position.x = newPosition.x
            position.y = newPosition.y
            lifeSprite.position.x = newPosition.x
            lifeSprite.position.y = newPosition.y + radius + 0.01
        } else {
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
            lifeSprite.position.x = newPosition.x
            lifeSprite.position.y = newPosition.y + radius + 0.01
        }
        
    }
    
    override func draw() {
        if display {
            super.draw()
            lifeSprite.draw()
        }
    }
}
