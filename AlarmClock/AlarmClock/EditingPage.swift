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
    
    @State var selectedHour = Calendar.current.component(.hour, from: Date())
    @State var selectedMinute = Calendar.current.component(.minute, from: Date())
    @State var name = "闹钟"
    @State var repeatDays = [Bool](repeating: false, count: 7)
    
    var id: Int? = nil
    
    @Environment(\.presentationMode) var presentation
    let hours = Array(0...23)
    let minutes = Array(0...59)
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Picker(selection: $selectedHour, label: Text("Hour")) {
                            ForEach(0..<24) {
                                Text(String(format: "%02d", self.hours[$0]))
                            }
                        }
                        .pickerStyle(WheelPickerStyle())

                        Picker(selection: $selectedMinute, label: Text("Minute")) {
                            ForEach(0..<60) {
                                Text(String(format: "%02d", self.minutes[$0]))
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
                        if self.id == nil {
                            self.presentation.wrappedValue.dismiss()
                        } else {
                            self.UserData.delete(index: self.id!)
                            self.presentation.wrappedValue.dismiss()
                        }
                    }){
                        Text("删除闹钟")
                            .foregroundColor(.red)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if self.id == nil {
                                self.UserData.add(data: SingleClock(title: self.name, time: formatter.date(from: String(format: "%02d", selectedHour) + ":" + String(format: "%02d", selectedMinute))!, repeatDays: self.repeatDays))
                                
                                self.presentation.wrappedValue.dismiss()
                            } else {
                                self.UserData.edit(id: self.id!, data: SingleClock(title: self.name, time: formatter.date(from: String(format: "%02d", selectedHour) + ":" + String(format: "%02d", selectedMinute))!, repeatDays: self.repeatDays))
                                self.presentation.wrappedValue.dismiss()
                            }
                        }) {
                            Text("存储")
                        }
                        
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            self.presentation.wrappedValue.dismiss()
                        }) {
                            Text("取消")
                        }
                    }
                }
            }
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
                            Text(dayName(for: index))
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
