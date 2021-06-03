
import SpriteKit

class HandImage{
    private init(){}
    static func getImage(leftHand: Int,rightHand: Int)-> UIImage{
        switch leftHand {
        case 0:
            switch rightHand {
            case 2: return #imageLiteral(resourceName: "02.png")
            case 3: return #imageLiteral(resourceName: "03.png")
            case 4: return #imageLiteral(resourceName: "04.png")
            default: break
            }
        case 1:
            switch rightHand {
            case 1: return #imageLiteral(resourceName: "11.png")
            case 2: return #imageLiteral(resourceName: "12.png")
            case 3: return #imageLiteral(resourceName: "13.png")
            case 4: return #imageLiteral(resourceName: "14.png")
            default: break
            }
        case 2:
            switch rightHand {
            case 2: return #imageLiteral(resourceName: "22.png")
            case 3: return #imageLiteral(resourceName: "23.png")
            case 4: return #imageLiteral(resourceName: "24.png")
            default: break
            }
        case 3:
            switch rightHand {
            case 3: return #imageLiteral(resourceName: "33.png") 
            default: break
            }
        default: break
        }
        return #imageLiteral(resourceName: "P1 5 hand right .png") 
    }
}
