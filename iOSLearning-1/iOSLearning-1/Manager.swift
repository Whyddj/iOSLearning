//
//  Manager.swift
//  iOSLearning-1
//
//  Created by 王浩源 on 2022/12/15.
//

import Foundation

class StudentManager{
    var classID: String
    var name: String
    var number: Int
    var students = [Student]()
    
    init(classID: String, name: String, number: Int, students: Student...) {
        self.classID = classID
        self.name = name
        self.number = number
        self.students = students
    }
    
    func StudentIn(student: Student){
        self.number += 1
        print(classID + "班转入新学生" + student.name)
        students.append(student)
    }
    
    func StudentOut(student: Student){
        self.number -= 1
        print(classID + "班转出学生" + student.name)
        students.removeAll(where: { $0 === student })
    }
    
    func getMessage(){
        print("班级号："+classID)
        print("班名："+name)
        print("班级学生数量"+String(number))
        print("班级所有学生：")
        for student in students {
            print(student.name)
        }
        print("")
    }
}
