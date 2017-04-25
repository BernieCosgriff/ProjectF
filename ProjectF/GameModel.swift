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
    init(dict: NSMutableDictionary)
    
    //MARK: - Actions
    func move()
    
    //MARK: - Saving
    func toDict() -> NSMutableDictionary
}

class GameModel {
    
    //MARK: - Member Variables
    var background: Background?
    static var player: Player!
    var boss: Boss?
    var enemies = [Enemy]()
    var playerBullets = [Bullet]()
    var enemyBullets = [Bullet]()
    var debrisQueue = [Debris]()
    var livesArr = [PlayerLife]()
    var score: Score
    var level = 1
    var spawnedEnemies = 0
    let playerVelocityX: Float = 0.05
    let playerVelocityY: Float = 0.025
    static var timePassed: Double = 0.0
    
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
        score = Score()
        let path = getPath()
        var lives = 3
        
        if let dict = NSMutableDictionary(contentsOf: path) {
            //Background
            if let backgroundDict: NSMutableDictionary = dict.value(forKey: GameModel.BACKGROUND) as? NSMutableDictionary {
                self.background = Background(dict: backgroundDict)
            }
            //Player
            if let playerDict: NSMutableDictionary = dict.value(forKey: GameModel.PLAYER) as? NSMutableDictionary {
                GameModel.player = Player(dict: playerDict)
            }
            //Enemies
            if let enemiesArr: [NSMutableDictionary] = dict.value(forKey: GameModel.ENEMIES) as? [NSMutableDictionary] {
                for enemy in enemiesArr {
                    enemies.append(Enemy(dict: enemy))
                }
            }
            //Enemy Bullets
            if let bulletsArr: [NSMutableDictionary] = dict.value(forKey: GameModel.ENEMY_BULLETS) as? [NSMutableDictionary] {
                for bullet in bulletsArr {
                    enemyBullets.append(EnemyBullet(dict: bullet))
                }
            }
            //Player Bullets
            if let bulletsArr: [NSMutableDictionary] = dict.value(forKey: GameModel.PLAYER_BULLETS) as? [NSMutableDictionary] {
                for bullet in bulletsArr {
                    playerBullets.append(PlayerBullet(dict: bullet))
                }
            }
            lives = 4
        } else {
            GameModel.player = Player()
            background = Background()
            initLives(lives: lives)
        }
    }
    
    func initLives(lives: Int) {
        for i in 0...lives - 1 {
            livesArr.append(PlayerLife(position: (x: -0.93 + (Float(i)*0.2), y: 0.88)))
        }
    }
    
    //MARK: - Game Logic
    func update(timeInterval: TimeInterval) {
        if level == 1 {
            GameModel.timePassed += timeInterval.magnitude
            if(GameModel.timePassed >= 1 && spawnedEnemies == 0) {
//                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.8), path: Enemy.Path.loop, invert: false, boss: true)
                addEnemy(fireRate: 2, position: (x: -1.1, y: 0.8), path: Enemy.Path.loop, invert: false, boss: false)
            } else if (GameModel.timePassed >= 3 && spawnedEnemies == 1) {
                addEnemy(fireRate: 3, position: (x: 1.1, y: 0.6), path: Enemy.Path.zigzag, invert: true, boss: false)
            } else if(GameModel.timePassed >= 5 && spawnedEnemies == 2) {
                addEnemy(fireRate: 0, position: (x: -1.1, y: 0.7), path: Enemy.Path.loop, invert: false, boss: false)
            } else if(GameModel.timePassed >= 6 && spawnedEnemies == 3) {
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.5), path: Enemy.Path.zigzag, invert: false, boss: false)
            } else if(GameModel.timePassed >= 10 && spawnedEnemies == 4) {
                addEnemy(fireRate: 2, position: (x: -1.1, y: 0.7), path: Enemy.Path.loop, invert: false, boss: false)
            } else if(GameModel.timePassed >= 12 && spawnedEnemies == 5) {
                addEnemy(fireRate: 1, position: (x: 1.1, y: 0.7), path: Enemy.Path.loop, invert: true, boss: true)
            }
            checkCollisions()
            move()
        }
    }
    
    private func addEnemy(fireRate: Double, position: (x: Float, y: Float), path: Enemy.Path, invert: Bool, boss: Bool) {
        spawnedEnemies += 1
        var newEnemy: Enemy!
        if boss {
            self.boss = Boss(position: position, radius: 0.1, path: path, invertX: invert, lives: 3)
            if fireRate > 0 {
                self.boss!.setTimer(fireRate: fireRate)
                self.boss!.bulletHandler = {
                    [weak self] bullet in
                    self?.enemyBullets.append(bullet)
                }
            }
            self.boss!.destructionHandler = {
                [weak self] timer in
                self?.debrisQueue.insert(Debris(position: self!.boss!.position, velocity: self!.boss!.velocity, scale: self!.boss!.scale), at: 0)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {
                    [weak self] timer in
                    self?.debrisQueue.removeLast()
                })
                self?.boss = nil
            }
        } else {
            newEnemy = Enemy(position: position, radius: 0.1, path: path, invertX: invert)
            enemies.append(newEnemy)
            // TODO: Figure out async timer
            if fireRate > 0 {
                newEnemy.setTimer(fireRate: fireRate)
                newEnemy.bulletHandler = {
                    [weak self] bullet in
                    self?.enemyBullets.append(bullet)
                }
            }
            newEnemy.exitHandler = {
                [weak self] enemy in
                for (index, element) in self!.enemies.enumerated() {
                    if enemy === element {
                        self?.enemies.remove(at: index)
                    }
                }
            }
        }
    }
    
    private func move() {
        GameModel.player?.move()
        background?.move()
        boss?.move()
        for bullet in playerBullets {
            bullet.move()
        }
        for bullet in enemyBullets {
            bullet.move()
        }
        for enemy in enemies {
            enemy.move()
        }
        for debris in debrisQueue {
            debris.move()
        }
    }
    
    private func checkCollisions() {
        if GameModel.player.hittable {
            if let player = GameModel.player {
                //Enemy - Player
                for (index, element) in enemies.enumerated().reversed() {
                    if hasCollided(a: player, b: element) {
                        debrisQueue.insert(Debris(position: element.position, velocity: element.velocity, scale: element.scale), at: 0)
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {
                            [weak self] timer in
                            self?.debrisQueue.removeLast()
                        })
                        enemies.remove(at: index)
                        player.hit()
                        if !livesArr.isEmpty {
                            livesArr.removeLast()
                        }
                    }
                }
                if let boss = boss {
                    if boss.hittable {
                        if hasCollided(a: player, b: boss) {
                            boss.hit()
                        }
                    }
                }
                //Player - EnemyBullet
                for (index, element) in enemyBullets.enumerated().reversed() {
                    if hasCollided(a: player, b: element) {
                        enemyBullets.remove(at: index)
                        player.hit()
                        score.score -= 1
                        if !livesArr.isEmpty {
                            livesArr.removeLast()
                        }
                        break;
                    }
                }
            }
        }
        //Enemy - PlayerBullet
        for (index, element) in playerBullets.enumerated().reversed() {
            if let boss = boss {
                if boss.hittable {
                    if hasCollided(a: element, b: boss) {
                        boss.hit()
                        playerBullets.remove(at: index)
                    }
                }
            }
            for i in (0..<enemies.count).reversed() {
                if hasCollided(a: enemies[i], b: element) {
                    score.score += 1
                    let enemy = enemies[i]
                    debrisQueue.insert(Debris(position: enemy.position, velocity: enemy.velocity, scale: enemy.scale), at: 0)
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {
                        [weak self] timer in
                        self?.debrisQueue.removeLast()
                    })
                    enemies.remove(at: i)
                    playerBullets.remove(at: index)
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
    
    private func gameLost() {
        
    }
    
    func setPlayerMovement(value: ShipControlSet.value) {
        switch value {
        case .topStart:
            GameModel.player.velocity.y = playerVelocityY
            GameModel.player.fire = true
        case .topStop:
            GameModel.player?.velocity.y = 0.0
            GameModel.player.fire = false
        case .leftStart:
            GameModel.player?.velocity.x = -playerVelocityX
        case .leftStop:
            GameModel.player?.velocity.x = 0.0
        case .middleStart:
            if let bullet = GameModel.player?.fireBullet(){
                playerBullets.append(bullet)
            }
        case .middleStop:
            break;
        case .rightStart:
            GameModel.player?.velocity.x = playerVelocityX
        case .rightStop:
            GameModel.player?.velocity.x = 0.0
        case .bottomStart:
            GameModel.player?.velocity.y = -playerVelocityY
        case .bottomStop:
            GameModel.player?.velocity.y = 0.0
        }
    }
    
    func draw() {
        background?.draw()
        GameModel.player?.draw()
        boss?.draw()
        score.draw()
        for bullet in playerBullets + enemyBullets {
            bullet.draw()
        }
        for enemy in enemies {
            enemy.draw()
        }
        for debris in debrisQueue {
            debris.draw()
        }
        for life in livesArr {
            life.draw()
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
        gameDict.setValue(GameModel.player?.toDict(), forKey: GameModel.PLAYER)
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
