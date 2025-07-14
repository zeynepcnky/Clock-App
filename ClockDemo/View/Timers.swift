//
//  Timers.swift
//  ClockDemo
//
//  Created by Zeynep Cankaya on 15.01.2025.
//
import SwiftUI
import AVFoundation

struct Timers: View {
    @State private var hours : Int = 0
    @State private var minutes : Int = 0
    @State private var seconds : Int = 0
    @State private var isRunning : Bool = false
    @State private var timer : Timer?
    @State private var showSheet = false
    @State private var selectedSound: String = "Default"
    @State private var player: AVAudioPlayer?
    
    var body: some View {
        VStack{
            HStack(spacing: 0){
                Picker("Hours", selection: $hours){
                    ForEach(0..<24){ hour in
                        Text("\(hour) h").tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                
                Picker("Minutes", selection: $minutes){
                    ForEach(0..<60){ minute in
                        Text("\(minute) min").tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                
                Picker("Seconds", selection: $seconds){
                    ForEach(0..<60){ second in
                        Text("\(second) s").tag(second)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
            }
            .padding()
            
            HStack{
                Button("Reset"){
                    resetTimer()
                }
                .accentColor(.gray).bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Circle().frame(width: 90, height: 90).foregroundColor(.gray).opacity(0.4))
                
                Spacer()
                    .padding()
                
                Button(isRunning ? "Stop" : "Start") {
                    isRunning ? stopTimer(): startTimer()
                    isRunning.toggle()
                }
                .accentColor(isRunning ? .red : .green).bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Circle().frame(width: 90, height:90 ).foregroundColor(isRunning ? .red : .green).opacity(0.4))
                
            }
            .padding()
            Form {
                
                HStack{
                    Text("Label")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        
                    TextField("Enter Label", text: .constant(""))
                        .multilineTextAlignment(.trailing)
                        .colorScheme(.dark)
                    
                }
                HStack{
                    Text("When Time Ends")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Button("", action: {
                        (showSheet) = true
                    })
                    VStack(alignment: .leading){
                        HStack{
                            Text(selectedSound.description)
                            Image(systemName: "chevron.right")
                                .sheet(isPresented: $showSheet) {
                                    selectedSoundsSheet(selectedSound: $selectedSound, playsound: playSound)
                                }
                                .font(.subheadline)
                                .accentColor(.black)
                        }
                    }
                }
            }
            .frame(height: 140)
            .padding(.vertical, 8)
            
        }
        .padding()
    }
    
//    func addTime(delta: Int){
//        let totalseconds = hours * 3600 + minutes * 60 + seconds + delta
//        let clampedSeconds = max(0, totalseconds)
//        hours = (clampedSeconds / 3600) % 24
//        minutes = (clampedSeconds / 60) % 60
//        seconds = clampedSeconds % 60
//        
//    }
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in if hours == 0 && minutes == 0 && seconds == 0 {
            stopTimer()
        }else {
//            addTime(delta: -1)
        }
        }
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    func resetTimer() {
        stopTimer()
        hours = 0
        minutes = 0
        seconds = 0
    }
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
        @Environment(\.dismiss) private var dismiss
        let playsound : (String) -> Void
        
        let soundOptions = ["Default", "Beep", "Chime", "Alert"]
        
        var body: some View {
            NavigationView{
                List{
                    ForEach(soundOptions , id: \.self){ sound in
                        Button(action: {
                            selectedSound = sound
                            playsound(sound)
                            dismiss()
                        }) {
                            HStack{
                                Text(sound)
                                if sound == selectedSound {
                                
                                }
                            }
                        }
                        .accentColor(.white)
                    }
                }
                .navigationTitle(Text("Select Sound")).navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
struct TimersPreview : PreviewProvider {
    static var previews: some View {
        Timers()
    }
}
 
