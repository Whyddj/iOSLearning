//
//  ContentView.swift
//  AlarmClock
//
//  Created by 王浩源 on 2022/12/20.
//

import SwiftUI

var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

struct ContentView: View {
    
    @ObservedObject var UserData: Clock = Clock()
    @State var showEditingPage = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(self.UserData.ClockList) {item in
                    SingleClockView(index: item.id)
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
    
    @State var showEditingPage = false
    
    var body: some View {
        VStack {
            Toggle(isOn: self.$UserData.ClockList[index].isOn) {
                Button(action: {
                    self.showEditingPage = true
                }){
                    VStack{
                        HStack {
                            Text(formatter.string(from: self.UserData.ClockList[index].time))
                                .font(.largeTitle)
                            .foregroundColor(.black)
                            Spacer()
                        }
                        HStack{
                            Text(self.UserData.ClockList[index].title)
                                .font(.footnote)
                                .foregroundColor(.black)
                            ForEach(0..<7) { index in
                                if self.UserData.ClockList[self.index].repeatDays[index] {
                                    Text(dayName(for: index)).font(.footnote).foregroundColor(.black)
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .sheet(isPresented: self.$showEditingPage, content: {
                    EditingPage()
                        .environmentObject(self.UserData)
                })
            }
            .padding(.horizontal)
            Rectangle()
                .frame(height: 1)
        }
    }
}

func dayName(for index: Int) -> String {
    switch index {
    case 0: return "周一"
    case 1: return "周二"
    case 2: return "周三"
    case 3: return "周四"
    case 4: return "周五"
    case 5: return "周六"
    case 6: return "周日"
    default: return ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
