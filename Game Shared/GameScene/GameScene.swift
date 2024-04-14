//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //DZ_8_3
    class func newGameScene(_ size: CGSize? = nil) -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        if let size = size { scene.size = size }
        if #available(iOS 15, *) {
            scene.scaleMode = .aspectFit
        } else if #available(macOS 10.15, *) {
            scene.scaleMode = .aspectFit // for mac
        }
        
        return scene
    }
    
    private var scoreLabel: SKLabelNode!
    private let cursor = SKSpriteNode(imageNamed: "Cursor")

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false{
        didSet {
            if editingMode{
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = frame.size
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: frame.maxX - 150, y: frame.maxY - 50)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: frame.minX + 200, y: frame.maxY - 50)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: frame.minX + 128, y: frame.minY), isGood: true)
        makeSlot(at: CGPoint(x: frame.minX + 384, y: frame.minY), isGood: false)
        makeSlot(at: CGPoint(x: frame.minX + 640, y: frame.minY), isGood: true)
        makeSlot(at: CGPoint(x: frame.minX + 896, y: frame.minY), isGood: false)
        makeSlot(at: CGPoint(x: frame.minX + 1152, y: frame.minY), isGood: true)
        
        makeBouncer(at: CGPoint(x: frame.minX, y: frame.minY))
        makeBouncer(at: CGPoint(x: frame.minX + 256, y: frame.minY))
        makeBouncer(at: CGPoint(x: frame.minX + 512, y: frame.minY))
        makeBouncer(at: CGPoint(x: frame.minX + 768, y: frame.minY))
        makeBouncer(at: CGPoint(x: frame.minX + 1024, y: frame.minY))
        makeBouncer(at: CGPoint(x: frame.minX + 1280, y: frame.minY))
        
#if os(tvOS)
        cursor.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        cursor.zPosition = 10
        addChild(cursor)
#endif
    }
    
#if os(tvOS)
    func pressesBegan(type: UIPress.PressType) {
        switch type {
        case .downArrow:
            cursor.position.y -= 1
        case .upArrow:
            cursor.position.y += 1
        case .leftArrow:
            cursor.position.x -= 1
        case .rightArrow:
            cursor.position.x += 1
        case .select:
            viewTouched(cursor.position)
        default:
            break
        }
    }
#endif
    
    func viewTouched(_ location: CGPoint) {
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                //create a box
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: SKColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
            } else {
                let ball = SKSpriteNode(imageNamed: "ballRed")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = location
                ball.name = "ball"
                addChild(ball)
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good"{
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad"{
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location: CGPoint = touch.location(in: self)
        viewTouched(location)
    }
}
#endif

#if os(tvOS)
extension SKView {
    open override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .leftArrow, .rightArrow, .upArrow, .downArrow, .select:
                guard let scene = self.scene as? GameScene else { return }
                scene.pressesBegan(type: press.type)
            default:
                super.pressesBegan(presses, with: event)
            }
        }
    }
}
#endif


#if os(OSX)
extension SKView {
    open override func mouseDown(with event: NSEvent) {
        guard let scene = self.scene else { return }
        let location = event.location(in: scene)
        (scene as? GameScene)?.viewTouched(location)
    }
}
#endif
