//
//  WorldClock.swift
//  ClockDemo
//
//  Created by Zeynep Cankaya on 14.01.2025.
//
import SwiftUI

struct WorldClockView: View {
    @State private var clocks: [City] = []
    @State private var isShowingAddView = false
    var userTimeZone : TimeZone {
        TimeZone.current
    }
  
    
    var body: some View {
        NavigationView {
            VStack{
                if clocks.isEmpty {
                    Text("No World Clocks").font(.title)
                        .foregroundColor(.gray)
                }
                else {
                    List{
                       
                        ForEach(clocks){ clock in
                                HStack{
                                    
                                VStack(alignment: .leading){
                                    
                                    Text(clock.timeDifference(from: userTimeZone))
                                        .font(.custom("", size: 15))
                                            .foregroundColor(.gray)
                                            
                                    Text(clock.cityname)
                                        .font(.custom("", size: 25))
                                                
                                        }
                                    Spacer()
                                    
                                    VStack(alignment: .trailing){
                                        Text(clock.currentTime)
                                            .font(.custom("", size: 45))
                                        
                                            .frame(width: 120, height: 60)
                                    }
                                }
                        }
                        .onDelete(perform: deleteItems)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(Visibility.visible, edges: .all)
                        
                    }
                }
            }
            .navigationBarTitle("World Clock")
                
                    .toolbar {
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton()
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isShowingAddView = true
                                
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingAddView) {
                        AddNewView {selectedCity in clocks.append(selectedCity)
                        }
                        
                    }
                
            }
        }
 
    
    struct AddNewView: View {
        let onCitySelected: (City) -> Void
        @Environment(\.dismiss) private var dismiss
        @State private var searchText: String = ""
        @State private var filteredCities: [City] = cityList
        
        var body: some View {
            NavigationView{
                List(filteredCities) { city in
                    Button( action: {
                        onCitySelected(city)
                        dismiss()
                    }) {
                        HStack{
                            Text(city.cityname)
                                .font(.headline)
                            Text(city.timeZone.identifier)
                                .font(.headline)
                            
                            
                        }.accentColor(.white)
                        
                    }
                    
                }
                
                
                .listStyle(InsetGroupedListStyle())
                .padding(.top, -10)
                .navigationTitle("Choose a City")
                .navigationBarTitleDisplayMode(.inline)
                
              
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
                        .onChange(of: searchText) {
                            if searchText.isEmpty {
                                filteredCities = cityList
                            } else {
                                filteredCities = cityList.filter {$0.cityname.lowercased().contains(searchText.lowercased())}
                            }
                        }
                    }
                    
                }
            }
        
    
    

    
    private func deleteItems(at offsets: IndexSet) {
        clocks.remove(atOffsets: offsets)
    }
}

struct WorldClock: PreviewProvider {
    static var previews : some View {
      WorldClockView ()
    }
}

