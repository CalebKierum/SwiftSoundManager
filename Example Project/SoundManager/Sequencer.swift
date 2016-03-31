//
//  Sequencer.swift
//  SoundManager
//
//  Created by Caleb Kierum on 3/30/16.
//  Copyright © 2016 Broccoli Presentations. All rights reserved.
//

import Foundation


class Sequencer:NSObject {
    
    static var type:String = "Reg"
    static var mute:Bool = false
    static func begin(primary: Bool)
    {
        MusicPlayer.addTrack("s1Intro", type: "mp3")
        MusicPlayer.addTrack("s1End", type: "mp3")
        MusicPlayer.addTrack("s2Intro", type: "mp3")
        var tempSettings = SoundSettings()
        tempSettings.pan = 0.5
        tempSettings.volume = 0.8
        MusicPlayer.addTrack("s2End", type: "mp3", settings: tempSettings)
        MusicPlayer.addTrack("Death", type: "mp3")
        MusicPlayer.primaryPlaying = !primary
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "game", userInfo: nil, repeats: false) //I recommend a slight delay
    }
    static func pause()
    {
        MusicPlayer.pause()
    }
    static func resume()
    {
        MusicPlayer.resume()
    }
    static func play()
    {
        MusicPlayer.play()
    }
    static func toggle()
    {
        MusicPlayer.toggle()
    }
    static func songOver()
    {
        if (type == "Game")
        {
            MusicPlayer.setPrimary("s1End")
            MusicPlayer.setSecondary("s2End")
            play()
        }
    }
    static func death()
    {
        type = "Death"
        MusicPlayer.setPrimary("Death")
        MusicPlayer.setSecondary("")
        //MusicPlayer.setSecondary("Deathc")
        play()
    }
    static func game()
    {
        type = "Game"
        MusicPlayer.setPrimary("s1Intro")
        MusicPlayer.setSecondary("s2Intro")
        play()
    }
}