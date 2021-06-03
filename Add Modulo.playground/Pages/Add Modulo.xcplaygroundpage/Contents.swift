/*
 ==============
 Introduction
 ==============
 Hi Welcome to ADD MODULO Swift Playground
 to Experience Playground, you can directly Run the code
 also dont forget to turn off "Enable Results"
 
 =======
 About
 =======
 Hello my name is Davin Djayadi and currently Im 20 years old. 
 I’m a computer science student in Sekolah Tinggi Teknik Surabaya (STTS) Indonesia and also member of Apple Developer Academy 2021 Indonesia @UC. 
 For my WWDC 2K21 Swift Student Challenge submission, I created a Strategy Game called Add Modulo. Add Modulo is game that teaches player about basic Addition, Modulo operator and Strategy Thinking. Add Modulo itself is based on Indonesia Local Children's game called "Tambah Tambahan" and also a variant of the Chopstick Game. In Indonesia, this game is indeed famous, but only among certain ages. All Indonesians born around 2000 know this game, but the rest who weren't born around 2000 tend not to know this game. 
 By Making this game I wanted to educate children around the world, and also preserve this local game to the world.
 
 =============
 How to Play
 =============
 1. Player Choose Action
    1.1 Tap / Addition
        Player add number of selected hand 
        to one of Enemy's hand
    1.2 Distribute
        Player distribute number in his hand
        example: 1 2 become 0 3
 2. Enemy Choose Action (Same as Player Action)
 3. Repeat game until player / enemy 
    get eliminated
 
 ======
 Rules
 ======
 - Player get eliminated when the number
    on both of his hand is 0
 - Player can only add using non zero hand
 - Player can only add opponent's non zero hand
 - If number on a hand is greater or equal than 5
    then the number become = number mod 5
    example: 
        6 become 1 
        5 become 0
 - Player cant swap number of hand.
    example: 3 0 become 0 3
 
 ============
 Disclaimer
 ============
 For sound assets, its not made by me, I take the asset
 in the online marketplace called itch.io
 
 Beside sound assets, all assets including image are made by me
 
 ====
 Thank you for reading this. Enjoy the Game :D
 - Davin
 */

//#-hidden-code
import SpriteKit
import PlaygroundSupport
import UIKit

let skView = SKView(frame: .zero)

let gameScene = HomeScene(size: UIScreen.main.bounds.size)
gameScene.scaleMode = .aspectFill
skView.presentScene(gameScene)

//#-hidden-code
//#-end-hidden-code
//#-end-hidden-code
PlaygroundPage.current.liveView = skView 
PlaygroundPage.current.wantsFullScreenLiveView = true
