//
//  main.swift
//  iOSLearning-1
//
//  Created by 王浩源 on 2022/12/15.
//

import Foundation

var human1 = Human(gander: "男", age: 59, name: "小曾")

human1.getAll()

var student1 = Student(gander: "男", age: 18, name: "小王", school: "沙河大专", institute: "沙软", grade: "22级", classID: "2022091203", StudentID: "2022091203001")
var student2 = Student(gander: "男", age: 19, name: "小李", school: "沙河大专", institute: "沙软", grade: "22级", classID: "2022091203", StudentID: "2022091203002")
var student3 = Student(gander: "男", age: 18, name: "小郭", school: "沙河大专", institute: "沙软", grade: "22级", classID: "2022091203", StudentID: "2022091203003")

student1.getAll()
student2.getAll()
student3.getAll()

var manager = StudentManager(classID: "2022091203", name: "卷王的班级", number: 2, students: student1,student2 )

manager.getMessage()

manager.StudentIn(student: student3)

manager.StudentOut(student: student2)

manager.getMessage()

