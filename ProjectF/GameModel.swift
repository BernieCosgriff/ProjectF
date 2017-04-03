//
//  GameModel.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/1/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import Foundation

class GameModel {
    
    //MARK: - Member Variables
    //TODO: Put in actual values
    var player = Player(origin: (x: 0.0, y: 0.0), position: (x: 0.0, y: 0.0), radius: -1.0)
    var enemies = [Enemy]()
    var bullets = [Bullet]()
    
    //MARK: - Constants
    static let ORIGIN_X = "originX"
    static let ORIGIN_Y = "originY"
    static let POSITION_X = "positionX"
    static let POSITION_Y = "positionY"
    static let RADIUS = "radius"
    static let VELOCITY = "velocity"
    static let PLAYER = "player"
    static let ENEMIES = "enemies"
    static let BULLETS = "bullets"
    
    //MARK: - Initializers
    init() {
        let path = getPath()
        if let dict = NSMutableDictionary(contentsOf: path) {
            if let playerDict: NSMutableDictionary = dict.value(forKey: GameModel.PLAYER) as? NSMutableDictionary {
                self.player = Player(dict: playerDict)
            }
            if let enemiesArr: [NSMutableDictionary] = dict.value(forKey: "enemies") as? [NSMutableDictionary] {
                for enemy in enemiesArr {
                    enemies.append(Enemy(dict: enemy))
                }
            }
            if let bulletsArr: [NSMutableDictionary] = dict.value(forKey: "bullets") as? [NSMutableDictionary] {
                for bullet in bulletsArr {
                    bullets.append(Bullet(dict: bullet))
                }
            }
        }
    }
    
    //MARK: - Game Logic Functions
    func update(timeInterval: TimeInterval) {
    
    }
    
    func hasCollided(a: DestructableObject, b: DestructableObject) -> Bool {
        let xDist = a.position.x - b.position.x
        let yDist = a.position.y - b.position.y
        let radiusSum = a.radius + b.radius
        return sqrt((xDist * xDist) + (yDist * yDist)) < radiusSum
    }
    
    //MARK: - Saving Functions
    func save() {
        let gameDict = NSMutableDictionary()
        let enemyArr = NSMutableArray()
        let bulletArr = NSMutableArray()
        gameDict.setValue(player.toDict(), forKey: "player")
        for enemy in enemies {
            enemyArr.add(enemy.toDict())
        }
        gameDict.setValue(enemyArr, forKey: "enemies")
        for bullet in bullets {
            bulletArr.add(bullet.toDict())
        }
        gameDict.setValue(bulletArr, forKey: "bullets")
        let path = getPath()
        gameDict.write(to: path, atomically: true)
    }
    
    private func getPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("ProjectF.plist")
    }
}
