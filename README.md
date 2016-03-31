# SwiftSoundManager
Wrapper for the AVAudioPlayer that supports sound effects, and music.

The music played through this manager is set so that it will not play if any other sounds in the system are playing.  This way people can listen to their own music while using the application. The music also supports having two simultanious songs that can be switched betreen.  I used this feature in my app "Toothache" so that I could impliment a marimba mode where all the music begins to play with a marimba*.

Note: Only use this is you are ok with the sounds staying around in memory for the duration of the program. 

Usage:
General Steps:
1. Put play/pause statments inside of your AppDelegate
2. Add your sound files
3. Play them
Music:
I would suggest building a sequencer class over the MusicManager that way you can easily manage your progression of songs. However that is your call. To play songs you have to add them to either the primary or the secondary slot then play.
To make a sound simply call "MusicPlayer.addTrack("Death", type: "wav")"
To play that sound you need to do this
SoundManager.setPrimary("Death")
SoundManager.play()
Sound Effects:
Sound effects are made to be played either rarely, or in rapid sucession.  As such this manager handles making new audio players incase an instance of the sound is not finished playing yet. The manager takes care of some of the cleanup from doing this automatically.
To make a sound call "SoundEffects.addEffect("Growl1", fileName: "se2", type: "wav")"
Then to play it "SoundEffects.play("Growl1")"

Limitations:
You can only have one song, or sound effect for each name. If you want to avoid this their are other overloads of the add functions that allow you to specify a name that is different from the file name.

Enjoy!



*Currently my app is not updated with this new sound manager. However it still works more or less the same, just with some errors.
