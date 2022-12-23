//
//  EditingPage.swift
//  AlarmClock
//
//  Created by 王浩源 on 2022/12/22.
//

import SwiftUI
import AVFoundation


struct EditingPage: View {
    @EnvironmentObject var UserData: Clock
    
    var time: Date = Date()
    @State var selectedHour = 0
    @State var selectedMinute = 0
    @State var name = "闹钟"
    var id: Int? = nil
    
    @State var repeatDays = [Bool](repeating: false, count: 7)
    @State var isEditing = false
    @State var selectedDays = [Int]()
    
    let hours = Array(0...23)
    let minutes = Array(0...59)
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Picker(selection: $selectedHour, label: Text("Hour")) {
                            ForEach(0..<24) {
                                Text("\(self.hours[$0])")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())

                        Picker(selection: $selectedMinute, label: Text("Minute")) {
                            ForEach(0..<60) {
                                Text("\(self.minutes[$0])")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                }
                Section {
                    NavigationLink(destination: RepeatDaysView(repeatDays: $repeatDays)) {
                        HStack {
                            Text("重复")
                            Spacer()
                            ForEach(0..<7) { index in
                                if repeatDays[index] {
                                    Text(dayName(for: index)).font(.footnote)
                                }
                            }
                        }
                    }
                    NavigationLink(destination: NameView(name: $name)) {
                        HStack {
                            Text("标签")
                            Spacer()
                            Text(name)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        
                    }){
                        Text("删除闹钟")
                            .foregroundColor(.red)
                    }
                }
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
}

struct RepeatDaysView: View {
    @Binding var repeatDays: [Bool]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<7) { index in
                    Button(action: {
                        self.repeatDays[index].toggle()
                    }) {
                        HStack {
                            Text(self.dayName(for: index))
                            Spacer()
                            if self.repeatDays[index] {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("重复")
            .navigationBarItems(trailing: Button("完成") {
                            self.presentationMode.wrappedValue.dismiss()
                        })
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
}

struct NameView: View {
    @Binding var name: String
    
    var body: some View {
        NavigationView {
            Form {
                TextField("标签", text: self.$name)
            }
        }
    }
}

struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        EditingPage()
    }
}
