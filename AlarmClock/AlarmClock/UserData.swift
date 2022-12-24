//
//  UserData.swift
//  AlarmClock
//
//  Created by 王浩源 on 2022/12/22.
//

import Foundation

var encoder = JSONEncoder()
var decoder = JSONDecoder()

class Clock: ObservableObject {
    @Published var ClockList: [SingleClock]
    var count: Int = 0
    
    init(){
        self.ClockList = []
    }
    
    init(data: [SingleClock]) {
        self.ClockList = []
        for i in data{
            self.ClockList.append(SingleClock(title: i.title, time: i.time, isOn: i.isOn, repeatDays: i.repeatDays,id: self.ClockList.count))
        }
    }
    
    
    func add(data: SingleClock) {
        self.ClockList.append(SingleClock(title: data.title, time: data.time, repeatDays: data.repeatDays, id: self.ClockList.count))
        
        self.sort()
        self.dataStore()
    }
    
    func delete(index: Int) {
        self.ClockList[index].isDeleted = true
        
        self.sort()
        self.dataStore()
    }
    
    func edit(id: Int, data: SingleClock) {
        self.ClockList[id].title = data.title
        self.ClockList[id].time = data.time
        self.ClockList[id].repeatDays = data.repeatDays
        
        self.sort()
        self.dataStore()
    }
    
    func sort() {
        self.ClockList.sort(by: {(data1, data2) in
            return data1.time.timeIntervalSince1970 < data2.time.timeIntervalSince1970
        })
        for i in 0..<self.ClockList.count {
            ClockList[i].id = i
        }
    }
    
    func dataStore() {
        let dataStored = try! encoder.encode(self.ClockList)
        UserDefaults.standard.set(dataStored, forKey: "ClockList")
    }
}

struct SingleClock: Identifiable, Codable {
    var title: String = ""
    var time: Date = Date()
    var isOn: Bool = true
    var repeatDays: [Bool] = [Bool](repeating: false, count: 7)
    var isDeleted: Bool = false
    
    var id: Int = 0
}
