//
//  ContentView.swift
//  ClockDemo
//
//  Created by Zeynep Cankaya on 6.01.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        
        TabView {
              WorldClockView()
                        .tabItem {
                            Label("World Clock", systemImage: "globe")
                        }
                    AlarmsView()
                        .tabItem {
                            Label("Alarms", systemImage: "clock.fill")
                            
                        }
                    stopWatch()
                        .tabItem{
                            Label("Stopwatch", systemImage: "stopwatch")
                                                        }
                    Timers()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                        
                }
               
            }
        .accentColor(.orange)
        .preferredColorScheme(.dark)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        
    }
     
}
struct ContentPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
            
            
            
            
            
            
            
            
            
            
            
            
            
           

  

