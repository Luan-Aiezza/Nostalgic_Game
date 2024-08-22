import Foundation
import AVFAudio
import SpriteKit
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    
    private init(){}
    
    func playerOne(){
        
    }
    
    func playLevelOneSong() {
        if let url = Bundle.main.url(forResource: "1. A World of Ghosts", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.prepareToPlay()
                backgroundMusicPlayer?.play()
            } catch {
                print("Error initializing player: \(error.localizedDescription)")
            }
        } else {
            print("Audio file not found.")
        }
    }
         
    func stopLevelOneSong(){
        backgroundMusicPlayer?.setVolume(0, fadeDuration: 1)
        backgroundMusicPlayer?.stop()
    }
    
    func pauseLevelOneSong(){
        backgroundMusicPlayer?.setVolume(0, fadeDuration: 1)
        backgroundMusicPlayer?.pause()
    }
    
    func playLevelTwoSong() {
        if let url = Bundle.main.url(forResource: "2. A World of Ghosts", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.prepareToPlay()
                backgroundMusicPlayer?.play()
            } catch {
                print("Error initializing player: \(error.localizedDescription)")
            }
        } else {
            print("Audio file not found.")
        }
    }
    
    func stopLevelTwoSong(){
        backgroundMusicPlayer?.setVolume(0, fadeDuration: 1)
        backgroundMusicPlayer?.stop()
    }
    
    func pauseLevelTwoSong(){
        backgroundMusicPlayer?.setVolume(0, fadeDuration: 1)
        backgroundMusicPlayer?.pause()
    }
}
