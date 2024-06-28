//
//  GaneOverScene.swift
//  CrashCar-Foundation
//
//  Created by Foundation-014 on 28/06/24.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene{
    var gameOverLabel: SKLabelNode!
    
    override func didMove(to view: SKView){
        view.backgroundColor = .red
        gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = 50
        gameOverLabel.position = CGPoint(x: (size.width/2), y: (size.height/2))
        addChild(gameOverLabel)
    }
}
