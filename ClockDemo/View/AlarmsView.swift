//
//  Alarms.swift
//  ClockDemo
//
//  Created by Zeynep Cankaya on 14.01.2025.
//
import SwiftUI
import AVFoundation

struct AlarmsView : View {
    @State private var alarms : [Alarm] = []
    @State private var isSheetPresented = false
    @State private var isEnabled : Bool = true
    
    var body: some View {
        NavigationView {
            VStack{
                if alarms.isEmpty {
                    Text("No Alarms")
                        .foregroundColor(.gray)
                        .font(.headline)
                }else{
                    List{
                        ForEach(alarms) { alarm in
                            HStack{
                                VStack(alignment: .leading){
                                    Text(alarm.time)
                                        .font(.custom("", size: 45))
                                    
                                    Text("\(alarm.label), \(alarm.repeatDay ?? "")")
                                        .font(.caption)
                                }
                                Spacer()
                                Toggle("", isOn: $isEnabled)
                                
                                    .labelsHidden()
                                
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                
            }
            
            
            .navigationBarTitle("Alarms")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isSheetPresented = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
            } .accentColor(.orange)
        }
            .sheet(isPresented: $isSheetPresented) {
                AddAlarms { newAlarm in
                    alarms.append(newAlarm)
                    isSheetPresented = false
                } onCancel: {
                    isSheetPresented = false
                }
            }
    }
    
    
    private func deleteItems(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
    }
}
    
struct AddAlarms  :View  {
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var alarmLabel : String = ""
    @State private var selectedAlarmSound : String = "Default"
    @State private var alarmPlayer : AVAudioPlayer?
    @State private var isAlarmSoundSheetOpen : Bool = false
   
    @State private var selectedDay: String = "Everyday"
    @State private var isRepeatSheetShown : Bool = false
    @Environment(\.dismiss) var dismiss
    
    var onSave: (Alarm) -> Void
    var onCancel: () -> Void
    var body: some View {
        NavigationView{
            VStack{
                
                HStack{
                    Picker("Hour", selection: $selectedHour) {
                        ForEach(0..<24, id: \.self){ hour in
                            Text(String(format: "%02d", hour)).tag(hour)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100, height: 100)
                    .clipped()
                    
                    Picker("Minute", selection: $selectedMinute){
                        ForEach(0..<60, id: \.self){ minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                            
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100, height: 100)
                    .clipped()
                }
                .padding()
                
                Form{
                    HStack{
                        Text("Repeat")
                        Spacer()
                        Button(action: {
                            isRepeatSheetShown = true
                        }) {
                            HStack{
                                Text(selectedDay)
                                    .accentColor(Color.gray)
                                Image(systemName: "chevron.right")
                                    .multilineTextAlignment(.trailing)
                            }.accentColor(.gray)
                        }
                        
                    }
                    HStack{
                        Text("Label")
                        TextField("Alarm", text: $alarmLabel)
                            .multilineTextAlignment(.trailing)
                        
                    }
                    HStack{
                        Text("Sound")
                        Spacer()
                        Button(action: {
                            isAlarmSoundSheetOpen = true
                        }){
                            HStack{
                                Text(selectedAlarmSound)
                                    .accentColor(Color.gray)
                                Image(systemName: "chevron.right")
                                    .multilineTextAlignment(.trailing)
                                
                            }.accentColor(.gray)
                        }
                    }
                    HStack{
                        Text("Snooze")
                        Toggle("", isOn: .constant(true))
                            .multilineTextAlignment(.trailing)
                    }
                    
                }
                
                
                
            }
            
            
            
            .navigationTitle("Add Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save") {
                        let newAlarm = Alarm (
                            time: String(format: "%02d:%02d", selectedHour, selectedMinute ),
                            label: alarmLabel.isEmpty ? "Alarm" : alarmLabel,
                            repeatDay: selectedDay.isEmpty ? "EveryDay" : selectedDay,
                            isEnabled: true

                            )
                         
                        onSave(newAlarm)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        onCancel()
                        dismiss()
                    }
                }
            }.accentColor(.orange)
        }
        .sheet(isPresented: $isAlarmSoundSheetOpen){
            selectedAlarmSounds(selectedSound: $selectedAlarmSound, alarmPlayer: alarmPlayer)
        }
        .sheet(isPresented: $isRepeatSheetShown){
            isRepeatDays(selectedDay: $selectedDay)
        }
    }
    struct isRepeatDays : View {
        @Binding var selectedDay : String
        @Environment(\.dismiss) var dismiss
         let days = ["Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday", "Every Sunday"]
        var body: some View {
            List {
                ForEach(days, id: \.self) { day in
                    Button( action: {
                        selectedDay = day
                        dismiss()
                       }){
                        HStack{
                            Text(day)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
        }
    }
    
    func alarmPlayer(_ soundName: String){
        if let soundUrl = Bundle.main.url(forResource: soundName, withExtension: "wav") {
            do {
                alarmPlayer = try AVAudioPlayer(contentsOf: soundUrl )
                alarmPlayer?.play()
            } catch{
                print("Sound can not play \(error.localizedDescription)")
            }
        }
        
    }
    struct selectedAlarmSounds : View {
        @Binding var selectedSound: String
        @Environment(\.dismiss) var dismiss
        let alarmPlayer : (String) -> Void
        let soundsOption = ["Default", "Cosmic", "Alien", "Malumba"]
        
        var body: some View {
            NavigationView{
                List{
                    ForEach(soundsOption, id: \.self){ sound in
                        Button( action: {
                            selectedSound = sound
                            alarmPlayer(sound)
                            dismiss()
                        }) {
                            HStack{
                                Text(sound).accentColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                   
                            }.accentColor(.gray)
                        }
                    }
                }
                .navigationTitle(Text("Select Sound"))
                navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
struct AlarmsView_Previews: PreviewProvider{
    static var previews: some View {
        AlarmsView()
    }
}
