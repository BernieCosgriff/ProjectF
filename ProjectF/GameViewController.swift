//
//  GameViewController.swift
//  ProjectF
//
//  Created by Bernard Cosgriff on 4/2/17.
//  Copyright © 2017 Bernard Cosgriff. All rights reserved.
//

import GLKit

class GameViewController: GLKViewController {
    
    var model: GameModel!
    
    init(model: GameModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        let gameQueue = OperationQueue()
        gameQueue.addOperation {
            let timer = Timer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        }
        
    }
    
    func update() {
        print(timeSinceLastUpdate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
    }
    
}
