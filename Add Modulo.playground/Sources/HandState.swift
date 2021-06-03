
public enum HandAction {
    case attackLeftWithLeft
    case attackLeftWithRight
    case attackRightWithLeft
    case attackRightWithRight
    case distribute1 // tgn kanan -1
    case distribute2 // tgn kanan -2 / tgn kanan +1 
    
    static var listAttack: [HandAction]{
        return [
            .attackLeftWithLeft, 
            .attackRightWithLeft, 
            .attackLeftWithRight, 
            .attackRightWithRight
        ]
    }
    
    static var allAction: [HandAction]{
        return [
            .attackLeftWithLeft, 
            .attackRightWithLeft, 
            .attackLeftWithRight, 
            .attackRightWithRight,
            .distribute1,
            .distribute2 
        ]
    }
}

public struct ActionNode{
    var isValid: Bool
    var newState: HandState
    var action: HandAction
}

public struct HandState{
    var e1: Int
    var e2: Int
    var p1: Int
    var p2: Int
    
    // MARK: Computed Property
    var isDistributable1: Bool{
        distribute().count >= 1
    }
    var isDistributable2: Bool{
        distribute().count == 2
    }
    var isDividable: Bool{
        var pleft = p1
        var pright = p2
        if pright > pleft{
            let temp = pleft
            pleft = pright
            pright = temp
        }
        // Divideable jika:
        // - salah satu tangan kosong
        // - angka pada tangan genap
        return pleft != 0 && pright == 0 && pleft % 2 == 0
    }
    var isMergeable: Bool{
        return p1 + p2 < 5 && p1 != 0 && p2 != 0
    }
    var isEnemyWin: Bool{
        return p1 + p2 == 0
    }
    var isPlayerWin: Bool{
        return e1 + e2 == 0
    }
    
    // MARK: Mutating Function
    mutating func swap(){
        let temp1 = e1
        let temp2 = e2
        self.e1 = self.p1
        self.e2 = self.p2
        self.p1 = temp1
        self.p2 = temp2
    }
    
    // MARK: Normal Function
    func isPossibleAttack(action: HandAction) -> Bool{
        let isAttack: Bool = HandAction.listAttack.contains(action)
        if !isAttack{
            return false
        }else{
            let idxAttack: Int = HandAction.listAttack.firstIndex(of: action)!
            let e = [e1,e2,e1,e2][idxAttack]
            let p = [p1,p1,p2,p2][idxAttack]
            let isPossible = e != 0 && p != 0
            return isPossible
        }
    }
    // Check if Valid hand
    func isHandValid(leftHand: Int, rightHand: Int)->Bool{
        let isLeftHandValid = 0 <= leftHand && leftHand <= 4
        let isRightHandValid = 0 <= rightHand && rightHand <= 4
        return isLeftHandValid && isRightHandValid
    }
    func isSameHand(leftHand1: Int, rightHand1: Int, leftHand2: Int, rightHand2: Int)->Bool{
        return max(leftHand1,rightHand1) == max(leftHand2, rightHand2) && min(leftHand1,rightHand1) == min(leftHand2, rightHand2)
    }
    
    // Action
    func distribute()->[[Int]]{
        var allPossibleHand: [[Int]]=[]
        for i in -2...2{
            if i == 0{
                continue
            }
            var pleft = p1 - i
            var pright = p2 + i
            // Check Valid
            if !isHandValid(leftHand: pleft, rightHand: pright){
                continue
            }
            // Check apakah sama dengan tangan awal
            if isSameHand(leftHand1: pleft, rightHand1: pright, leftHand2: p1, rightHand2: p2){
                continue
            }
            // Check if hand exist
            var isExist = false
            for hand in allPossibleHand{
                if isSameHand(leftHand1: pleft, rightHand1: pright, leftHand2: hand[0], rightHand2: hand[1]){
                    isExist = true
                    break
                }
            }
            if isExist{
                continue
            }
            // Jika baru maka Insert
            allPossibleHand.append([min(pleft,pright),max(pleft, pright)])
        }
        return allPossibleHand
    }
    func doAction(action: HandAction) -> ActionNode{
        // Return
        var retState: HandState = self
        // Condition
        var isValidMove = true
        if isPossibleAttack(action: action){
            let idxAttack: Int = HandAction.listAttack.firstIndex(of: action)!
            let e = [e1,e2,e1,e2][idxAttack]
            let p = [p1,p1,p2,p2][idxAttack]
            let result = (e + p) % 5
            if action == .attackLeftWithLeft{
                retState.e1 = result
            }else if action == .attackRightWithLeft{
                retState.e2 = result
            }else if action == .attackLeftWithRight{
                retState.e1 = result
            }else if action == .attackRightWithRight{
                retState.e2 = result
            }
        }else if action == .distribute1 && self.isDistributable1{
            let distributeResult = distribute()[0]
            retState.p1 = distributeResult[0]
            retState.p2 = distributeResult[1]
        }else if action == .distribute2 && self.isDistributable2{
            let distributeResult = distribute()[1]
            retState.p1 = distributeResult[0]
            retState.p2 = distributeResult[1]
        }else{
            isValidMove = false
        }
        return ActionNode(isValid: isValidMove, newState: retState, action: action)
    }
    
    func aiMove(difficulty: GameDifficulty)->ActionNode{
        var stateAi = self
        
        // Implement MiniMaxAlgorithm
        // Algorithm to Find Best Movement for AI
        struct MiniMaxNode {
            var sbe: Int
            var action: HandAction?
        }
        let nPly = difficulty == .easy ? 3 : 5
        func sbe(state: HandState, isAiTurn: Bool) -> Int{
            // Function to Calculate how well AI current AI State
            // Only Hard Bot can determine AI State
            if difficulty == .hard{
                // if current state has a total of 1 then is bad for em
                // but if both of player have a total of 1 then its depends on whose turn
                if state.p1 + state.p2 == state.e1 + state.e2 && state.p1 + state.p2 == 1{
                    if isAiTurn{ // AI losing
                        print("ai losing")
                        return -1 
                    } else{ // AI Winning
                        print("ai wining")
                        return 1
                    }
                }else if state.p1 + state.p2 == 1{ // AI losing
                    print("ai losing, ai 1 hand")
                    return -1
                }else if state.e1 + state.e2 == 1{ // AI Winning
                    print("ai winning, player 1 hand")
                    return 1
                }
            }
            // 0 Is Neutral not good and not bad
            return 0
        }
        func miniMax (ply: Int, state:HandState, turn:Int=0)->MiniMaxNode{
            // End Ply (Static Board Evaluation) DRAW
            let isAiTurn = turn == 0 // Jika 0 maka giliran AI
            if ply <= 0{
                return MiniMaxNode(sbe: sbe(state: state, isAiTurn: isAiTurn) * ply, action: nil)
            }
            // End Game (Enemy Lose) WIN
            if state.e1 == state.e2 && state.e1 == 0{
                return MiniMaxNode(sbe: 100 * ply, action: nil)
            }
            // End Game (Player Lose) LOSE
            if state.p1 == state.p2 && state.p1 == 0{
                return MiniMaxNode(sbe: 100 * -ply, action: nil)
            }
            // Action
            var point = 100000
            point = isAiTurn ? -point : point 
            var retAction: HandAction? = nil
            for act in HandAction.allAction{
                var tempState = state
                if !isAiTurn{
                    tempState.swap()
                }
                var resultAction = tempState.doAction(action: act)
                if resultAction.isValid{
                    var newState = resultAction.newState
                    if !isAiTurn{
                        newState.swap()
                    }
                    var tempPoint: Int = miniMax(ply: ply-1, state: newState, turn: 1-turn).sbe
                    // Random Movement if has same point / sbe
                    let isSameAndRandomize = point == tempPoint && Int.random(in: 1...10) < 5
                    // Check Max Trigger or MinTrigger
                    let isAiAndMaxTrigger = isAiTurn && (point < tempPoint || isSameAndRandomize)
                    let isNotAiAndMinTrigger = !isAiTurn && (point > tempPoint || isSameAndRandomize)
                    if isAiAndMaxTrigger || isNotAiAndMinTrigger{
                        point = tempPoint
                        retAction = act
                    }
                }
            }
            return MiniMaxNode(sbe: point, action: retAction)
        }
        
        // Call MiniMax
        stateAi.swap()
        print(stateAi)
        let resultMiniMax = miniMax(ply: nPly, state: stateAi)
        print("Result: \(resultMiniMax)")
        var resultAction: ActionNode! = stateAi.doAction(action: resultMiniMax.action!)
        print("Ai Score: \(resultMiniMax.sbe)")
        print("Ai Done Moving")
        
        return resultAction!
    }
}
