
import AVFoundation
import SpriteKit

struct ReturnNode{
    var value: Float
    var childIdx: Int
}

public enum GameDifficulty{
    case easy
    case medium
    case hard
}

public class GameScene : SKScene{
    // Static
    static var difficulty: GameDifficulty = .easy
    // Sound Handler
    var audioReady: AVAudioPlayer?
    var audioGo: AVAudioPlayer?
    var audioBgm: AVAudioPlayer?
    var audioGameOver: AVAudioPlayer?
    var audioWinLose: AVAudioPlayer?
    var audioBgmWinLose: AVAudioPlayer?
    //// Component
    // Hand
    var playerLeftHand: SKSpriteNode!
    var playerRightHand: SKSpriteNode!
    var enemyLeftHand: SKSpriteNode!
    var enemyRightHand: SKSpriteNode!
    // Button Action
    var btnParent: SKNode!
    var btnActionLeft1: SKSpriteNode!
    var btnActionLeft2: SKSpriteNode!
    var btnActionMiddle: SKSpriteNode!
    var btnActionMiddle1: SKSpriteNode!
    var btnActionMiddle2: SKSpriteNode!
    var btnActionRight1: SKSpriteNode!
    var btnActionRight2: SKSpriteNode!
    var actionButtons: [SKSpriteNode?] {
        [btnActionLeft1, btnActionLeft2, 
         btnActionMiddle,btnActionMiddle1,btnActionMiddle2,
         btnActionRight1, btnActionRight2]
    }
    var titleDifficulty: SKSpriteNode!
    // State
    var state: HandState!
    var isTouchable: Bool = false
    var touchedNode: SKSpriteNode? 
    var touchedAction: HandAction!
    var actionParameter: Int = -1
    var isAlreadyEnd: Bool = false
    var endNode: SKNode?
    // Texture
    let handTextures = [
        SKTexture(image: #imageLiteral(resourceName: "P1 0 hand right .png")), 
        SKTexture(image: #imageLiteral(resourceName: "P1 1 hand right .png")),
        SKTexture(image: #imageLiteral(resourceName: "P1 2 hand right .png")),
        SKTexture(image: #imageLiteral(resourceName: "P1 3 hand right .png")),
        SKTexture(image: #imageLiteral(resourceName: "P1 4 hand right .png")),
        SKTexture(image: #imageLiteral(resourceName: "P1 5 hand right .png"))
    ]
    // Constant
    public override func didMove(to view: SKView) {
        // Background
        makeBackground(color: #colorLiteral(red: -0.04286057502031326, green: 0.540793240070343, blue: 1.028246521949768, alpha: 1.0))
        
        //// Title Difficulty
        // Texture
        let imageDifficulty = GameScene.difficulty == .easy ? #imageLiteral(resourceName: "easy.png") : GameScene.difficulty == .medium ? #imageLiteral(resourceName: "medium.png") : #imageLiteral(resourceName: "hard.png")
        let textureDifficulty = SKTexture(image: imageDifficulty)
        textureDifficulty.filteringMode = .nearest
        // Node
        titleDifficulty = SKSpriteNode(texture: textureDifficulty)
        // Scale
        titleDifficulty.setScale(frame.height * 0.05 / titleDifficulty.size.height)
        titleDifficulty.zPosition = 0
        titleDifficulty.alpha = alpha
        addChild(titleDifficulty)
        // Position
        titleDifficulty.position.x = frame.midX
        titleDifficulty.position.y = frame.midY
        // Animate
        animatePlayerHand()
    }
    
    // MARK: Animate
    func animatePlayerHand(){
        // Init
        playerLeftHand = createHand(scale: 15, position: middleScreen, isLeftHand: true)
        playerRightHand = createHand(scale: 15, position: middleScreen, isLeftHand: false)
        // Hand Position
        let yHand: CGFloat = -playerLeftHand.size.height/2
        let xHandDistance: CGFloat = frame.width * 0.1
        playerLeftHand.position.y = yHand
        playerLeftHand.position.x = frame.midX - playerLeftHand.size.width/4 -  xHandDistance/2
        playerRightHand.position.y = yHand
        playerRightHand.position.x = frame.midX + playerRightHand.size.width/4 + xHandDistance/2
        // Add to Child
        addChild(playerLeftHand)
        addChild(playerRightHand)
        // Animate
        let yTarget: CGFloat = frame.height * 0.2
        
        playerLeftHand.run(.moveTo(y: yTarget, duration: 0.5))
        playerRightHand.run(.moveTo(y: yTarget, duration: 0.5)){
            self.animateEnemyHand()
        }
    }
    func animateEnemyHand(){
        // Init
        enemyLeftHand = createHand(scale: 15, position: middleScreen, isLeftHand: true, isEnemy: true)
        enemyRightHand = createHand(scale: 15, position: middleScreen, isLeftHand: false, isEnemy: true)
        // Hand Position
        let yHand: CGFloat = enemyLeftHand.size.height/2 + frame.height
        let xHandDistance: CGFloat = frame.width * 0.075
        enemyLeftHand.position.y = yHand
        enemyLeftHand.position.x = frame.midX - enemyLeftHand.size.width/4 -  xHandDistance/2
        enemyRightHand.position.y = yHand
        enemyRightHand.position.x = frame.midX + enemyRightHand.size.width/4 + xHandDistance/2
        // Add to Child
        addChild(enemyLeftHand)
        addChild(enemyRightHand)
        // Animate
        let yTarget: CGFloat = frame.height * 0.8
        
        enemyLeftHand.run(.moveTo(y: yTarget, duration: 0.5))
        enemyRightHand.run(.moveTo(y: yTarget, duration: 0.5)){
            self.animateStart()
        }
    }
    func animateStart(){
        // Background Animation
        let bgSize = CGSize(width: frame.width, height: frame.height*0.3)
        let darkBg = SKSpriteNode(color: #colorLiteral(red: 0.0, green: 0.2136589885, blue: 0.2883136272, alpha: 1.0), size: bgSize)
        darkBg.alpha = 0.0
        darkBg.position = middleScreen
        addChild(darkBg)
        // Title Start Animation
        darkBg.run(.fadeAlpha(to: 0.77, duration: 0.3)){ [self] in
            // Setelah Fade In, Show Ready Text
            let texture: SKTexture = SKTexture(image: #imageLiteral(resourceName: "ready.png"))
            texture.filteringMode = .nearest
            let readyNode = SKSpriteNode(texture: texture)
            readyNode.position = self.middleScreen
            let readyScale = self.frame.height * (0.225) / readyNode.size.height
            let readyScaleFinal = self.frame.height * (0.25) / readyNode.size.height
            self.addChild(readyNode)
            // Make Sound Ready
            audioReady = AudioLoader.load(filename: "Ready", fileType: "wav")
            audioReady?.play()
            
            // Animating Ready ?
            readyNode.run(.sequence([
                .scale(to: readyScale, duration: 0.5),
                .scale(to: readyScaleFinal, duration: 1.5)
            ]))
            darkBg.run(.group([
                .resize(toHeight: self.frame.height*0.4, duration: 2),
                .fadeAlpha(to: 0.9, duration: 2)
            ])){
                darkBg.run(.group([
                    .fadeAlpha(to: 0, duration: 0.6),
                    .scale(by: 4, duration: 0.3)
                ]))
                readyNode.run(.group([
                    .fadeAlpha(to: 0, duration: 0.3),
                    .scale(by: 2, duration: 0.3)
                ]))
                //// Animating Start Node
                let texture: SKTexture = SKTexture(image: #imageLiteral(resourceName: "START.png"))
                texture.filteringMode = .nearest
                let startNode = SKSpriteNode(texture: texture)
                startNode.position = self.middleScreen
                let startScale = self.frame.height * (1.25) / startNode.size.height
                let startScaleFinal = self.frame.height * (0.275) / startNode.size.height
                startNode.setScale(startScale)
                startNode.alpha = 0
                self.addChild(startNode)
                // Staert SOunf
                audioGo = AudioLoader.load(filename: "Go", fileType: "wav")
                audioGo?.play()
                // Animate
                startNode.run(.sequence([
                    .group([
                        .fadeAlpha(by: 1, duration: 0.3),
                        .scale(to: startScaleFinal, duration: 0.3)
                    ]),
                    .wait(forDuration: 0.5),
                    .fadeAlpha(to: 0, duration: 0.1)
                ])){
                    // Remove All Animation Node
                    darkBg.removeFromParent()
                    readyNode.removeFromParent()
                    startNode.removeFromParent()
                    // Call Game Init
                    self.showOption()
                    self.init_game()
                    // Loop Main Music
                    audioBgm = AudioLoader.load(filename: "Sunstrider", fileType: "wav")
                    audioBgm?.numberOfLoops = -1
                    audioBgm?.prepareToPlay()
                    audioBgm?.play()
                }
            }
        }
    }
    
    // MARK: Initializer
    func init_game(){
        // Init Variable
        state = HandState(e1: 1, e2: 1, p1: 1, p2: 1)
        isTouchable = true
    }
    
    // MARK: Component
    func createHand(scale: CGFloat, position: CGPoint, isLeftHand: Bool, isEnemy: Bool = false) -> SKSpriteNode{
        // Texture
        var texture = SKTexture(image: #imageLiteral(resourceName: "P1 1 hand right .png"))
        texture.filteringMode = SKTextureFilteringMode.nearest
        
        // Hand
        var hand = SKSpriteNode(texture: texture)
        hand.position = position
        hand.setScale(scale)
        hand.xScale *= isLeftHand ? -1 : 1
        hand.yScale *= isEnemy ? -1 : 1
        
        return hand
    }
    
    func showOption(){
        // Create Parent Node
        btnParent = SKNode()
        btnParent.position.x = .zero
        btnParent.position.y = frame.height * 0.15
        btnParent.alpha = 0
        addChild(btnParent)
        // Function Button Creat
        func buttonCreator(image: UIImage, xButton: (CGSize)->CGFloat) -> SKSpriteNode{
            // Texture
            let texture = SKTexture(image: image)
            texture.filteringMode = .nearest
            // Create Node
            let node = SKSpriteNode(texture: texture)
            node.setScale(frame.width / 10 / node.size.width)
            node.position.x = xButton(node.size)
//              node.position.x = frame.width / 4 - node.size.width / 2 - 20
            btnParent.addChild(node)
            return node
        }
        btnActionLeft2 = buttonCreator(image: #imageLiteral(resourceName: "1b.png")){ node_size in
            self.playerLeftHand.position.x - self.playerLeftHand.size.width / 4 - node_size.width / 2
        }
        btnActionLeft1 = buttonCreator(image: #imageLiteral(resourceName: "1a.png")){ node_size in
            self.btnActionLeft2.position.x - node_size.width - 40
        }
        btnActionMiddle = buttonCreator(image: HandImage.getImage(leftHand: 0, rightHand: 2)){ node_size in
            self.frame.midX
        }
        btnActionRight1 = buttonCreator(image: #imageLiteral(resourceName: "2a.png")){ node_size in
            self.playerRightHand.position.x + self.playerRightHand.size.width / 4 + node_size.width / 2
        }
        btnActionRight2 = buttonCreator(image: #imageLiteral(resourceName: "2b.png")){ node_size in
            self.btnActionRight1.position.x + node_size.width + 40
        }
        // Init Button Middle
        btnActionMiddle1 = buttonCreator(image: #imageLiteral(resourceName: "2a.png")){ node_size in
            self.btnActionLeft2.position.x
        }
        btnActionMiddle2 = buttonCreator(image: #imageLiteral(resourceName: "2b.png")){ node_size in
            self.btnActionRight1.position.x
        }
        btnActionMiddle1.position.y = -frame.midY
        btnActionMiddle2.position.y = -frame.midY
        
        // Animate
        btnParent.run(.sequence([
            .moveBy(x: 0, y: -frame.height*0.05, duration: 0.01),
            .group([
                .fadeAlpha(to: 1, duration: 0.5),
                .moveBy(x: 0, y: frame.height*0.05, duration: 0.5)
            ])
        ]))
    }
    // Transition button
    func disableAllButton(){
        // Hide All Middle Action Button
        for btn in [
            btnActionMiddle,
            btnActionMiddle1,
            btnActionMiddle2
        ]{
            btn?.run(.group([
                .fadeAlpha(to: 0.5, duration: 0.3),
                .moveTo(y: -frame.midY, duration: 0.3)
            ]))
        }
        // Disable All button using alpha
        for btn in [
            btnActionLeft1,
            btnActionLeft2,
            btnActionRight1,
            btnActionRight2
        ]{
            btn?.run(.group([
                .fadeAlpha(to: 0.5, duration: 0.3),
                .moveTo(y: 0, duration: 0.3)
            ]))
        }
    }
    func enableAllButton(){
        // Berikan fade tergantung kondisinya bisa atau tidak
        let closureFadeIn: (Bool)->SKAction = { isActive in
            .group([
                .fadeAlpha(to: isActive ? 1 : 0.5, duration: 0.3),
                .moveTo(y: 0, duration: 0.3)
            ])
        }
        btnActionLeft1.run(closureFadeIn(state.isPossibleAttack(action: .attackLeftWithLeft)))
        btnActionLeft2.run(closureFadeIn(state.isPossibleAttack(action: .attackRightWithLeft)))
        btnActionRight1.run(closureFadeIn(state.isPossibleAttack(action: .attackLeftWithRight)))
        btnActionRight2.run(closureFadeIn(state.isPossibleAttack(action: .attackRightWithRight)))
        
        // Middle Check
        showMiddleActionButton()
        
        isTouchable = true
        touchedAction = nil
    }
    func showMiddleActionButton(){
        // Check Distribute.. 
        if state.isDistributable1 || state.isDistributable2{
            // Ganti Image Tergantung apakah distribute level
            if state.isDistributable2{
                btnActionMiddle.texture = SKTexture(image: #imageLiteral(resourceName: "split 3.png"))
                btnActionMiddle.texture?.filteringMode = .nearest
            }else{ // Distribute 1
                let result = state.distribute()[0]
                print(state)
                print(result)
                // Texture
                let newImage = HandImage.getImage(leftHand: result[0], rightHand: result[1])
                let newTexture = SKTexture(image: newImage)
                newTexture.filteringMode = .nearest
                btnActionMiddle.texture = newTexture
            }
            // Show button middle
            btnActionMiddle.run(.group([
                .fadeAlpha(to: 1, duration: 0.3),
                .moveTo(y: 0, duration: 0.3)
            ]))
        }
    }
    func toggleMiddleActionLeftRight(isComing: Bool){
        // Button Left Right
        for btn in [
            btnActionLeft1,
            btnActionLeft2,
            btnActionRight1,
            btnActionRight2
        ]{
            btn?.run(.group([
                .fadeAlpha(to: isComing ? 0 : 1, duration: 0.3),
                .moveTo(y: isComing ? -frame.midY : 0, duration: 0.3)
            ]))
        }
        // Button Action Middle Left Right
        // SetTexture jika isComing
        if isComing{
            let distributeResult = state.distribute()
            let left1 = distributeResult[0][0]
            let right1 = distributeResult[0][1]
            let left2 = distributeResult[1][0]
            let right2 = distributeResult[1][1]
            btnActionMiddle1.texture = SKTexture(image: HandImage.getImage(leftHand: left1, rightHand: right1))
            btnActionMiddle1.texture?.filteringMode = .nearest
            btnActionMiddle2.texture = SKTexture(image: HandImage.getImage(leftHand: left2, rightHand: right2))
            btnActionMiddle2.texture?.filteringMode = .nearest
        }
        for btn in [
            btnActionMiddle1,
            btnActionMiddle2
        ]{
            btn?.run(.group([
                .fadeAlpha(to: !isComing ? 0 : 1, duration: 0.3),
                .moveTo(y: !isComing ? -frame.midY : 0, duration: 0.3)
            ]))
        }
        
        // Ubah Middle Image
        btnActionMiddle.texture = SKTexture(image: isComing ? #imageLiteral(resourceName: "x.png") : #imageLiteral(resourceName: "split 3.png"))
    }
    
    
    // MARK: Display
    func getHandTexture(idx: Int) -> SKTexture{
        let texture: SKTexture = handTextures[idx].copy() as! SKTexture
        texture.filteringMode = .nearest
        return texture
    }
    func displayState(){
        playerLeftHand.texture = getHandTexture(idx: state.p1)
        playerRightHand.texture = getHandTexture(idx: state.p2)
        enemyLeftHand.texture = getHandTexture(idx: state.e1)
        enemyRightHand.texture = getHandTexture(idx: state.e2)
    }
    
    // MARK: Event Battle
    func animateAttack(attacker node1: SKSpriteNode, target node2: SKSpriteNode, isEnemy: Bool=false){
        let attacker = node1
        let defender = node2
        
        attacker.zPosition = 10
        // Position
        let startPosition = attacker.position 
        var targetPosition = defender.position
        targetPosition.y -= defender.size.height/4
        // Rotation
        let rotation = (startPosition.angle(to: targetPosition)+(isEnemy ? -270 : -90)).toRadian
        let action: SKAction = .group([
            .rotate(toAngle: rotation, duration: 0.3),
            .move(to: targetPosition, duration: 0.3)
        ]) 
        action.timingMode = .easeIn
        attacker.run(action){
            // Setelah tersentuh update Texture
            self.displayState()
            // Action Scale 
            defender.run(.sequence([
                .scale(by: CGFloat(1.5/1), duration: 0.1),
                .scale(by: CGFloat(1/1.5), duration: 0.11)
            ]))
            // Action mundur
            let action2: SKAction = .group([
                .rotate(toAngle: CGFloat(0).toRadian, duration: 0.3),
                .move(to: startPosition, duration: 0.3)
            ])
            attacker.run(action2){
                attacker.zPosition = 0
                self.endOfAction(isEnemy: isEnemy)
            }
        }
    }
    func animateMerge(isEnemy: Bool){
        let node1: SKSpriteNode = isEnemy ? enemyLeftHand : playerLeftHand
        let node2: SKSpriteNode = isEnemy ? enemyRightHand : playerRightHand
        //
        let durationStart: TimeInterval = 0.15
        let angle = 15
        let xStartNode1 = node1.position.x
        let xStartNode2 = node2.position.x
        let xTargetNode1 = frame.midX
        let xTargetNode2 = frame.midX
        // Animate
        let action11: SKAction = .group([
            .rotate(toAngle: CGFloat(-angle).toRadian, duration: durationStart),
            .moveTo(x: xTargetNode1, duration: durationStart)
        ])
        let action21: SKAction = .group([
            .rotate(toAngle: CGFloat(angle).toRadian, duration: durationStart),
            .moveTo(x: xTargetNode2, duration: durationStart)
        ])
        node1.run(action11)
        node2.run(action21){
            // Setelah tersentuh update Texture
            self.displayState()
            // Kembali
            let action12: SKAction = .group([
                .rotate(toAngle: CGFloat(0).toRadian, duration: durationStart),
                .moveTo(x: xStartNode1, duration: durationStart)
            ])
            let action22: SKAction = .group([
                .rotate(toAngle: CGFloat(0).toRadian, duration: durationStart),
                .moveTo(x: xStartNode2, duration: durationStart)
            ])
            node1.run(action12)
            node2.run(action22){
                self.endOfAction(isEnemy: isEnemy)
            }
        }
    }
    func doAction(isEnemy: Bool){
        // Disable Touchable
        isTouchable = false
        print("IsEnemy: \(isEnemy), Doaction: \(touchedAction)")
        if isEnemy{ // Jika enemy
            state.swap()
        }
        let resultAction = state.doAction(action: touchedAction)
        state = resultAction.newState
        if isEnemy{
            state.swap()
        }
        if touchedAction == HandAction.attackLeftWithLeft{
            self.animateAttack(
                attacker: isEnemy ? enemyLeftHand : playerLeftHand, 
                target: !isEnemy ? enemyLeftHand : playerLeftHand, 
                isEnemy: isEnemy
            )
        }else if touchedAction == HandAction.attackLeftWithRight{
            self.animateAttack(
                attacker: isEnemy ? enemyRightHand : playerRightHand, 
                target: isEnemy ? playerLeftHand : enemyLeftHand, 
                isEnemy: isEnemy
            )
        }else if touchedAction == HandAction.attackRightWithLeft{
            self.animateAttack(
                attacker: isEnemy ? enemyLeftHand : playerLeftHand, 
                target: isEnemy ? playerRightHand : enemyRightHand, 
                isEnemy: isEnemy
            )
        }else if touchedAction == HandAction.attackRightWithRight{
            self.animateAttack(
                attacker: isEnemy ? enemyRightHand : playerRightHand, 
                target: !isEnemy ? enemyRightHand : playerRightHand, 
                isEnemy: isEnemy
            )
        }else if touchedAction == HandAction.distribute1{
            self.animateMerge(isEnemy: isEnemy)
        }else if touchedAction == HandAction.distribute2{
            self.animateMerge(isEnemy: isEnemy)
        }
    }
    func displayEndScene(isPlayerWin: Bool){
        let winnerLeftHand: SKSpriteNode = isPlayerWin ? playerLeftHand : enemyLeftHand
        let winnerRightHand: SKSpriteNode = isPlayerWin ? playerRightHand : enemyRightHand
        let loserLeftHand: SKSpriteNode = !isPlayerWin ? playerLeftHand : enemyLeftHand
        let loserRightHand: SKSpriteNode = !isPlayerWin ? playerRightHand : enemyRightHand
        // Animate Action Button keluar
        btnParent.run(.sequence([
            .group([
                .fadeAlpha(to: 0, duration: 0.6),
                .moveTo(y: 0, duration: 0.6)
            ])
        ]))
        // Animate Kalah keluar dari Screen
        let yLoser = isPlayerWin ? loserLeftHand.size.height + frame.height : -loserLeftHand.size.height
        loserLeftHand.run(.moveTo(y: yLoser, duration: 1))
        loserRightHand.run(.moveTo(y: yLoser, duration: 1))
        // BGM Dimatikan perlahan
        func turnDownBgm(){
            if audioBgm?.volume ?? 0 > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)){
                    self.audioBgm?.volume -= 0.1
                    turnDownBgm()
                }
            }else{
                audioBgm?.stop()
            }
        }
        turnDownBgm()
        // Animate Pemenang ke Tengah
        winnerLeftHand.run(.moveTo(y: frame.midY, duration: 1))
        winnerRightHand.run(.moveTo(y: frame.midY, duration: 1)){ [self] in
            // Background Animation sama seperti Enter Game Animation
            let bgSize = CGSize(width: frame.width, height: frame.height*0.3)
            let darkBg = SKSpriteNode(color: #colorLiteral(red: -0.0893220528960228, green: 0.2183276116847992, blue: 0.29596632719039917, alpha: 1.0), size: bgSize)
            darkBg.alpha = 0.0
            darkBg.position = middleScreen
            addChild(darkBg)
            // Title Game Over
            darkBg.run(.fadeAlpha(to: 0.77, duration: 0.3)){
                // Setelah Fade In, Show Ready Text
                let texture: SKTexture = SKTexture(image: #imageLiteral(resourceName: "game_over.png"))
                texture.filteringMode = .nearest
                let gameOverNode = SKSpriteNode(texture: texture)
                gameOverNode.position = self.middleScreen
                let gameOverScale = self.frame.width * (0.75) / gameOverNode.size.width
                let gameOverScaleFinal = self.frame.width * (0.80) / gameOverNode.size.width
                self.addChild(gameOverNode)
                // Sound Game Over
                audioGameOver = AudioLoader.load(filename: "Game", fileType: "wav")
                audioGameOver?.play()
                // Animating Game Over
                gameOverNode.run(.sequence([
                    .scale(to: gameOverScale, duration: 0.5),
                    .scale(to: gameOverScaleFinal, duration: 1.5)
                ]))
                darkBg.run(.group([
                    .resize(toHeight: self.frame.height*0.4, duration: 2),
                    .fadeAlpha(to: 0.9, duration: 2)
                ])){
                    let extraAction: SKAction = isPlayerWin ? .colorize(with: #colorLiteral(red: 0.9999018311500549, green: 1.0000687837600708, blue: 0.9998798966407776, alpha: 1.0), colorBlendFactor: 1, duration: 0.3) : .unhide()
                    darkBg.run(.group([
                        extraAction,
                        .fadeAlpha(to: 0.5, duration: 0.6),
                        .scale(by: 4, duration: 0.3)
                    ]))
                    gameOverNode.run(.group([
                        .fadeAlpha(to: 0, duration: 0.3),
                        .scale(by: 2, duration: 0.3)
                    ]))
                    //// Animating Start Node
                    let texture: SKTexture = SKTexture(image: isPlayerWin ? #imageLiteral(resourceName: "win12.png") : #imageLiteral(resourceName: "lose cry7.png"))
                    texture.filteringMode = .nearest
                    let startNode = SKSpriteNode(texture: texture)
                    startNode.position = self.middleScreen
                    startNode.position.x -= startNode.size.width / 10
                    let startScale = self.frame.height * (1.25) / startNode.size.height
                    let startScaleFinal = self.frame.height * (0.275) / startNode.size.height
                    startNode.setScale(startScale)
                    startNode.alpha = 0
                    self.addChild(startNode)
                    // Make You win or You lose sound
                    if isPlayerWin{
                        audioWinLose = AudioLoader.load(filename: "Wins!", fileType: "wav")
                        audioWinLose?.play()
                    }else{
                        audioWinLose = AudioLoader.load(filename: "Loses", fileType: "wav")
                        audioWinLose?.play()
                    }
                    // Animate Ending
                    startNode.run(.sequence([
                        .group([
                            .fadeAlpha(by: 1, duration: 0.3),
                            .scale(to: startScaleFinal, duration: 0.3)
                        ]),
                        .wait(forDuration: 2),
//                          .fadeAlpha(to: 0, duration: 0.1)
                    ])){
                        // Show bgm Win Lose
                        audioBgmWinLose = AudioLoader.load(filename: isPlayerWin ? "Victory! All Clear" : "Fallen in Battle", fileType: "wav")
                        audioBgmWinLose?.play()
                        // Show Ending BUtton
                        animateEndingButton(isPlayerWin: isPlayerWin)
                    }
                }
            }
        }
    }
    func animateEndingButton(isPlayerWin: Bool){ // Retry & Back to Main Menu
        // Function Create SpriteNode
        func spriteGenerator(name: String, image: UIImage, positionX x: CGFloat) -> SKSpriteNode {
            let node = SKSpriteNode(texture: SKTexture(image: image))
            node.texture?.filteringMode = .nearest
            node.setScale(frame.width/8/node.size.width)
            node.position = middleScreen
            node.position.x = x
            node.position.y = frame.height * 0.2
            node.alpha = 0
            node.name = name
            return node
        }
        if !isPlayerWin{
            let retryNode = spriteGenerator(name:"retry", image: #imageLiteral(resourceName: "try_again.png"), positionX: frame.width * 3 / 8)
            let giveUpNode = spriteGenerator(name:"giveup", image: #imageLiteral(resourceName: "give_up.png"), positionX: frame.width * 5 / 8)
            addChild(retryNode)
            addChild(giveUpNode)
            retryNode.run(.group([
                .moveTo(y: frame.height * 0.25, duration: 0.4),
                .fadeAlpha(to: 1, duration: 0.4)
            ]))
            giveUpNode.run(.group([
                .moveTo(y: frame.height * 0.25, duration: 0.4),
                .fadeAlpha(to: 1, duration: 0.4)
            ])){
                self.isAlreadyEnd = true
            }
        }else{
            let continueNode = spriteGenerator(name: "continue", image: #imageLiteral(resourceName: "continue.png"), positionX: frame.midX)
            addChild(continueNode)
            continueNode.run(.group([
                .moveTo(y: frame.height * 0.25, duration: 0.4),
                .fadeAlpha(to: 1, duration: 0.4)
            ])){
                self.isAlreadyEnd = true
            }
        }
    }
    func endOfAction(isEnemy: Bool){
        // Pengecekan Game Over
        if state.isEnemyWin || state.isPlayerWin{
            displayEndScene(isPlayerWin: state.isPlayerWin)
        }else if !isEnemy{
            // Giliran Musuh
            DispatchQueue.main.async {
                // Panggil AI Enemy
                let resultMove = self.state.aiMove(difficulty: GameScene.difficulty)
                self.touchedAction = resultMove.action
                self.doAction(isEnemy: true)
            }
        }else{ // Jika Player maka
            // Activate Butotn
            enableAllButton()
        }
    }
    
    // MARK: Event Handler
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isTouchable || isAlreadyEnd else { return }
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        for node in touchedNodes{
            // Jika ending
            if isAlreadyEnd{
                switch node.name {
                case "continue": endNode = node
                case "retry": endNode = node
                case "giveup": endNode = node
                default: continue
                }
                print("Node Detected")
                endNode?.alpha = 0.5
                continue
            }
            // Contain In List Action
            switch node {
            case btnActionLeft1 where state.doAction(action: .attackLeftWithLeft).isValid: break
            case btnActionLeft2 where state.doAction(action: .attackRightWithLeft).isValid: break
            case btnActionRight1 where state.doAction(action: .attackLeftWithRight).isValid: break
            case btnActionRight2 where state.doAction(action: .attackRightWithRight).isValid: break
            case btnActionMiddle where state.doAction(action: .distribute1).isValid: break
            case btnActionMiddle1 where state.doAction(action: .distribute2).isValid: break
            case btnActionMiddle2 where state.doAction(action: .distribute2).isValid: break
            default:
                continue 
            }
            touchedNode = node as! SKSpriteNode
            if node.alpha == 1 {
                node.alpha = 0.5
            }
        }
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isTouchable || isAlreadyEnd else { return }
        guard let touch = touches.first else { return }
        guard let touchedComp = isAlreadyEnd ? SKNode() : touchedNode else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        
        var stateIdx = -1
        // 0 Action biasa
        // 1 Buka Middle
        // 2 Close Middle
        var handAction: HandAction?
        for node in touchedNodes{
            // Jika ending
            if isAlreadyEnd{
                var idxEndingChoice: Int = -1
                switch node.name {
                case "continue": idxEndingChoice = 0
                case "retry": idxEndingChoice = 1
                case "giveup": idxEndingChoice = 2
                default: continue
                }
                
                if node == endNode{
                    if idxEndingChoice == 0 || idxEndingChoice == 2{ // Back to home screen
                        print("Back to home sreen")
                        let color: UIColor = idxEndingChoice == 2 ? #colorLiteral(red: 0.0, green: 0.2136589885, blue: 0.2883136272, alpha: 1.0) : #colorLiteral(red: 0.9999018311500549, green: 1.0000687837600708, blue: 0.9998798966407776, alpha: 1.0)
                        let transit: SKTransition = .fade(with: color, duration: 2)
                        self.transition(toScene: HomeScene(size: self.size), transition: transit)
                    }else if idxEndingChoice == 1{ // Go Play Again
                        print("Go Play Again")
                        self.transition(toScene: GameScene(size: self.size), transition: .fade(withDuration: 1))
                    }
                }
                continue
            }
            // Contain In List Action
            switch node {
            case btnActionLeft1: handAction = .attackLeftWithLeft
            case btnActionLeft2: handAction = .attackRightWithLeft
            case btnActionRight1: handAction = .attackLeftWithRight
            case btnActionRight2: handAction = .attackRightWithRight
            case btnActionMiddle: break
            case btnActionMiddle1: handAction = .distribute1
            case btnActionMiddle2: handAction = .distribute2
            default:
                continue 
            }
            let tempNode = node as! SKSpriteNode
            if tempNode == touchedNode {
                if handAction != nil{ // Jika nyerang
                    // check apakah action valid
                    if state.doAction(action: handAction!).isValid{
                        stateIdx = 0
                    }
                }else{ // Jika middlebutton
                    // Check distribute level
                    if state.isDistributable2{
                        // Split button
                        stateIdx = 1
                    }else if state.isDistributable1{ // Nyerang
                        handAction = .distribute1
                        stateIdx = 0
                    }
                }
            }
        }
        // Jika Ending
        if isAlreadyEnd{
            endNode?.alpha = 1
            endNode = nil
            return
        }
        // Reset Alpha
        touchedNode?.alpha = 1
        // Reset Touched Action
        touchedNode = nil
        // Jalankan Action jika ada
        switch stateIdx {
        case 0: // Attck
            touchedAction = handAction
            // Sblm do Action disable button
            disableAllButton()
            doAction(isEnemy: false)
        case 1: // Buka Middle
            toggleMiddleActionLeftRight(isComing: true)
        case 2: // Close Middle
            toggleMiddleActionLeftRight(isComing: false)
        default:
            print("")
        }
    }
}
