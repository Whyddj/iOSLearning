//
//  UserData.swift
//  AlarmClock
//
//  Created by 王浩源 on 2022/12/22.
//

import Foundation

class Clock: ObservableObject {
    @Published var ClockList: [SingleClock]
    var count: Int = 0
    
    init(){
        self.ClockList = []
    }
    
    init(data: [SingleClock]) {
        self.ClockList = []
        for i in data{
            self.ClockList.append(SingleClock(title: i.title, time: i.time, isOn: i.isOn, id: self.ClockList.count))
        }
    }
    
    
    func add(data: SingleClock) {
        self.ClockList.append(SingleClock(title: data.title, time: data.time, repeatDays: data.repeatDays, id: self.ClockList.count))
    }
}

struct SingleClock: Identifiable {
    var title: String = ""
    var time: Date = Date()
    var isOn: Bool = true
    var repeatDays: [Bool] = [Bool](repeating: false, count: 7)
    
    var id: Int = 0
}
