


import SpriteKit

public class AboutScene : SKScene{
    // Component
    var btnExit: SKSpriteNode!
    var card: SKSpriteNode!
    var desc: SKSpriteNode!
    
    // State
    var touchedNode: SKSpriteNode?
    
    public override func didMove(to view: SKView) {
        // Background
        self.makeBackground(color: #colorLiteral(red: 0.03348512575030327, green: 0.03960645943880081, blue: 0.2114810347557068, alpha: 1.0))
        
        // Load IMage
        btnExit = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "x.png"))) 
        btnExit.texture?.filteringMode = .nearest
        btnExit.position.x = btnExit.size.width / 2 + frame.size.height / 20
        btnExit.position.y = frame.size.height - btnExit.size.height / 2 - frame.size.height / 20
        addChild(btnExit)
        
        // Load Image
        desc = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "about_me.PNG"))) 
        desc.texture?.filteringMode = .nearest
        desc.setScale(frame.size.height * 0.9 / desc.size.height)
        desc.position = middleScreen
        desc.alpha = 0
        addChild(desc)
        desc.run(.group([
            .fadeAlpha(to: 1, duration: 0.6)
        ]))
    }
    
    // MARK: Event Handler
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        
        for node in touchedNodes{
            switch node {
            case btnExit: break
            default: continue
            }
            touchedNode = node as! SKSpriteNode
            node.alpha = 0.5
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        
        var isExit = false
        for node in touchedNodes{
            switch node {
            case btnExit: break
            default: continue 
            }
            if touchedNode != nil{
                isExit = true
            }
        }
        // Reset Touch
        touchedNode?.alpha = 1
        touchedNode = nil
        
        // Doaction jika valid
        if isExit{
            // Kembali ke home screen
            let transit: SKTransition = .fade(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), duration: 1)
            self.transition(toScene: HomeScene(size: self.size), transition: transit)
        }
    }
}

