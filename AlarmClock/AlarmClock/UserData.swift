//
//  UserData.swift
//  AlarmClock
//
//  Created by 王浩源 on 2022/12/22.
//

import Foundation
import UserNotifications

var encoder = JSONEncoder()
var decoder = JSONDecoder()

let NotificationContent = UNMutableNotificationContent()

class Clock: ObservableObject {
    @Published var ClockList: [SingleClock]
    var count: Int = 0
    
    init(){
        self.ClockList = []
    }
    
    init(data: [SingleClock]) {
        self.ClockList = []
        for i in data{
            self.ClockList.append(SingleClock(title: i.title, time: i.time, isOn: i.isOn, repeatDays: i.repeatDays, id: self.ClockList.count))
            count += 1
        }
    }
    
    
    func add(data: SingleClock) {
        self.ClockList.append(SingleClock(title: data.title, time: data.time, repeatDays: data.repeatDays, id: self.ClockList.count))
        count += 1
        
        self.sort()
        self.dataStore()
        
        self.sendNotification(id: self.ClockList.count - 1)
    }
    
    func delete(index: Int) {
        self.removeNotification(id: index)
        
        self.ClockList[index].isDeleted = true
        
        self.sort()
        self.dataStore()
        
    }
    
    func edit(id: Int, data: SingleClock) {
        self.removeNotification(id: id)
        
        self.ClockList[id].title = data.title
        self.ClockList[id].time = data.time
        self.ClockList[id].repeatDays = data.repeatDays
        
        self.sort()
        self.dataStore()
        
        self.sendNotification(id: id)
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
    
    func sendNotification(id: Int) {
        for (index, weekday) in self.ClockList[id].repeatDays.enumerated() {
            if weekday {
                NotificationContent.title = "闹钟"
                NotificationContent.sound = UNNotificationSound(named: UNNotificationSoundName("Radar"))
                NotificationContent.body = self.ClockList[id].title
                
                var NotificationTime = DateComponents()
                NotificationTime.hour = calendar.component(.hour, from: self.ClockList[id].time)
                NotificationTime.minute = calendar.component(.minute, from: self.ClockList[id].time)
                if index == 6 {
                    NotificationTime.weekday = 1
                }
                else {
                    NotificationTime.weekday = index + 2
                }

                let trigger = UNCalendarNotificationTrigger(dateMatching: NotificationTime, repeats: true)
                let request = UNNotificationRequest(identifier: self.ClockList[id].title + self.ClockList[id].time.description + String(index), content: NotificationContent, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
        }
        if self.ClockList[id].repeatDays == [Bool](repeating: false, count: 7) {
            NotificationContent.title = "闹钟"
            NotificationContent.sound = UNNotificationSound(named: UNNotificationSoundName("Radar"))
            NotificationContent.body = self.ClockList[id].title
            
            var NotificationTime = DateComponents()
            NotificationTime.hour = calendar.component(.hour, from: self.ClockList[id].time)
            NotificationTime.minute = calendar.component(.minute, from: self.ClockList[id].time)
            

            let trigger = UNCalendarNotificationTrigger(dateMatching: NotificationTime, repeats: false)
            let request = UNNotificationRequest(identifier: self.ClockList[id].title + self.ClockList[id].time.description, content: NotificationContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func removeNotification(id: Int) {
        for i in 0..<7 {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [self.ClockList[id].title + self.ClockList[id].time.description + String(i)])
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.ClockList[id].title + self.ClockList[id].time.description + String(i)])
        }
        if self.ClockList[id].repeatDays == [Bool](repeating: false, count: 7) {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [self.ClockList[id].title + self.ClockList[id].time.description])
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.ClockList[id].title + self.ClockList[id].time.description])
        }
    }
}

struct SingleClock: Identifiable, Codable, Equatable {
    var title: String = ""
    var time: Date = Date()
    var isOn: Bool = true
    var repeatDays: [Bool] = [Bool](repeating: false, count: 7)
    var isDeleted: Bool = false
    
    var id: Int = 0
}
