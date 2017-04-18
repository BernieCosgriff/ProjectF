//
//  GameModel.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/1/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import Foundation

protocol DestructableObject {
    //MARK: - Member Variables
    var radius: Double { get }
    var position: (x: Double, y: Double) { get }
    var velocity: (x: Double, y: Double) { get }
    
    //MARK: - Initializers
    init(dict: NSMutableDictionary)
    
    //MARK: - Actions
    func destruct()
    func move()
    
    //MARK: - Saving
    func toDict() -> NSMutableDictionary
}

class GameModel {
    
    //MARK: - Member Variables
    var background: Background?
    var player: Player?
    var enemies = [Enemy]()
    var bullets = [Bullet]()
    let playerVelocityX: Float = 0.05
    let playerVelocityY: Float = 0.025
    private var timePassed: Double = 0.0
    
    //MARK: - Constants
    static let ORIGIN_X = "originX"
    static let ORIGIN_Y = "originY"
    static let POSITION_X = "positionX"
    static let POSITION_Y = "positionY"
    static let RADIUS = "radius"
    static let VELOCITY_X = "velocityX"
    static let VELOCITY_Y = "velocityY"
    static let BACKGROUND = "background"
    static let PLAYER = "player"
    static let ENEMIES = "enemies"
    static let BULLETS = "bullets"
    static let SHIP_SIZE: (x: Float, y: Float) = (x: 0.2,y: 0.2)
    
    //MARK: - Initializers
    init() {
        let path = getPath()
        if let dict = NSMutableDictionary(contentsOf: path) {
            if let backgroundDict: NSMutableDictionary = dict.value(forKey: GameModel.BACKGROUND) as? NSMutableDictionary {
                self.player = Player(dict: backgroundDict)
            }
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
    
    //MARK: - Game Logic
    func update(timeInterval: TimeInterval) {
        timePassed += timeInterval.magnitude
        
        if(timePassed >= 1 && enemies.count == 0) {
            let newEnemy = Enemy(position: (x: -1.1, y: 0.8), radius: 0.1, velocity: (x: 0.01, y: 0.0))
            enemies.append(newEnemy)
            // TODO: Figure out async timer
//            let timerQueue = OperationQueue()
//            timerQueue.addOperation {
//                
//            }
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: {
                [weak self] timer in
                self?.bullets.append((self?.enemies[self!.enemies.count - 1].fireBullet(playerPosition: self!.player!.position))!)
            })
        }
        
        //Move
        player?.move()
        background?.move()
        for bullet in bullets {
            bullet.move()
        }
        for enemy in enemies {
            enemy.move()
        }
    }
    
    func hasCollided(a: DestructableObject, b: DestructableObject) -> Bool {
        let xDist = a.position.x - b.position.x
        let yDist = a.position.y - b.position.y
        let radiusSum = a.radius + b.radius
        return sqrt((xDist * xDist) + (yDist * yDist)) < radiusSum
    }
    
    func setPlayerMovement(value: ShipControlSet.value) {
        switch value {
        case .topStart:
            player?.velocity.y = playerVelocityY
        case .topStop:
            player?.velocity.y = 0.0
        case .leftStart:
            player?.velocity.x = -playerVelocityX
        case .leftStop:
            player?.velocity.x = 0.0
        case .middleStart:
            if let bullet = player?.fireBullet(){
                bullets.append(bullet)
            }
        case .middleStop:
            break;
        case .rightStart:
            player?.velocity.x = playerVelocityX
        case .rightStop:
            player?.velocity.x = 0.0
        case .bottomStart:
            player?.velocity.y = -playerVelocityY
        case .bottomStop:
            player?.velocity.y = 0.0
        }
    }
    
    //MARK: - Saving
    func save() {
        let gameDict = NSMutableDictionary()
        let enemyArr = NSMutableArray()
        let bulletArr = NSMutableArray()
        //TODO: player and background optionals
        gameDict.setValue(background?.toDict(), forKey: GameModel.BACKGROUND)
        gameDict.setValue(player?.toDict(), forKey: GameModel.PLAYER)
        for enemy in enemies {
            enemyArr.add(enemy.toDict())
        }
        gameDict.setValue(enemyArr, forKey: GameModel.ENEMIES)
        for bullet in bullets {
            bulletArr.add(bullet.toDict())
        }
        gameDict.setValue(bulletArr, forKey: GameModel.BULLETS)
        let path = getPath()
        gameDict.write(to: path, atomically: true)
    }
    
    private func getPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("ProjectF.plist")
    }
}
