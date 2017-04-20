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
    var radius: Float { get }
    var position: (x: Float, y: Float) { get }
    var velocity: (x: Float, y: Float) { get }
    
    //MARK: - Initializers
    init(dict: NSMutableDictionary, index: Int)
    
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
    var playerBullets = [Bullet]()
    var enemyBullets = [Bullet]()
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
    static let PLAYER_BULLETS = "playerBullets"
    static let ENEMY_BULLETS = "enemyBullets"
    static let SHIP_SIZE: (x: Float, y: Float) = (x: 0.2,y: 0.2)
    
    //MARK: - Initializers
    init() {
        let path = getPath()
        
        if let dict = NSMutableDictionary(contentsOf: path) {
            //Background
            if let backgroundDict: NSMutableDictionary = dict.value(forKey: GameModel.BACKGROUND) as? NSMutableDictionary {
                self.background = Background(dict: backgroundDict)
            }
            //Player
            if let playerDict: NSMutableDictionary = dict.value(forKey: GameModel.PLAYER) as? NSMutableDictionary {
                self.player = Player(dict: playerDict, index: 0)
            }
            //Enemies
            if let enemiesArr: [NSMutableDictionary] = dict.value(forKey: GameModel.ENEMIES) as? [NSMutableDictionary] {
                for enemy in enemiesArr {
                    enemies.append(Enemy(dict: enemy, index: enemies.count - 1))
                }
            }
            //Enemy Bullets
            if let bulletsArr: [NSMutableDictionary] = dict.value(forKey: GameModel.ENEMY_BULLETS) as? [NSMutableDictionary] {
                for bullet in bulletsArr {
                    enemyBullets.append(EnemyBullet(dict: bullet, index: enemyBullets.count - 1))
                }
            }
            //Player Bullets
            if let bulletsArr: [NSMutableDictionary] = dict.value(forKey: GameModel.PLAYER_BULLETS) as? [NSMutableDictionary] {
                for bullet in bulletsArr {
                    playerBullets.append(PlayerBullet(dict: bullet, index: playerBullets.count - 1))
                }
            }
        }
    }
    
    //MARK: - Game Logic
    func update(timeInterval: TimeInterval) {
        timePassed += timeInterval.magnitude
        if(timePassed >= 1 && enemies.count == 0) {
            addEnemy(fireRate: 3)
        }
        checkCollisions()
        move()
    }
    
    private func addEnemy(fireRate: Double) {
        let newEnemy = Enemy(position: (x: -1.1, y: 0.8), radius: 0.1, velocity: (x: 0.01, y: 0.0), index: enemies.count)
        enemies.append(newEnemy)
        
        // TODO: Figure out async timer
        Timer.scheduledTimer(withTimeInterval: fireRate, repeats: true, block: {
            [weak self] timer in
            self?.enemyBullets.append((self?.enemies[self!.enemies.count - 1].fireBullet(playerPosition: self!.player!.position, index: self!.enemyBullets.count))!)
        })
    }
    
    private func move() {
        player?.move()
        background?.move()
        for bullet in playerBullets {
            bullet.move()
        }
        for bullet in enemyBullets {
            bullet.move()
        }
        for enemy in enemies {
            enemy.move()
        }
    }
    
    private func checkCollisions() {
        if let player = player {
            //Enemy - Player
            for enemy in enemies {
                if hasCollided(a: player, b: enemy) {
                    enemy.destruct()
                    player.destruct()
                }
            }
            //Player - EnemyBullet
            for bullet in enemyBullets {
                if hasCollided(a: player, b: bullet) {
                    bullet.destruct()
                    player.destruct()
                }
            }
        }
        //Enemy - PlayerBullet
        for enemy in enemies {
            for bullet in playerBullets {
                if hasCollided(a: enemy, b: bullet) {
                    bullet.destruct()
                    enemy.destruct()
                }
            }
        }
    }
    
    private func hasCollided(a: DestructableObject, b: DestructableObject) -> Bool {
        let xDist = a.position.x - b.position.x
        let yDist = a.position.y - b.position.y
        let radiusSum = a.radius + b.radius
        return sqrt((xDist * xDist) + (yDist * yDist)) < radiusSum
    }
    
    private func remove(object: DestructableObject, index: Int) {
        if object is Player {
            gameLost()
        } else if let enemy = object as? Enemy {
            enemies.remove(at: enemy.index)
        } else if let bullet = object as? EnemyBullet {
            enemyBullets.remove(at: bullet.index)
        } else if let bullet = object as? PlayerBullet {
            playerBullets.remove(at: bullet.index)
            
        }
    }
    
    private func gameLost() {
        
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
            if let bullet = player?.fireBullet(index: playerBullets.count){
                playerBullets.append(bullet)
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
    
    //TODO: Double Check Save Methods
    //MARK: - Saving
    func save() {
        let gameDict = NSMutableDictionary()
        let enemyArr = NSMutableArray()
        let playerBulletArr = NSMutableArray()
        let enemyBulletArr = NSMutableArray()
        //TODO: player and background optionals
        gameDict.setValue(background?.toDict(), forKey: GameModel.BACKGROUND)
        gameDict.setValue(player?.toDict(), forKey: GameModel.PLAYER)
        for enemy in enemies {
            enemyArr.add(enemy.toDict())
        }
        gameDict.setValue(enemyArr, forKey: GameModel.ENEMIES)
        for bullet in playerBullets {
            playerBulletArr.add(bullet.toDict())
        }
        for bullet in enemyBullets {
            enemyBulletArr.add(bullet.toDict())
        }
        gameDict.setValue(playerBulletArr, forKey: GameModel.PLAYER_BULLETS)
        gameDict.setValue(enemyBulletArr, forKey: GameModel.ENEMY_BULLETS)
        let path = getPath()
        gameDict.write(to: path, atomically: true)
    }
    
    private func getPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("ProjectF.plist")
    }
}
