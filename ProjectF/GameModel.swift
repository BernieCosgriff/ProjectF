//
//  GameModel.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/1/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import Foundation
import AVFoundation

protocol DestructableObject {
    //MARK: - Member Variables
    var radius: Float { get }
    var position: (x: Float, y: Float) { get }
}

class GameModel {
    
    //MARK: - Member Variables
    var background: ScrollingBackground!
    static var player: Player!
    var boss: Boss?
    var enemies = [Enemy]()
    var playerBullets = [Bullet]()
    var enemyBullets = [Bullet]()
    var debrisQueue = [Debris]()
    var livesArr = [PlayerLife]()
    var score = Score()
    var spawnedEnemies = 0
    var levelInt = 1
    let playerVelocityX: Float = 0.05
    let playerVelocityY: Float = 0.025
    static var timePassed: Double = 0.0
    var soundPlayer: AVAudioPlayer!
    var backgroundPlayer: AVAudioPlayer!
    var highScores: [(name: String, score: Int)] = [(name: "", score: 0),(name: "", score: 0),(name: "", score: 0),(name: "", score: 0),(name: "", score: 0)]
    var gameOverHandler: (() -> Void)?
    var isGameOver = true
    var playerExplosion: PlayerExplosion?
    
    var level: Int {
        get {
            return levelInt
        }
        set {
            levelInt += 1
            if levelInt > 0 && levelInt < 4 {
                background.setBackground(level: levelInt)
            }
        }
    }
    
    //MARK: - Constants
    static let ORIGIN_X = "originX"
    static let ORIGIN_Y = "originY"
    static let POSITION_X = "positionX"
    static let POSITION_Y = "positionY"
    static let RADIUS = "radius"
    static let VELOCITY_X = "velocityX"
    static let VELOCITY_Y = "velocityY"
    static let PATH = "path"
    static let BACKGROUND = "background"
    static let PLAYER = "player"
    static let ENEMIES = "enemies"
    static let PLAYER_BULLETS = "playerBullets"
    static let ENEMY_BULLETS = "enemyBullets"
    static let LEVEL = "level"
    static let BOSS = "boss"
    static let LIVES = "lives"
    static let SCORE = "score"
    static let SPAWNED_ENEMIES = "spawnedEnemies"
    static let TIME_PASSED = "timePassed"
    static let FIRE_RATE = "fireRate"
    static let ENTERED = "entered"
    static let HIGH_SCORES_NAMES = "highScoresNames"
    static let HIGH_SCORES_VALUES = "highScoresValues"
    static let GAME_OVER = "gameOver"
    static let SHIP_SIZE: (x: Float, y: Float) = (x: 0.15,y: 0.15)
    
    //MARK: - Initializers
    init() {
        if let dict = NSMutableDictionary(contentsOf: path) {
            //Player
            if let playerDict = dict.value(forKey: GameModel.PLAYER) as? NSMutableDictionary {
                GameModel.player = Player(dict: playerDict)
            }
            //Enemies
            if let enemiesArr = dict.value(forKey: GameModel.ENEMIES) as? [NSMutableDictionary] {
                for enemy in enemiesArr {
                    let e = Enemy(dict: enemy)
                    e.bulletHandler = bulletHandler(bullet:)
                    e.exitHandler = exitHandler(enemy:)
                    enemies.append(e)
                }
            }
            //Enemy Bullets
            if let bulletsArr = dict.value(forKey: GameModel.ENEMY_BULLETS) as? [NSMutableDictionary] {
                for bullet in bulletsArr {
                    enemyBullets.append(EnemyBullet(dict: bullet, playerBullet: false))
                }
            }
            //Player Bullets
            if let bulletsArr = dict.value(forKey: GameModel.PLAYER_BULLETS) as? [NSMutableDictionary] {
                for bullet in bulletsArr {
                    playerBullets.append(PlayerBullet(dict: bullet, playerBullet: true))
                }
            }
            //Boss
            if let bossDict = dict.value(forKey: GameModel.BOSS) as? NSMutableDictionary {
                self.boss = Boss(dict: bossDict)
                self.boss?.destructionHandler = bossDestructionHandler(boss:)
                self.boss?.bulletHandler = bulletHandler(bullet:)
            }
            //Level
            if let level = dict.value(forKey: GameModel.LEVEL) as? Int {
                self.levelInt = level
            }
            //Score
            if let score = dict.value(forKey: GameModel.SCORE) as? Int {
                self.score.score = score
            }
            //Spawned Enemies
            if let spawnedEnemies = dict.value(forKey: GameModel.SPAWNED_ENEMIES) as? Int {
                self.spawnedEnemies = spawnedEnemies
            }
            //Time Passed
            if let timePassed = dict.value(forKey: GameModel.TIME_PASSED) as? Double {
                GameModel.timePassed = timePassed
            }
            //High Scores
            if let names = dict.value(forKey: GameModel.HIGH_SCORES_NAMES) as? [String], let scores = dict.value(forKey: GameModel.HIGH_SCORES_VALUES) as? [Int] {
                highScores = []
                for i in 0..<names.count {
                    highScores.append((name: names[i], score: scores[i]))
                }
            }
            //isGameOver
            if let gameOver = dict.value(forKey: GameModel.GAME_OVER) as? Bool {
                isGameOver = gameOver
            }
         } else {
            GameModel.player = Player(lives: 3)
        }
        GameModel.player.destructionHandler = gameOver
        background = ScrollingBackground(level: levelInt)
        background.levelUpHandler = nextLevel
        if GameModel.player.lives > 0 {
            for i in 0...GameModel.player.lives - 1 {
                livesArr.append(PlayerLife(position: (x: -0.93 + (Float(i)*0.2), y: 0.88)))
            }
        }
        let queue = OperationQueue()
        queue.addOperation {
            let url = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "wav")!
            do {
                self.backgroundPlayer = try AVAudioPlayer(contentsOf: url)
                guard let player = self.backgroundPlayer else { return }
                player.prepareToPlay()
                player.numberOfLoops = -1
                player.volume = 0.1
                player.play()
            } catch{}
        }
    }
    
    func reset() {
        GameModel.player = Player(lives: 3)
        levelInt = 1
        spawnedEnemies = 0
        GameModel.timePassed = 0
        GameModel.player.destructionHandler = gameOver
        background = ScrollingBackground(level: levelInt)
        background.levelUpHandler = nextLevel
        livesArr = []
        for i in 0...GameModel.player.lives - 1 {
            livesArr.append(PlayerLife(position: (x: -0.93 + (Float(i)*0.2), y: 0.88)))
        }
        boss = nil
        enemies = []
        playerBullets = []
        enemyBullets = []
        debrisQueue = []
        score = Score()
        isGameOver = false
    }
    
    //MARK: - Game Logic
    func update(timeInterval: TimeInterval) {
        GameModel.timePassed += timeInterval.magnitude
        if level == 1 {
            if(GameModel.timePassed >= 1 && spawnedEnemies == 0) {
                addEnemy(fireRate: 2, position: (x: -1.1, y: 0.8), path: Enemy.Path.standard, bossLives: 0)
            } else if (GameModel.timePassed >= 3 && spawnedEnemies == 1) {
                addEnemy(fireRate: 3, position: (x: 1.1, y: 0.6), path: Enemy.Path.zigzag, bossLives: 0)
            } else if(GameModel.timePassed >= 5 && spawnedEnemies == 2) {
                addEnemy(fireRate: 0, position: (x: -1.1, y: 0.7), path: Enemy.Path.loop, bossLives: 0)
            } else if(GameModel.timePassed >= 6 && spawnedEnemies == 3) {
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.5), path: Enemy.Path.zigzag, bossLives: 0)
            } else if(GameModel.timePassed >= 10 && spawnedEnemies == 4) {
                addEnemy(fireRate: 2, position: (x: -1.1, y: 0.7), path: Enemy.Path.loop, bossLives: 0)
            } else if(GameModel.timePassed >= 12 && spawnedEnemies == 5) {
                addEnemy(fireRate: 3, position: (x: 1.1, y: 0.4), path: Enemy.Path.standard, bossLives: 0)
            } else if(GameModel.timePassed >= 16 && spawnedEnemies == 6) {
                addEnemy(fireRate: 0, position: (x: -1.1, y: 0), path: Enemy.Path.standard, bossLives: 0)
            } else if(GameModel.timePassed >= 20 && spawnedEnemies == 7) {
                addEnemy(fireRate: 2, position: (x: -1.1, y: 0.7), path: Enemy.Path.zigzag, bossLives: 0)
            } else if(GameModel.timePassed >= 20 && spawnedEnemies == 8) {
                addEnemy(fireRate: 2, position: (x: 1.1, y: 0.5), path: Enemy.Path.zigzag, bossLives: 0)
            } else if(GameModel.timePassed >= 25 && spawnedEnemies == 9) {
                addEnemy(fireRate: 3, position: (x: 1.1, y: 0.5), path: Enemy.Path.standard, bossLives: 3)
            }
        } else if level == 2 {
            if(GameModel.timePassed >= 1 && spawnedEnemies == 0) {
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.8), path: Enemy.Path.standard, bossLives: 0)
                addEnemy(fireRate: 3, position: (x: 1.1, y: 0.6), path: Enemy.Path.standard, bossLives: 0)
            } else if (GameModel.timePassed >= 5 && spawnedEnemies == 2) {
                addEnemy(fireRate: 2, position: (x: 1.1, y: 0.6), path: Enemy.Path.standard, bossLives: 0)
                addEnemy(fireRate: 2, position: (x: 1.1, y: 0), path: Enemy.Path.zigzag, bossLives: 0)
            } else if(GameModel.timePassed >= 10 && spawnedEnemies == 4) {
                addEnemy(fireRate: 0, position: (x: -1.1, y: 0.8), path: Enemy.Path.standard, bossLives: 0)
                addEnemy(fireRate: 1, position: (x: 1.1, y: 0.5), path: Enemy.Path.loop, bossLives: 0)
            } else if(GameModel.timePassed >= 15 && spawnedEnemies == 6) {
                addEnemy(fireRate: 0, position: (x: 1.1, y: 0.0), path: Enemy.Path.standard, bossLives: 0)
                addEnemy(fireRate: 1, position: (x: 1.1, y: 0.5), path: Enemy.Path.loop, bossLives: 0)
                addEnemy(fireRate: 0, position: (x: -1.1, y: 0.3), path: Enemy.Path.standard, bossLives: 0)
            } else if(GameModel.timePassed >= 20 && spawnedEnemies == 9) {
                addEnemy(fireRate: 2, position: (x: -1.1, y: 0.8), path: Enemy.Path.zigzag, bossLives: 0)
                addEnemy(fireRate: 2, position: (x: 1.1, y: 0.1), path: Enemy.Path.zigzag, bossLives: 0)
            } else if(GameModel.timePassed >= 25 && spawnedEnemies == 11) {
                addEnemy(fireRate: 1, position: (x: -1.1, y: 0.8), path: Enemy.Path.loop, bossLives: 0)
                addEnemy(fireRate: 1, position: (x: 1.1, y: 0.1), path: Enemy.Path.loop, bossLives: 0)
            } else if(GameModel.timePassed >= 30 && spawnedEnemies == 13) {
                addEnemy(fireRate: 1, position: (x: -1.1, y: 0.7), path: Enemy.Path.zigzag, bossLives: 0)
            } else if(GameModel.timePassed >= 35 && spawnedEnemies == 14) {
                addEnemy(fireRate: 1, position: (x: 1.1, y: 0.6), path: Enemy.Path.zigzag, bossLives: 4)
            }
        } else if level == 3 {
            if(GameModel.timePassed >= 3 && spawnedEnemies == 0) {
                addEnemy(fireRate: 1, position: (x: -1.1, y: 0.8), path: Enemy.Path.loop, bossLives: 0)
            } else if (GameModel.timePassed >= 5 && spawnedEnemies == 1) {
                addEnemy(fireRate: 3, position: (x: 1.1, y: 0.6), path: Enemy.Path.zigzag, bossLives: 0)
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.3), path: Enemy.Path.zigzag, bossLives: 0)
            } else if (GameModel.timePassed >= 10 && spawnedEnemies == 3) {
                addEnemy(fireRate: 3, position: (x: 1.1, y: 0.6), path: Enemy.Path.zigzag, bossLives: 0)
                addEnemy(fireRate: 3, position: (x: 1.1, y: 0.3), path: Enemy.Path.zigzag, bossLives: 0)
            } else if (GameModel.timePassed >= 12 && spawnedEnemies == 5) {
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.6), path: Enemy.Path.standard, bossLives: 0)
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.3), path: Enemy.Path.standard, bossLives: 0)
            } else if (GameModel.timePassed >= 15 && spawnedEnemies == 7) {
                addEnemy(fireRate: 2, position: (x: 1.1, y: 0.8), path: Enemy.Path.zigzag, bossLives: 0)
                addEnemy(fireRate: 2, position: (x: 1.1, y: 0.7), path: Enemy.Path.zigzag, bossLives: 0)
            } else if (GameModel.timePassed >= 16 && spawnedEnemies == 9) {
                addEnemy(fireRate: 2, position: (x: 1.1, y: 0.6), path: Enemy.Path.zigzag, bossLives: 0)
                addEnemy(fireRate: 2, position: (x: 1.1, y: 0.5), path: Enemy.Path.zigzag, bossLives: 0)
            } else if (GameModel.timePassed >= 17 && spawnedEnemies == 11) {
                addEnemy(fireRate: 2, position: (x: 1.1, y: 0.4), path: Enemy.Path.zigzag, bossLives: 0)
                addEnemy(fireRate: 2, position: (x: 1.1, y: 0.3), path: Enemy.Path.zigzag, bossLives: 0)
            } else if (GameModel.timePassed >= 20 && spawnedEnemies == 13) {
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.8), path: Enemy.Path.loop, bossLives: 0)
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.7), path: Enemy.Path.loop, bossLives: 0)
            } else if (GameModel.timePassed >= 21 && spawnedEnemies == 15) {
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.6), path: Enemy.Path.loop, bossLives: 0)
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.5), path: Enemy.Path.loop, bossLives: 0)
            } else if (GameModel.timePassed >= 22 && spawnedEnemies == 17) {
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.4), path: Enemy.Path.loop, bossLives: 0)
                addEnemy(fireRate: 3, position: (x: -1.1, y: 0.3), path: Enemy.Path.loop, bossLives: 0)
            } else if (GameModel.timePassed >= 25 && spawnedEnemies == 19) {
                addEnemy(fireRate: 3, position: (x: 1.1, y: 0.8), path: Enemy.Path.standard, bossLives: 0)
            } else if (GameModel.timePassed >= 30 && spawnedEnemies == 20) {
                addEnemy(fireRate: 0.7, position: (x: 1.1, y: 0.6), path: Enemy.Path.loop, bossLives: 5)
            }
        } else {
            gameOver()
        }
        
        checkCollisions()
        move()
    }
    
    private func playSound(sound: String, ext: String) {
        let queue = OperationQueue()
        queue.addOperation {
            let url = Bundle.main.url(forResource: sound, withExtension: ext)!
            do {
                self.soundPlayer = try AVAudioPlayer(contentsOf: url)
                guard let player = self.soundPlayer else { return }
                
                player.prepareToPlay()
                player.volume = 1.0
                player.play()
            } catch{}
        }
    }
    
    private func addEnemy(fireRate: Double, position: (x: Float, y: Float), path: Enemy.Path, bossLives: Int) {
        spawnedEnemies += 1
        var newEnemy: Enemy!
        if bossLives > 0 {
            self.boss = Boss(position: position, radius: 0.1, path: path, lives: bossLives)
            if fireRate > 0 {
                self.boss!.setTimer(fireRate: fireRate)
                self.boss!.bulletHandler = bulletHandler(bullet:)
            }
            self.boss!.destructionHandler = bossDestructionHandler(boss:)
        } else {
            newEnemy = Enemy(position: position, radius: 0.1, path: path)
            enemies.append(newEnemy)
            if fireRate > 0 {
                newEnemy.setTimer(fireRate: fireRate)
                newEnemy.bulletHandler = bulletHandler(bullet:)
            }
            newEnemy.exitHandler = exitHandler(enemy:)
        }
    }
    
    func bossDestructionHandler(boss: Enemy) {
        score.score += 3
        debrisQueue.insert(Debris(position: boss.position, velocity: boss.velocity, scale: boss.scale), at: 0)
        boss.bulletTimer?.invalidate()
        boss.bulletTimer = nil
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {
            [weak self] timer in
            self?.debrisQueue.removeLast()
            self?.level += 1
            GameModel.timePassed = 0
            self?.spawnedEnemies = 0
        })
        self.boss = nil
        save()
    }
    
    func bulletHandler(bullet: Bullet) {
        enemyBullets.append(bullet)
    }
    
    func exitHandler(enemy: Enemy) {
        for (index, element) in enemies.enumerated() {
            if enemy === element {
                enemy.bulletTimer?.invalidate()
                enemy.bulletTimer = nil
                enemies.remove(at: index)
            }
        }
    }
    
    private func move() {
        GameModel.player?.move()
        background?.move()
        boss?.move()
        playerExplosion?.move()
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
        if isGameOver {
            return
        }
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
                            playSound(sound: "loseLife", ext: "mp3")
                        } else {
                            playSound(sound: "Bomb", ext: "mp3")
                        }
                    }
                }
                //Enemy - Boss
                if let boss = boss {
                    if boss.hittable {
                        if hasCollided(a: player, b: boss) {
                            boss.hit()
                            player.hit()
                            if !livesArr.isEmpty {
                                livesArr.removeLast()
                                playSound(sound: "loseLife", ext: "mp3")
                            } else {
                                playSound(sound: "Bomb", ext: "mp3")
                            }
                        }
                    }
                }
                //Player - EnemyBullet
                for (index, element) in enemyBullets.enumerated().reversed() {
                    if hasCollided(a: player, b: element) {
                        enemyBullets.remove(at: index)
                        score.score -= 1
                        player.hit()
                        if !livesArr.isEmpty {
                            livesArr.removeLast()
                            playSound(sound: "loseLife", ext: "mp3")
                        } else {
                            playSound(sound: "Bomb", ext: "mp3")
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
                        score.score += 1
                        playerBullets.remove(at: index)
                        playSound(sound: "zap", ext: "mp3")
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
                    playSound(sound: "zap", ext: "mp3")
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
    
    private func nextLevel() {
        GameModel.timePassed = 0
        spawnedEnemies = 0
    }
    
    func setHighScores(name: String) {
        for i in 0..<highScores.count {
            if highScores[i].score < score.score || highScores[i].name.isEmpty {
                highScores.insert((name: name, score: score.score), at: i)
                highScores.removeLast()
                break
            }
        }
    }
    
    func isHighScore() -> Bool {
        for i in 0..<highScores.count {
            if highScores[i].score < score.score || highScores[i].name.isEmpty {
                return true
            }
        }
        return false
    }
    
    private func gameOver() {
        playerExplosion = PlayerExplosion(position: GameModel.player.position, velocity: GameModel.player.velocity, scale: (x: 0.3, y: 0.2))
        isGameOver = true
        save()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {
            _ in
            self.playerExplosion = nil
            self.gameOverHandler?()
        })
        
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
                playSound(sound: "sfx_laser1", ext: "mp3")
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
        playerExplosion?.draw()
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
        var nameArr = [String]()
        var scoreArr = [Int]()
        
        for enemy in enemies {
            enemyArr.add(enemy.toDict())
        }
        for bullet in playerBullets {
            playerBulletArr.add(bullet.toDict())
        }
        for bullet in enemyBullets {
            enemyBulletArr.add(bullet.toDict())
        }
        
        if let boss = boss {
            gameDict.setValue(boss.toDict(), forKey: GameModel.BOSS)
        }
        gameDict.setValue(enemyArr, forKey: GameModel.ENEMIES)
        gameDict.setValue(playerBulletArr, forKey: GameModel.PLAYER_BULLETS)
        gameDict.setValue(enemyBulletArr, forKey: GameModel.ENEMY_BULLETS)
        gameDict.setValue(GameModel.player.toDict(), forKey: GameModel.PLAYER)
        gameDict.setValue(levelInt, forKey: GameModel.LEVEL)
        gameDict.setValue(score.score, forKey: GameModel.SCORE)
        gameDict.setValue(spawnedEnemies, forKey: GameModel.SPAWNED_ENEMIES)
        gameDict.setValue(GameModel.timePassed, forKey: GameModel.TIME_PASSED)
        gameDict.setValue(isGameOver, forKey: GameModel.GAME_OVER)
        for i in 0..<highScores.count {
            nameArr.append(highScores[i].name)
            scoreArr.append(highScores[i].score)
        }
        gameDict.setValue(nameArr, forKey: GameModel.HIGH_SCORES_NAMES)
        gameDict.setValue(scoreArr, forKey: GameModel.HIGH_SCORES_VALUES)
        gameDict.write(to: path, atomically: true)
        print("Saved")
    }
    
    private var path: URL {
        get {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory.appendingPathComponent("ProjectF.plist")
        }
    }
}
