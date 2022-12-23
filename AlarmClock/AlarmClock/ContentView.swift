//
//  ContentView.swift
//  AlarmClock
//
//  Created by 王浩源 on 2022/12/20.
//

import SwiftUI

let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

struct ContentView: View {
    
    @ObservedObject var UserData: Clock = Clock(data: [SingleClock(title: "sadhka", time: Date())])
    @State var showEditingPage = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(self.UserData.ClockList) {item in
                    SingleClockView(index: 0)
                        .environmentObject(self.UserData)
                }
            }
            .navigationTitle("闹钟")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showEditingPage = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: self.$showEditingPage, content: {
                        EditingPage()
                            .environmentObject(self.UserData)
                    })
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        
                    }) {
                        Text("编辑")
                    }
                }
            }
        }
    }
}

struct SingleClockView: View {
    @EnvironmentObject var UserData: Clock
    var index: Int
    @State var isOn: Bool = false
    
    @State var showEditingPage = false
    
    var body: some View {
        VStack {
            Toggle(isOn: self.$isOn) {
                Button(action: {
                    self.showEditingPage = true
                }){
                    VStack{
                        Text(formatter.string(from: self.UserData.ClockList[index].time))
                            .font(.largeTitle)
                            .foregroundColor(.black)
                        Text(self.UserData.ClockList[index].title)
                            .font(.footnote)
                            .foregroundColor(.black)
                    }
                }
                .sheet(isPresented: self.$showEditingPage, content: {
                    EditingPage(time: self.UserData.ClockList[index].time)
                })
            }
            .padding(.horizontal)
            Rectangle()
                .frame(height: 1)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
