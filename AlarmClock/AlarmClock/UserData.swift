//
//  UserData.swift
//  AlarmClock
//
//  Created by 王浩源 on 2022/12/22.
//

import Foundation

class Clock: ObservableObject {
    var ClockList: [SingleClock]
    var count: Int = 0
    
    init(){
        self.ClockList = []
    }
    
    init(data: [SingleClock]) {
        self.ClockList = []
        for i in data{
            self.ClockList.append(SingleClock(title: i.title, time: i.time, id: count))
            count += 1
        }
    }
    
    func Check(id: Int) {
        self.ClockList[id].isOn.toggle()
    }
}

struct SingleClock: Identifiable {
    var title: String = ""
    var time: Date = Date()
    var isOn: Bool = false
    
    var id: Int = 0
}
