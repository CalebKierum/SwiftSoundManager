#Sound Manager
Wrapper for the AVAudioPlayer that supports sound effects, and music.

The music played through this manager is set so that it will not play if any other sounds in the system are playing. This way people can listen to their own music while using the application. The music also supports having two simultanious songs that can be switched betreen. I used this feature in my app "Toothache" so that I could impliment a marimba mode where all the music begins to play with a marimba*.

**Note:** Only use this is you are ok with the sounds staying around in memory for the duration of the program.
##Usage
- Drop "SoundManager.swift" into your project
-  Put play/pause statments inside of your AppDelegate (see example)
- Add your sound files
- Play them

###Music
Music is played by filling the "primary" and "secondary" slots in the 'MusicManager'

I would suggest building a sequencer class over the MusicManager that way you can easily manage your progression of songs. However that is your call. To play songs you have to add them to either the primary or the secondary slot then play.

To play a sound

    MusicPlayer.addTrack("HappySong", type: "wav")
	SoundManager.setPrimary("HappySong")
	SoundManager.play()
    
###Sound Effects
I would suggest building a sequencer class over the MusicManager that way you can easily manage your progression of songs. However that is your call. To play songs you have to add them to either the primary or the secondary slot then play.

To play a sound

    SoundEffects.addEffect("Growl1", fileName: "se2", type: "wav")
    SoundEffects.play("Growl1")


###Limitations
You can only have one song, or sound effect for each name. If you want to avoid this their are other overloads of the add functions that allow you to specify a name that is different from the file name.

All of the sounds included in the demo project are licesned under the Creative Commons Zero license.

Enjoy!
    
###Contact
For any inquiries kierumcak@gmail.com
    
###License
Copyright (c) 2016 Caleb Kierum

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
