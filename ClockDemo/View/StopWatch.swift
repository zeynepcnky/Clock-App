//
//  StopWatch.swift
//  ClockDemo
//
//  Created by Zeynep Cankaya on 14.01.2025.
//
import SwiftUI

struct stopWatch: View {
    @StateObject private var stopWatchManager = StopWatchManager()
    @State private var isRunning : Bool = false
    @State private var isStopped : Bool = false
    @State private var SelectedTab = 0
    
    var body: some View {
        
        VStack{
        
            TabView(selection: $SelectedTab){
                digitalClockView()
                    .tag(0)
                analogClockView()
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 250)
            
           
            HStack{
                Button(action: {
                    if  isStopped {
                        stopWatchManager.reset()
                    }else if isRunning{
                        stopWatchManager.addLap()
                    }
                })
                {
                    //Reset-Lap Button
                    Text( isStopped ? "Reset" : "Lap")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().frame(width: 90, height: 90).opacity(0.4).foregroundColor(.gray))
            }
                Spacer()
                HStack(spacing: 8){
                    ForEach(0..<2, id: \.self) { index in
                        Circle()
                            .frame(width:8, height: 8)
                            .foregroundColor(SelectedTab == index ? .white : .gray)
                            .padding(2)
                    }
                }
                .padding(2)
                
                Spacer()
                
                Button(action: {
                    if isRunning{
                        stopWatchManager.stopTimer()
                        isStopped = true
                    } else {
                        stopWatchManager.startTimer()
                        isStopped = false
                    }
                    isRunning.toggle()
                }) {
                    
                    //Start-Stop Button
                    Text(isRunning ? "Stop" : "Start")
                        .font(.headline)
                        .foregroundColor(isRunning ? .red : .green )
                    
                        .padding()
                        .background(Circle().frame(width: 90, height: 90).opacity(0.5).foregroundColor(isRunning ? .red : .green))
                    
                }
            }
            .padding(.horizontal, 10)
            .padding(25)
           Divider()
                .background(Color.gray)
                .frame(height: 1)
                .padding(.horizontal, 15)
            List(Array(stopWatchManager.laps.enumerated()).reversed(), id:\.offset) {index, lap in
                HStack{
                    Text("Lap \(index + 1)")
                    Spacer()
                    Text("\(formatTime(milliseconds: lap))")
                }
            }
            .listStyle(PlainListStyle())
    }
}
    private func digitalClockView() -> some View {
        Text(formatTime(milliseconds: stopWatchManager.time))
            .font(.custom("", size: 55))
            .bold()
            .padding(.vertical, 100)
    }
    private func analogClockView() -> some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .foregroundColor(.gray.opacity(0.5))
                .frame(width: 200, height: 200)
            
            ForEach(1..<13){ index in
                let angle = (Double(index) * 30.0) - 90.0
                let radius : CGFloat = 80
                let x = radius * cos(angle * .pi / 180)
                let y = radius * sin(angle * .pi / 180)

                Text("\(index * 5)")
                    .font(.system(size: 15))
                    .bold()
                    .position(x: 100 + x, y: 100 + y)
                
            }
            
            Rectangle()
                .fill(Color.blue)
                .frame(width: 2, height: 40)
                .offset(y: -20)
                .rotationEffect(.degrees(secondsAngle))
            
            Circle()
                .fill(Color.blue)
                .frame(width: 8, height: 8)
                
        }
        .frame(width: 200, height: 200)
        .padding(.vertical, 40)
    }
    private var secondsAngle: Double{
        let seconds = Double(stopWatchManager.time) / 100.0
        return (seconds.truncatingRemainder(dividingBy: 60)) * 6
    }
    func formatTime(milliseconds: Int) -> String {
        let millis = milliseconds % 100
        let seconds = (milliseconds / 100) % 60
        let minutes = (milliseconds / 60_000) % 60
        
        return String(format: "%02d:%02d,%02d", minutes, seconds, millis)
        
    }
}
class StopWatchManager: ObservableObject {
    @Published var time: Int = 0
    @Published var laps : [Int] = []
    private var timer : Timer?
    
   func startTimer() {
       DispatchQueue.main.async {
           self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
               self?.time += 1
           }
           RunLoop.current.add(self.timer!, forMode: .common)
        }
    }
    
    func stopTimer() {
       
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        stopTimer()
        time = 0
        laps.removeAll()
    }
    func addLap() {
        laps.append(time)
    }
}

struct StopWatchPreview: PreviewProvider {
    static var previews: some View {
       stopWatch()
    }
    
}

