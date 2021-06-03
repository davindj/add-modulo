

import AVFoundation
import SpriteKit

public class HomeScene : SKScene{
    // Enum
    enum HomeButton{
        case btnPlay
        case btnHowToPlay
        case btnAbout
        case btnEasy
        case btnMedium
        case btnHard
        case btnCancel
    }
    // Audio
    var audioHand: AVAudioPlayer?
    var audioTitle: AVAudioPlayer?
    static var audioBgm: AVAudioPlayer?
    // Status
    var isTouchPossible: Bool = true
    var activeTouch: HomeButton? = nil
    // Component
    var btnPlay: SKSpriteNode!
    var btnHowToPlay: SKSpriteNode!
    var btnAbout: SKSpriteNode!
    var labelDifficulty: SKSpriteNode!
    var btnEasy: SKSpriteNode!
    var btnMedium: SKSpriteNode!
    var btnHard: SKSpriteNode!
    var btnCancel: SKSpriteNode!
    // Title
    var playerHand: SKNode!
    var enemyHand: SKNode!
    var titleText: SKSpriteNode!
    
    public override func didMove(to view: SKView) {
        // Background
        self.makeBackground(color: #colorLiteral(red: 0.2275036573, green: 0.5323064327, blue: 0.9950136542, alpha: 1.0))
        
        // Animation Flow
            // Player Hand
            // Enemy Hand
            // Title Screen
            // Idle Screen
        
        // Start Animation
        animatePlayerHand()
    }
    
    // MARK: Animation
    func animatePlayerHand(){
        // Hand Player
        playerHand = createHand(scale: 40, position: self.middleScreen, distanceBetweenHand: 20)
        playerHand.position.x = -frame.width/2
        playerHand.position.y = -frame.height/2
        addChild(playerHand)
        
        // Animation
        let action1 = SKAction.scale(to: 30, duration: 2)
        let action2 = SKAction.move(to: CGPoint(x: frame.midX/2, y: frame.midY/2), duration: 2)
        let radian = CGPoint.zero.angle(to: CGPoint(x: frame.height, y: frame.width)).toRadian * -1
        let action3 = SKAction.rotate(toAngle: radian, duration: 2)
        let action = SKAction.group([action1, action2, action3])
        
        playerHand.run(action){
            self.animateEnemyHand()
        }
    }
    func animateEnemyHand(){
        // Hand Enemy
        enemyHand = createHand(scale: 40, position: self.middleScreen, distanceBetweenHand: 20)
        enemyHand.position.x = frame.width*3/2
        enemyHand.position.y = frame.height*3/2
        addChild(enemyHand)
        
        // Animation
        let action1 = SKAction.scale(to: -30, duration: 1)
        let action2 = SKAction.move(to: CGPoint(x: frame.width - frame.midX/2, y: frame.height - frame.midY*2/4), duration: 1)
        let radian = CGPoint.zero.angle(to: CGPoint(x: frame.height, y: frame.width)).toRadian * -1
        let action3 = SKAction.rotate(toAngle: radian, duration: 1)
        let action = SKAction.group([action1, action2, action3])
        
        enemyHand.run(action){
            self.animateTitleScreen()
        }
    }
    func animateTitleScreen(){
        // Texture
        let texture = SKTexture(image: #imageLiteral(resourceName: "ADD MODULO v2.png"))
        texture.filteringMode = SKTextureFilteringMode.nearest
        // Node
        titleText = SKSpriteNode(texture: texture)
        titleText.zPosition = 10
        titleText.alpha = 0
        titleText.position = self.middleScreen
        // Scale
        let scale_1 = frame.width * (5.0) / titleText.size.width 
        let scale_2 = frame.width * (0.9) / titleText.size.width 
        let scale_3 = frame.width * (0.9) / titleText.size.width 
        // Append To Parent
        addChild(titleText)
        
        //// Animate 1-2 Show Up
        // Perbesar Text
        let action1 = SKAction.scale(to: scale_1, duration: 0.001)
        let action2 = SKAction.group([
            // Fade In
            SKAction.fadeAlpha(to: 1, duration: 0.4),
            // Scale sebesar Layar
            SKAction.scale(to: scale_2, duration: 0.4)
        ])
        // Run action 1-2
        let action = SKAction.sequence([
            action1, action2
        ])
        titleText.run(action){ [self] in
            // Pixelate Hand
            let allHand = playerHand.children + enemyHand.children
            for hand in allHand{
                if let hnd = hand as? SKSpriteNode{
                    hnd.texture?.filteringMode = .linear
                }
            }
            // Give Particle Blast
            // code here...
            
            //// Animate 3 Translate to Top Screen
            let finalPosition = CGPoint(x: frame.midX, y: frame.height * 0.65)
            let action3 = SKAction.sequence([
                .wait(forDuration: 0.5),
                .group([
                    .scale(to: scale_3, duration: 0.5),
                    .move(to: finalPosition, duration: 0.5)
                ])
            ]) 
            titleText.run(action3){
                // Load BGM
                if HomeScene.audioBgm == nil{
                    HomeScene.audioBgm = AudioLoader.load(filename: "loading", fileType: "wav")
                    HomeScene.audioBgm?.numberOfLoops = -1
                    HomeScene.audioBgm?.volume = 0.5
                    HomeScene.audioBgm?.prepareToPlay()
                    HomeScene.audioBgm?.play()
                }
                // Load Menu
                self.animateIdleScreen()
                initMainMenu()
            }
        }
    }
    func animateIdleScreen(){
        // Particle Falling
    }
    
    // MARK: Component
    func initMainMenu(){
        // Btn Play
        btnPlay = createButton(image: #imageLiteral(resourceName: "1__#$!@%!#__start.png"))
        btnPlay.position.y = frame.height * 0.475
        addChild(btnPlay)
        
        // Btn btnHow
        btnHowToPlay = createButton(image: #imageLiteral(resourceName: "htp.png"))
        btnHowToPlay.moveBelow(targetNode: btnPlay, distance: frame.height * 0.035)
        addChild(btnHowToPlay)
        
        // Btn Exit
        btnAbout = createButton(image: #imageLiteral(resourceName: "about.png"))
        btnAbout.moveBelow(targetNode: btnHowToPlay, distance: frame.height * 0.03)
        addChild(btnAbout)
        
        // Animasi masuk
        let yNoise = frame.height * 0.02
        let closureAnimation:(TimeInterval)->SKAction = { duration in
            return .sequence([
                .wait(forDuration: duration),
                .moveBy(x: 0, y: -yNoise, duration: 0.001),
                .group([
                    .moveBy(x: 0, y: yNoise, duration: 0.5),
                    .fadeAlpha(to: 1, duration: 0.5)
                ])
            ])
        }
        btnPlay.run(closureAnimation(0))
        btnHowToPlay.run(closureAnimation(0.3))
        btnAbout.run(closureAnimation(0.6))
    }
    func deInitMainMenu(){
        let closureDeanimation: ()->SKAction = {
            return .group([
                .moveTo(x: self.frame.width * 0.25, duration: 0.3),
                .fadeAlpha(to: 0, duration: 0.3)
            ])
        }
        btnPlay.run(closureDeanimation())
        btnHowToPlay.run(closureDeanimation())
        btnAbout.run(closureDeanimation()){
            self.btnPlay.removeFromParent()
            self.btnHowToPlay.removeFromParent()
            self.btnAbout.removeFromParent()
            self.btnPlay = nil
            self.btnHowToPlay = nil
            self.btnAbout = nil
            // Call Init Diifiuclty
            self.initDifficulty()
        }
    }
    func initDifficulty(){
        func btnCreator(image: UIImage, scale: CGFloat = 0.05, positionY: CGFloat? = nil, upperNode: SKSpriteNode? = nil, distanceWithUpperNode distance: CGFloat? = nil)->SKSpriteNode{
            let btn = createButton(image: image, scale: scale)
            if let node = upperNode, let dist = distance{
                btn.moveBelow(targetNode: node, distance: dist)
            }else{
                btn.position.y = positionY!
            }
            // Append To Parent
            addChild(btn)
            return btn
        }
        labelDifficulty = btnCreator(image: #imageLiteral(resourceName: "select_difficulty.png"), positionY: frame.height * 0.5)
        btnEasy = btnCreator(image: #imageLiteral(resourceName: "easy.png"), upperNode: labelDifficulty, distanceWithUpperNode: frame.height*0.04)
        btnMedium = btnCreator(image: #imageLiteral(resourceName: "medium.png"), upperNode: btnEasy, distanceWithUpperNode: frame.height*0.030)
        btnHard = btnCreator(image: #imageLiteral(resourceName: "hard.png"), upperNode: btnMedium, distanceWithUpperNode: frame.height*0.030)
        btnCancel = btnCreator(image: #imageLiteral(resourceName: "back.png"), upperNode: btnHard, distanceWithUpperNode: frame.height*0.075)
        
        // Animate
        // Animasi masuk
        let yNoise = frame.height * 0.02
        let closureAnimation:(TimeInterval)->SKAction = { duration in
            return .sequence([
                .wait(forDuration: duration),
                .moveBy(x: 0, y: -yNoise, duration: 0.001),
                .group([
                    .moveBy(x: 0, y: yNoise, duration: 0.5),
                    .fadeAlpha(to: 1, duration: 0.5)
                ])
            ])
        }
        labelDifficulty.run(closureAnimation(0))
        btnEasy.run(closureAnimation(0.15))
        btnMedium.run(closureAnimation(0.30))
        btnHard.run(closureAnimation(0.45))
        btnCancel.run(closureAnimation(0.6))
    }
    func deInitDifficulty(){
        let closureDeanimation: ()->SKAction = {
            return .group([
                .moveTo(x: self.frame.width * 0.75, duration: 0.3),
                .fadeAlpha(to: 0, duration: 0.3)
            ])
        }
        let list_component = [labelDifficulty, btnEasy, btnMedium, btnHard, btnCancel]
        for comp in list_component{
            if let component = comp {
                component.run(closureDeanimation()){
                    if component == list_component.last{ // Last
                        // Remove from parent
                        for comp2 in list_component{
                            comp2?.removeFromParent()
                        }
                        // Remove Reference
                        self.labelDifficulty = nil
                        self.btnEasy = nil
                        self.btnMedium = nil
                        self.btnHard = nil
                        self.btnCancel = nil
                        // Call Main MEnu
                        self.initMainMenu()
                    }
                }
            }
        }
    }
    
    func createButton(image:UIImage, scale: CGFloat = 0.064, position:CGPoint? = nil, alpha:CGFloat = 0) -> SKSpriteNode{
        // Position
        let btnPosition = position ?? middleScreen
        // Texture
        let texture = SKTexture(image: image)
        texture.filteringMode = .nearest
        // Instance
        let newBtn = SKSpriteNode(texture: texture)
        // Scale
        let btnScale = frame.height * scale / newBtn.size.height
        newBtn.setScale(btnScale)
        newBtn.zPosition = 0
        newBtn.position = btnPosition
        newBtn.alpha = alpha
        return newBtn
    }
    
    func enableAllButton(){
        let list_button = [
            btnPlay,
            btnHowToPlay,
            btnAbout,
            btnEasy,
            btnMedium,
            btnHard,
            btnCancel
        ]
        for btn in list_button{
            btn?.alpha = 1
        }
    }
    
    func createHand(scale: CGFloat, position: CGPoint, distanceBetweenHand dist: CGFloat)->SKNode{
        // Hand
        let hand = SKNode()
        hand.position = position
        hand.run(.scale(to: scale, duration: 0.01))
        
        // Texture
        var texture = SKTexture(image: #imageLiteral(resourceName: "P1 1 hand right .png"))
        texture.filteringMode = SKTextureFilteringMode.nearest
        
        // left Hand
        var leftHand = SKSpriteNode(texture: texture)
        leftHand.run(.scaleX(to: -1, duration: 0.01))
        leftHand.position = CGPoint(x: -dist/2, y: 0)
        hand.addChild(leftHand)
        
        // Right Hand
        var rightHand = SKSpriteNode(texture: texture)
        rightHand.position = CGPoint(x: dist/2, y: 0)
        hand.addChild(rightHand)
        
        return hand
    }
    
    
    // MARK: Event Handler
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isTouchPossible else { return }
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        
        for node in touchedNodes{
            switch node {
            case btnPlay: activeTouch = .btnPlay
            case btnHowToPlay: activeTouch = .btnHowToPlay
            case btnAbout: activeTouch = .btnAbout
            case btnEasy: activeTouch = .btnEasy
            case btnMedium: activeTouch = .btnMedium
            case btnHard: activeTouch = .btnHard
            case btnCancel: activeTouch = .btnCancel
            default: continue 
            }
            print("Touch Began: ")
            print(activeTouch)
            // Jika ada yg disentuh maka berikan feedback
            node.alpha = 0.5
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isTouchPossible else { return }
        guard let touch = touches.first else { return }
        guard activeTouch != nil else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        
        var tempTouch: HomeButton? = nil
        for node in touchedNodes{
            switch node {
            case btnPlay: tempTouch = .btnPlay
            case btnHowToPlay: tempTouch = .btnHowToPlay
            case btnAbout: tempTouch = .btnAbout
            case btnEasy: tempTouch = .btnEasy
            case btnMedium: tempTouch = .btnMedium
            case btnHard: tempTouch = .btnHard
            case btnCancel: tempTouch = .btnCancel
            default: continue 
            }
        }
        
        // Reset Texture
        enableAllButton()
            
        // Doaction jika valid
        if tempTouch == activeTouch{
            // Check per Clicked button
            switch tempTouch {
            case .btnPlay: // Animate Easy Medium Hard
                deInitMainMenu()
            case .btnEasy:
                startGame(difficulty: .easy)
            case .btnMedium:
                startGame(difficulty: .medium)
            case .btnHard:
                startGame(difficulty: .hard)
            case .btnCancel:
                deInitDifficulty()
            case .btnHowToPlay:
                startHowToPlayPage()
            case .btnAbout:
                startAboutPage()
            default:
                break
            }
        }
        
        // Hapus Reference
        activeTouch = nil
    }
    
    // MARK: Navigation
    func startGame(difficulty: GameDifficulty){
        // Jika Navigate ke Game maka Audio dimatikan
        HomeScene.audioBgm?.stop()
        HomeScene.audioBgm = nil
        // Buat Transisi
        let transition:SKTransition = .fade(withDuration: 1)
        var choosenDifficulty: GameDifficulty = difficulty
        GameScene.difficulty = choosenDifficulty
        self.transition(toScene: GameScene(size: self.size), transition: transition)
    }
    func startAboutPage(){
        // Buat Transisi
        let transition:SKTransition = .fade(withDuration: 1)
        self.transition(toScene: AboutScene(size: self.size), transition: transition)
    }
    func startHowToPlayPage(){
        // Buat Transisi
        let transition:SKTransition = .fade(withDuration: 1)
        self.transition(toScene: HowToPlayScene(size: self.size), transition: transition)
    }
}

