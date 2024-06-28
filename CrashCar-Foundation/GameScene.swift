import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var cone: SKSpriteNode?
    var car: SKSpriteNode?
    var hpLabel: SKLabelNode?
    
    let xPosition = [90, -90]
    
    var carPosition = 1
    
    var hp = "❤️❤️❤️"
    
    override func didMove(to view: SKView) {
        
//        unutk mendeteksi coualition
        physicsWorld.contactDelegate = self
        
//        register swipe gesture
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        cone = self.childNode(withName: "//cone") as? SKSpriteNode
        
        
        car = self.childNode(withName: "//car") as? SKSpriteNode
        car?.physicsBody = SKPhysicsBody(rectangleOf: car?.size ?? .zero)
        car?.physicsBody?.affectedByGravity = false
        car?.physicsBody?.allowsRotation = false
//        unutk memilih contact dengan siapa
        car?.physicsBody?.contactTestBitMask = car?.physicsBody?.collisionBitMask ?? 0
        
//        programaticly
//        pemanggilan car dengan kode
//        car = SKSpriteNode(imageNamed: "Car1")
        
        
//        set uo untuk hpLAbel
        hpLabel = SKLabelNode(text: "\(hp)")
        hpLabel?.position = CGPoint(x: 200, y: (size.height/2 - 45))
        
        addChild(hpLabel!)
        
        repeatedlySpawnCone()
        
        // Add double tap gesture recognizer
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapRecognizer)
    }
    
    func repeatedlySpawnCone(){
        let spawnAction = SKAction.run {
            self.spawnCone()
        }
        
        let waitAction = SKAction.wait(forDuration: 2)
        
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])

        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func spawnCone(){
        let newCone = cone?.copy() as! SKSpriteNode
        
        newCone.position = CGPoint(x: xPosition[Int.random(in: 0...1)], y: 700)
        
//        kasi physics saat spawn
        newCone.physicsBody = SKPhysicsBody(rectangleOf: newCone.size)
        newCone.physicsBody?.isDynamic = false
        addChild(newCone)
        
        moveCone(node: newCone)
    }
    
    func moveCone(node: SKNode){
//        SKAtion seperti tulang punggung si SpriteKit
        let moveDownAction = SKAction.moveTo(y: -700, duration: 4)
        let removeNodeAction = SKAction.removeFromParent()
        
        
        let rotateAction = SKAction.rotate(byAngle: CGFloat.pi, duration: 0.5)
        let repeatRotateAction = SKAction.repeatForever(rotateAction)
        
        let groupAction = SKAction.group([moveDownAction, repeatRotateAction])
        node.run(SKAction.sequence([groupAction, removeNodeAction]))
    }
    
    func updateCarPosition(){
//        if carPosition == 1 {
//            carPosition = 2
//        } else {
//            carPosition = 1
//        }
//        
        car?.run(SKAction.moveTo(x: (carPosition == 1) ? -80 : 80, duration: 0.1))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        updateCarPosition()
    }
    
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        let rotateAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 0.5)
        car?.run(rotateAction)
    }
    
    @objc func swipeRight(){
        carPosition = 2
        updateCarPosition()
        
    }
    
    @objc func swipeLeft(){
        carPosition = 1
        updateCarPosition()    }
    
//    untuk memberitahu ketika ada kontak
//    function yang menghandle kontak antara 2 node
    func didBegin(_ contact: SKPhysicsContact) {
//        is Exist
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
//        handle collision only between Car And Cone
        if nodeA.name == "car" && nodeB.name == "cone" {
            nodeB.removeFromParent()
        }
        if hp.count > 0 {
            hp.removeLast()
        }
        
        hpLabel?.text = "\(hp)"
        
        if hp.count == 0 {
            showGameOver()
        }
//        print(nodeA.name)
//        print(nodeB.name)
    }
    
    func showGameOver() {
        
        if let gameOverScene = SKScene(fileNamed: "GameOverScene") {
            // Tentukan transisi
            let transition = SKTransition.fade(withDuration: 1.0)
            
            // Transisi ke GameOverScene
            view?.presentScene(gameOverScene, transition: transition)
        }
        
        /*
        // Buat instance GameOverScene
        let gameOverScene = GameOverScene(size: size)
        
        // Tentukan transisi
        let transition = SKTransition.fade(withDuration: 1.0)
        
        // Transisi ke GameOverScene
        view?.presentScene(gameOverScene, transition: transition)
         
         */
    }

}
