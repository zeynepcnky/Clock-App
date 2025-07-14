//
//  Sounds.swift
//  ClockDemo
//
//  Created by Zeynep Cankaya on 24.01.2025.
//
import Foundation
import SwiftUI
import AVFoundation

struct Sounds {
    @State private var selectedSound: String = "Default"
    @State private var player: AVAudioPlayer?
    
    func playSound(_ soundName : String) {
        if let soundUrl = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do{
                player = try AVAudioPlayer(contentsOf: soundUrl)
                player?.play()
            }catch{
                print("Failed to play sound: \(error.localizedDescription)")
            }
        }
    }
    struct selectedSoundsSheet: View {
        @Binding var selectedSound : String
        let playsound : (String) -> Void

        let soundOptions = ["Default", "Beep", "Chime", "Alert"]
        
        var body: some View {
            NavigationView{
                List{
                    ForEach(soundOptions , id: \.self){ sound in
                        Button(action: {
                            selectedSound = sound
                            playsound(sound)
                        }) {
                            HStack{
                                Text(sound)
                                if sound == selectedSound {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        
                    }
                }
                .navigationTitle("Select Sound")
            }
        }
    }
}

