//
//  AudioManager.swift
//  Tokyo
//
//  Created by Jessica Rodrigues on 13/08/24.
//

import Foundation
import AVFAudio
import SpriteKit
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    var backgroundMusicPlayer: AVAudioPlayer?
    
    init(){}
    
    func playLevelOneSong() {
        if let url = Bundle.main.url(forResource: "song1", withExtension: "mp3") {
            print("Playing song1.mp3")
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

    
    func playLevelTwoSong() {
        if let url = Bundle.main.url(forResource: "song2", withExtension: "mp3") {
            print("Playing song2.mp3")
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
}
