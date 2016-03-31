//
//  SoundManager.swift
//  Sounds
//
//  Created by Caleb Kierum on 3/26/16.
/*The MIT License (MIT)

Copyright (c) 2016 CalebKierum

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.*/

import Foundation
import AVFoundation

struct SoundSettings {
    var volume:Float = 1.0
    var pan:Float = 0.0
    var rate:Float = 1.0
    
    mutating func setVolume(val: Float)
    {
        volume = val
    }
    mutating func setPan(val: Float)
    {
        pan = val
    }
    mutating func setRate(val: Float)
    {
        rate = val
    }
}

class SoundManager: NSObject {
    static var initialized:Bool = false
    static private var muteHint = false
    static var mute = false
    
    static func start()
    {
        initialized = true
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch _
        {
            fatalError("Audio Session Couldn't begin")
        }
        muteHint = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shouldSilence", name: AVAudioSessionSilenceSecondaryAudioHintNotification, object: nil)
    }
    static func shouldSilence()
    {
        shouldMute()
    }
    static func shouldMute()
    {
        muteHint = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        SoundEffects.shouldMute()
        MusicPlayer.shouldMute()
    }
    
    
}
class MusicPlayer:NSObject, AVAudioPlayerDelegate {
    static private var tracks:Dictionary<String, Song> = Dictionary()
    static private var primary:Song?
    static private var secondary:Song?
    static private var listner = Listener()
    static var primaryPlaying = true
    
    static func addTrack(fileName: String, type: String, settings:SoundSettings = SoundSettings())
    {
        if (fileName == "")
        {fatalError("This is an empty string...")}
        let it = Song(name: fileName, type: type, settings: settings)
        it.delegate = listner
        if let _ = tracks.updateValue(it, forKey: fileName)
        {
            fatalError("We allready have a sound named this")
        }
        
        if (SoundManager.initialized == false)
        {
            SoundManager.start()
        }
        
        SoundManager.shouldMute()
    }
    static func addTrack(name: String, fileName: String, type: String, settings:SoundSettings = SoundSettings())
    {
        if ((fileName == "") || (name == ""))
        {fatalError("This is an empty string...")}
        let it = Song(name: fileName, type: type, settings: settings)
        it.delegate = listner
        if let _ = tracks.updateValue(it, forKey: name)
        {
            fatalError("We allready have a sound named this")
        }
        
        if (SoundManager.initialized == false)
        {
            SoundManager.start()
        }
        
        SoundManager.shouldMute()
    }
    static func setPrimary(name: String)
    {
        if (name != "")
        {
            if let past = primary
            {past.pause()}
            
            if let get = tracks[name]
            {primary = get}
            else
            {
                fatalError("We dont know this song")
            }
        }
        else
        {
            primary = nil
        }
        
        SoundManager.shouldMute()
    }
    static func setSecondary(name: String)
    {
        if (name != "")
        {
            if let past = secondary
            {past.pause()}
            
            if let get = tracks[name]
            {secondary = get}
            else
            {
                fatalError("We dont know this song")
            }
        }
        else
        {
            secondary = nil
        }
        
        SoundManager.shouldMute()
    }
    static func play()
    {
        if (hasTwo())
        {
            if let prim = primary
            {
                if let sec = secondary
                {
                    prim.currentTime = 0
                    sec.currentTime = 0
                    
                    let delay:NSTimeInterval = 0.1 //NOTE: If having synchronization issues try making this higher
                    
                    let time:NSTimeInterval = prim.deviceCurrentTime
                    
                    prim.playAtTime(time + delay)
                    sec.playAtTime(time + delay)
                }
            }
        }
        else
        {
            if let prim = primary
            {
                prim.currentTime = 0
                prim.playAtTime(prim.deviceCurrentTime)
            }
            if let sec = secondary
            {
                sec.currentTime = 0
                sec.playAtTime(sec.deviceCurrentTime)
            }
        }
        checkToggle()
        
        SoundManager.shouldMute()
    }
    static func resume()
    {
        if (hasTwo())
        {
            if let prim = primary
            {
                if let sec = secondary
                {
                    let delay:NSTimeInterval = 0.1 //NOTE: If having synchronization issues try making this higher

                    let time:NSTimeInterval = prim.deviceCurrentTime
                    
                    prim.playAtTime(time + delay)
                    sec.playAtTime(time + delay)
                }
            }
        }
        else
        {
            if let prim = primary
            {
                prim.playAtTime(prim.deviceCurrentTime)
            }
            if let sec = secondary
            {
                sec.playAtTime(sec.deviceCurrentTime)
            }
        }
        checkToggle()
        
        SoundManager.shouldMute()
    }
    static func hasTwo() -> Bool
    {
        if let _ = primary
        {
            if let _ = secondary
            {
                return true
            }
        }
        return false
    }
    static func toggle()
    {
        primaryPlaying = !primaryPlaying
        checkToggle()
        
        SoundManager.shouldMute()
    }
    static func checkToggle()
    {
        if let prim = primary
        {
            if let sec = secondary
            {
                if (primaryPlaying)
                {
                    prim.unMute()
                    sec.mute()
                }
                else
                {
                    prim.mute()
                    sec.unMute()
                }
            }
            
        }
        
        SoundManager.shouldMute()
    }
    static func pause()
    {
        if let prim = primary
        {
            prim.pause()
        }
        if let sec = secondary
        {
            sec.pause()
        }
        
        SoundManager.shouldMute()
    }
    static func songDone()
    {
        //NOTE: You must impliment this yourself.  I impliment by doing the following line
        Sequencer.songOver()
        
        SoundManager.shouldMute()
    }
    static func shouldMute()
    {
        if (muteCheck())
        {
            muteAll()
        }
        else
        {
            unMuteAll()
        }
    }
    static func muteAll()
    {
        if let prim = primary
        {
            prim.volume = 0.0
        }
        if let sec = secondary
        {
            sec.volume = 0.0
        }
    }
    static func unMuteAll()
    {
        if (hasTwo())
        {
            if let prim = primary
            {
                if let sec = secondary
                {
                    if (primaryPlaying)
                    {
                        prim.unMute()
                        sec.mute()
                    }
                    else
                    {
                        prim.mute()
                        sec.unMute()
                    }
                }
                
            }
        }
        else
        {
            if let prim = primary
            {
                prim.unMute()
            }
            if let sec = secondary
            {
                sec.unMute()
            }
        }
    }
    static func muteCheck() -> Bool
    {
        if (!SoundManager.muteHint && !SoundManager.mute)
        {
            return false
        }
        else
        {
            return true
        }
    }
}
private class Listener:NSObject, AVAudioPlayerDelegate {
    @objc func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        MusicPlayer.songDone()
    }
}
private class Song:AVAudioPlayer {
    var mySettings = SoundSettings()
    init(name: String, type: String, settings:SoundSettings = SoundSettings()) {
        let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: type)!)
        try! super.init(contentsOfURL: url, fileTypeHint: type)
        mySettings = settings
        self.volume = settings.volume
        self.pan = settings.pan
        if (settings.rate != 1.0)
        {
            self.rate = settings.rate
            self.enableRate = true
        }
        self.prepareToPlay()
        
    }
    func mute()
    {
        self.volume = 0.0
    }
    func unMute()
    {
        self.volume = mySettings.volume
    }
}
class SoundEffects:NSObject {
    static private var sounds:Dictionary<String, EffectInstance> = Dictionary()
    static func addEffect(fileName: String, type: String, playsFrequently: Bool = false, settings: SoundSettings = SoundSettings())
    {
        let it = EffectInstance(name: fileName, type: type, playsFrequently: playsFrequently, settings: settings)
        if let _ = sounds.updateValue(it, forKey: fileName)
        {
            fatalError("We already have a sound named this")
        }
        
        if (SoundManager.initialized == false)
        {
            SoundManager.start()
        }
        
        SoundManager.shouldMute()
    }
    static func addEffect(name: String, fileName: String, type: String, playsFrequently: Bool = false, settings: SoundSettings = SoundSettings())
    {
        let it = EffectInstance(name: fileName, type: type, playsFrequently: playsFrequently, settings:settings)
        if let _ = sounds.updateValue(it, forKey: name)
        {
            fatalError("We allready have a sound named this")
        }
        
        if (SoundManager.initialized == false)
        {
            SoundManager.start()
        }
        
        SoundManager.shouldMute()
    }
    static func play(name: String)
    {
        if let it = sounds[name] as EffectInstance!
        {
            it.play()
        }
        else
        {
            fatalError("We dont know about this sound")
        }
        
        SoundManager.shouldMute()
    }
    static func pause(name: String)
    {
        if let it = sounds[name] as EffectInstance!
        {
            it.pause()
        }
        else
        {
            fatalError("We dont know about this sound")
        }
        
        SoundManager.shouldMute()
    }
    static func mute(name: String)
    {
        if let it = sounds[name] as EffectInstance!
        {
            it.mute()
        }
        else
        {
            fatalError("We dont know about this sound")
        }
        
        SoundManager.shouldMute()
    }
    static func unmute(name: String)
    {
        if let it = sounds[name] as EffectInstance!
        {
            it.unmute()
        }
        else
        {
            fatalError("We dont know about this sound")
        }
        
        SoundManager.shouldMute()
    }
    static func shouldMute()
    {
        if (muteCheck())
        {
            muteAll()
        }
        else
        {
            unMuteAll()
        }
    }
    static func muteAll()
    {
        for (_, sound) in sounds
        {
            sound.mute()
        }
    }
    static func unMuteAll()
    {
        for (_, sound) in sounds
        {
            sound.unmute()
        }
    }
    static func muteCheck() -> Bool
    {
        if (!SoundManager.muteHint && !Sequencer.mute)
        {
            return false
        }
        else
        {
            return true
        }
    }
}
private class EffectInstance: NSObject {
    
    private var myName = ""
    private var myType = ""
    private var freq = false
    var mySettings:SoundSettings = SoundSettings()
    var listner = EffListner()
    
    private var sounds:[AVAudioPlayer] = []
    
    init(name: String, type: String, playsFrequently: Bool, settings:SoundSettings = SoundSettings())
    {
        myName = name
        myType = type
        freq = playsFrequently
        mySettings = settings
        super.init()
        listner.itsMe(self)
        if (playsFrequently == true)
        {
            for var i = 0; i < 3; i++
            {
                makeAMe()
            }
        }
        else
        {
            makeAMe()
        }
        
        
        SoundManager.shouldMute()
    }
    func makeAMe()
    {
        let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(myName, ofType: myType)!)
        let object = try? AVAudioPlayer(contentsOfURL: url)
        object?.delegate = listner
        object!.prepareToPlay()
        object?.delegate = listner
        object!.volume = mySettings.volume
        object!.pan = mySettings.pan
        object?.delegate = listner
        if (mySettings.rate != 1.0)
        {
            object!.rate = mySettings.rate
            object!.enableRate = true
        }
        object?.delegate = listner
        sounds.append(object!)
        object?.delegate = listner
    }
    func audioOver(player: AVAudioPlayer)
    {
        if let loc = sounds.indexOf(player)
        {
            var bar = 1
            if (freq) {bar = 3}
            
            if (loc > bar)
            {
                sounds.removeAtIndex(loc)
            }
        }
    }
    func play()
    {
        for var i = 0; i < sounds.count; i++
        {
            if (sounds[i].playing == false)
            {
                sounds[i].currentTime = 0
                sounds[i].play()
                return
            }
        }
        makeAMe()
        sounds.last?.play()
        
        SoundManager.shouldMute()
    }
    func pause()
    {
        for var i = 0; i < sounds.count; i++
        {
            if (sounds[i].playing == true)
            {
                sounds[i].pause()
            }
        }
    }
    func mute()
    {
        for var i = 0; i < sounds.count; i++
        {
            sounds[i].volume = 0.0
        }
    }
    func playing() -> Bool
    {
        for var i = 0; i < sounds.count; i++
        {
            if (sounds[i].playing == true)
            {
                return true
            }
        }
        return false
    }
    func unmute()
    {
        for var i = 0; i < sounds.count; i++
        {
            sounds[i].volume = mySettings.volume
        }
    }
    
}
private class EffListner:NSObject, AVAudioPlayerDelegate {
    private var me:EffectInstance?
    func itsMe(obj: EffectInstance)
    {
        me = obj
    }
    @objc func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        me?.audioOver(player)
    }
}
//NOTE: A seperate listner class was needed... I dont really know why, it didnt work otherwise