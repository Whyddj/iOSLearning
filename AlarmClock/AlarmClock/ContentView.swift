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

let calendar = Calendar.current



struct ContentView: View {
    
    @ObservedObject var UserData: Clock = Clock(data: initUserData())
    @State var showEditingPage = false
    @State var isEditing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(self.UserData.ClockList) {item in
                    if !item.isDeleted {
                        HStack {
                            if isEditing {
                                Image(systemName: "trash")
                                    .padding(.leading)
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        self.UserData.ClockList[item.id].isDeleted = true
                                    }
                            }
                            SingleClockView(index: item.id)
                                .environmentObject(self.UserData)
                        }
                    }
                }
            }
            .navigationTitle("闹钟")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showEditingPage = true
                        let center = UNUserNotificationCenter.current()
                        center.getNotificationSettings { (settings) in
                            if settings.authorizationStatus == .authorized {
                                // The user has granted notification permission
                            } else {
                                // The user has not granted notification permission
                                center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                                    if granted {
                                        // The user has granted notification permission
                                    } else {
                                        // The user has not granted notification permission
                                    }
                                }
                            }
                        }
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
                        self.isEditing.toggle()
                    }) {
                        Text(self.isEditing ? "确定" : "编辑")
                    }
                }
            }
        }
    }
}

struct SingleClockView: View {
    @EnvironmentObject var UserData: Clock
    var index: Int
    
    @Environment(\.colorScheme) var colorScheme

    var backgroundColor: Color {
            if colorScheme == .dark {
                return Color.white
            } else {
                return Color.black
            }
        }

    
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
                                .foregroundColor(backgroundColor)
                                
                            Spacer()
                        }
                        HStack{
                            Text(self.UserData.ClockList[index].title)
                                .font(.footnote)
                                .foregroundColor(backgroundColor)
                            if self.UserData.ClockList[self.index].repeatDays == [Bool](repeating: true, count: 7) {
                                Text("每天").font(.footnote).foregroundColor(backgroundColor)
                            }else if self.UserData.ClockList[self.index].repeatDays == [true, true, true, true, true, false, false] {
                                Text("工作日").font(.footnote).foregroundColor(backgroundColor)
                            }else {
                                ForEach(0..<7) { index in
                                    
                                    if self.UserData.ClockList[self.index].repeatDays[index] {
                                        Text(dayName(for: index)).font(.footnote).foregroundColor(.black)
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .sheet(isPresented: self.$showEditingPage, content: {
                    EditingPage(selectedHour: getHour(time: self.UserData.ClockList[index].time), selectedMinute: getMinute(time: self.UserData.ClockList[index].time), name: self.UserData.ClockList[index].title, repeatDays: self.UserData.ClockList[index].repeatDays, id: self.index)
                        .environmentObject(self.UserData)
                })
            }.onChange(of: self.UserData.ClockList[index].isOn) { value in
                self.UserData.dataStore()
                if value {
                    self.UserData.sendNotification(id: index)
                } else {
                    self.UserData.removeNotification(id: index)
                }
            }
            .padding(.horizontal)
            Rectangle()
                .frame(height: 1)
                .padding(.horizontal)
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

func getHour(time: Date) -> Int {
    let components = calendar.dateComponents([.hour, .minute], from: time)
    return components.hour!
}

func getMinute(time: Date) -> Int {
    let components = calendar.dateComponents([.hour, .minute], from: time)
    return components.minute!
}

func initUserData() -> [SingleClock] {
    var output: [SingleClock] = []
    if let dataStored = UserDefaults.standard.object(forKey: "ClockList") as? Data {
        let data = try! decoder.decode([SingleClock].self, from: dataStored)
        for item in data {
            if !item.isDeleted {
                output.append(SingleClock(title: item.title, time: item.time, isOn: item.isOn, repeatDays: item.repeatDays, id: output.count))
            }
        }
    }
    return output
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .colorScheme(.dark)
    }
}
