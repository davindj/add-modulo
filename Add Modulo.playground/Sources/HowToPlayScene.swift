



import SpriteKit

public class HowToPlayScene : SKScene{
    // Component
    var btnExit: SKSpriteNode!
    var htpCard: SKSpriteNode!
    var ruleCard: SKSpriteNode!
    // State
    var touchedNode: SKSpriteNode?
    
    public override func didMove(to view: SKView) {
        // Background
        self.makeBackground(color: #colorLiteral(red: 1.0, green: 0.3837403059, blue: 0.3160096407, alpha: 1.0))
        
        // Load IMage
        btnExit = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "x.png"))) 
        btnExit.texture?.filteringMode = .nearest
        btnExit.position.x = btnExit.size.width / 2 + frame.size.height / 20
        btnExit.position.y = frame.size.height - btnExit.size.height / 2 - frame.size.height / 20
        addChild(btnExit)
        
        // Load Image
        htpCard = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "htp_card.png"))) 
        htpCard.texture?.filteringMode = .nearest
        htpCard.setScale(frame.size.height * 0.475 / htpCard.size.height)
        htpCard.position = middleScreen
        htpCard.position.y = frame.size.height * 0.75
        htpCard.alpha = 0
        addChild(htpCard)
        htpCard.run(.group([
            .fadeAlpha(to: 1, duration: 0.6)
        ]))
        
        // Load Image
        ruleCard = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "rules_card.png"))) 
        ruleCard.texture?.filteringMode = .nearest
        ruleCard.setScale(frame.size.height * 0.475 / ruleCard.size.height)
        ruleCard.position = middleScreen
        ruleCard.position.y = frame.size.height * 0.25
        ruleCard.alpha = 0
        addChild(ruleCard)
        ruleCard.run(.group([
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

