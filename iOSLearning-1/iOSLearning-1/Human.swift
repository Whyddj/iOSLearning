//
//  Human.swift
//  iOSLearning-1
//
//  Created by 王浩源 on 2022/12/15.
//

import Foundation

class Human {
    var gander: String
    var age: Int
    var name: String
    
    init(gander: String, age: Int, name: String) {
        self.gander = gander
        self.age = age
        self.name = name
    }
    
    func getAll(){
        print("性别："+gander)
        print("年龄："+String(age))
        print("姓名："+name)
        print("")
    }
}
