//
//  GameScene.swift
//  SoundManager
//
//  Created by Caleb Kierum on 3/30/16.
//  Copyright (c) 2016 Broccoli Presentations. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var b1 = Button(imageNamed: "play.png")
    var b2 = Button(imageNamed: "play.png")
    var b3 = Button(imageNamed: "play.png")
    
    var switchB = Button(imageNamed: "play.png")
    var death = Button(imageNamed: "play.png")
    var game = Button(imageNamed: "play.png")
    
    var width:CGFloat = 0
    var height:CGFloat = 0
    override func didMoveToView(view: SKView) {
        width = view.frame.size.width
        height = view.frame.size.height
        
        
        _prepB(b1)
        _prepB(b2)
        _prepB(b3)
        
        b1.position = CGPointMake(width / 4, height / 2)
        b1.text("Growl")
        b2.position = CGPointMake((width / 4) * 2, height / 2)
        b2.text("Growl2")
        b3.position = CGPointMake((width / 4) * 3, height / 2)
        b3.text("Marimba")
        
        
        _prepB(switchB)
        _prepB(death)
        _prepB(game)
        
        switchB.position = CGPointMake(width / 2, height - (height / 6))
        switchB.text("Switch!")
        death.position = CGPointMake((width / 3) * 2, height / 6)
        death.text("Death")
        game.position = CGPointMake((width / 3), height / 6)
        game.text("Game")
        
        
        Sequencer.begin(false)
        
        SoundEffects.addEffect("Growl1", fileName: "se2", type: "wav")
        var volumeDown = SoundSettings()
        volumeDown.setVolume(0.5)
        SoundEffects.addEffect("Growl2", fileName: "se3", type: "wav", settings: volumeDown)
        SoundEffects.addEffect("Marimba", fileName: "se1", type: "wav", playsFrequently: true)
    }
    
    func _prepB(obj: SKSpriteNode)
    {
        obj.size = CGSizeMake((height / 10) * 4, height / 6)
        self.addChild(obj)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = touches.first!.locationInNode(self)
        b1.checkClick(p)
        b2.checkClick(p)
        b3.checkClick(p)
        
        switchB.checkClick(p)
        game.checkClick(p)
        death.checkClick(p)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let p = touches.first!.locationInNode(self)
        if (b1.up(p))
        {
            SoundEffects.play("Growl1")
        }
        
        if (b2.up(p))
        {
            SoundEffects.play("Growl2")
        }
        
        if (b3.up(p))
        {
            SoundEffects.play("Marimba")
            print("Marimba")
        }
        
        if (switchB.up(p))
        {
            Sequencer.toggle()
        }
        
        if (game.up(p))
        {
            Sequencer.game()
        }
        
        if (death.up(p))
        {
            Sequencer.death()
        }
    }
}


class Button:SKSpriteNode {
    private var down:Bool = false
    private var label:SKLabelNode?
    
    private func text(message: String)
    {
        label?.removeFromParent()
        let newThing = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        newThing.text = message
        newThing.fontSize = self.size.height * 0.5
        newThing.fontColor = UIColor.blackColor()
        newThing.zPosition += 10
        newThing.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        newThing.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.addChild(newThing)
        label = newThing
    }
    private func checkClick(pos: CGPoint) -> Bool
    {
        if (self.alpha > 0.9)
        {
            let left = position.x - (size.width / 2.0)
            let right = position.x + (size.width / 2.0)
            let top = position.y + (size.height / 2.0)
            let bottom = position.y - (size.height / 2.0)
            
            let c1 = (left < pos.x) && (pos.x < right)
            let c2 = (bottom < pos.y) && (pos.y < top)
            
            down = c1 && c2
            return down
        }
        return false
    }
    private func shade()
    {
        if (down)
        {
            color = UIColor.blackColor()
            colorBlendFactor = 0.2
        }
    }
    private func unshade()
    {
        colorBlendFactor = 0.0
    }
    func down(pos: CGPoint)
    {
        if (checkClick(pos))
        {
            shade()
        }
    }
    func up(pos: CGPoint) -> Bool
    {
        unshade()
        if (down && checkClick(pos))
        {
            return true
        }
        return false
    }
}