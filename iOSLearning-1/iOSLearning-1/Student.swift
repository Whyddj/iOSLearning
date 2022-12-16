//
//  Student.swift
//  iOSLearning-1
//
//  Created by 王浩源 on 2022/12/15.
//

import Foundation

struct AcademicInfo {
    public var school: String = ""
    public var institute: String = ""
    public var grade: String = ""
    public var classID: String = ""
    
    init(school: String, institute: String, grade: String, classID: String) {
        self.school = school
        self.institute = institute
        self.grade = grade
        self.classID = classID
    }
    
}

class Student: Human {
    var info: AcademicInfo
    private var StudentID: String
    init(gander: String, age: Int, name: String, school: String, institute: String, grade: String, classID: String, StudentID: String) {
        info = AcademicInfo(school: school, institute: institute, grade: grade, classID: classID)
        self.StudentID = StudentID
        super.init(gander: gander, age: age, name: name)
        
    }
    
    func setID(ID: String){
        self.StudentID = ID
    }
    
    override func getAll() {
        print("性别："+gander)
        print("年龄："+String(age))
        print("姓名："+name)
        print("学校："+info.school)
        print("学院："+info.institute)
        print("年级："+info.grade)
        print("班级："+info.classID)
        print("学号："+StudentID)
        print("")
    }
    
}
