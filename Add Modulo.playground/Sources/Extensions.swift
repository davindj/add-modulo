
import SpriteKit

extension SKScene{
    // Buat Default Background
    func makeBackground(color: UIColor = .cyan){ 
        let backgroundNode = SKSpriteNode(color: color, size: size)
        backgroundNode.zPosition = -10
        backgroundNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(backgroundNode)
    }
    // Buat Transition Scene
    func transition(toScene scene: SKScene, transition: SKTransition? = nil){
        guard let view = self.view else{
            fatalError("View not Found!")
        }
        if let tr = transition{
            view.presentScene(scene, transition: tr)
        }else{
            view.presentScene(scene)
        }
    }
    // Get Middle Screen Location
    var middleScreen:CGPoint{
        return CGPoint(x: frame.midX, y: frame.midY)
    }
}

extension SKSpriteNode{
    func moveBelow(targetNode node: SKSpriteNode, distance: CGFloat){
        self.position = node.position - CGPoint(x:0, y: self.size.height/2 + node.size.height/2 + distance)
    }
}

extension CGFloat{
    var toRadian: CGFloat{
        return CGFloat(self) * .pi / 180
    }
    var degrees: CGFloat {
        return self * CGFloat(180) / .pi
    }
}

extension CGPoint {
    func angle(to comparisonPoint: CGPoint) -> CGFloat {
        let originX = comparisonPoint.x - x
        let originY = comparisonPoint.y - y
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = CGFloat(bearingRadians).degrees
        
        while bearingDegrees < 0 {
            bearingDegrees += 360
        }
        
        return bearingDegrees
    }
}

// Helper
func +(p1: CGPoint, p2: CGPoint)->CGPoint{
    return CGPoint(x: p1.x+p2.x, y: p1.y+p2.y)
}

func -(p1: CGPoint, p2: CGPoint)->CGPoint{
    return CGPoint(x: p1.x-p2.x, y: p1.y-p2.y)
}

