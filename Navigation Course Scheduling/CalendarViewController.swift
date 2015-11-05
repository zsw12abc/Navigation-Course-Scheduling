//
//  CalendarViewController.swift
//  Navigation Course Scheduling
//
//  Created by ShaoweiZhang on 15/10/30.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import UIKit
import EventKit
import Parse

class CalendarViewController: UIViewController {
    var courseHours : Int?;
    var roomNum : Int?;
    var startDate : NSDate?
    var endDate : NSDate?;
    var courseList = Array<PFObject>();
    var lecturerList = Array<PFObject>();
    var studentList = Array<PFObject>();
    var totalHours: Int = 0;
    var totalDays: Int = 0;
    var calendar: CourseSchedule<Array<PFObject>>?;

    override func viewDidLoad() {
        super.viewDidLoad()
//        var calendar: Array<hourSchedule<PFObject>>?;
//        for (var i = 0; i <= totalDays; i++){
//            let daySchedule = hourSchedule<PFObject>(columns: roomNum!, rows: 9);
//            calendar?.append(daySchedule);
//            
//        }
//        print("calendar: \(calendar?.count)")
        print("startDate: \(startDate!.toTimezone("UTC+10"))");
        print("endDate: \(endDate!.toTimezone("UTC+10"))");
        print("room num: \(roomNum!)");
        print("course Hours: \(courseHours!)");

        
        for (var i = 0; startDate! + i.day <= endDate!; i++){
//            print(i);
            if (startDate! + i.day == endDate!){
//                print("Total Days are:  \(i) days");
                totalDays = i;
            }
        }
        
        calendar = CourseSchedule<Array<PFObject>>(columns: totalDays, rows: 12/(courseHours!+1));
        
//        for (var col = 0; col < calendar!.columns; col++){
//            for(var row = 0; row < calendar!.rows; row++){
//                print(calendar![col, row]);
//            }
//            print("*******");
//        }
        
        let courseQuery = PFQuery(className: "Course");
        let lecturerQuery = PFQuery(className: "Lecturer");
        let studentQuery = PFQuery(className: "Student");
//        courseQuery.findObjectsInBackgroundWithBlock { (courses, error) -> Void in
//            if error == nil {
//               if let courses = courses{
//                    for course in courses {
//                        self.courseList.append(course);
//                        self.totalHours = self.totalHours + (course["hours"] as! Int);
//                    }
//                }
//                print("Total Hours are: \(self.totalHours)hours");
//                if self.totalHours > self.totalDays * 8 * self.roomNum!{
//                    print("not enought time")
//                }else{
//                    print("enought time")
//                }
//            }else{
//                print("courseQuery: \(error)");
//            }
//        }
//        lecturerQuery.findObjectsInBackgroundWithBlock { (lecturers, error) -> Void in
//            if error == nil {
//                if let lecturers = lecturers {
//                    for lecturer in lecturers{
//                        self.lecturerList.append(lecturer);
//                    }
//                }
//            } else {
//                print("lecturerQuery: \(error)");
//            }
//        }
//        studentQuery.findObjectsInBackgroundWithBlock { (students, error) -> Void in
//            if error == nil {
//                if let students = students {
//                    for student in  students {
//                        self.studentList.append(student);
//                    }
//                }
//            }else {
//                print("studentQuery: \(error)");
//            }
//        }
        // Do any additional setup after loading the view.
        do{
            let courses = try courseQuery.findObjects() as [PFObject];
            for course in courses{
                self.courseList.append(course);
            }
            let lecturers = try lecturerQuery.findObjects() as [PFObject];
            for lecturer in lecturers {
                self.lecturerList.append(lecturer);
            }
            let students = try studentQuery.findObjects() as [PFObject];
            for student in students {
                self.studentList.append(student);
            }
        }catch{
            print(error);
        }
//        print("courseList: \(courseList)");
        courseList = sortCourse(courseList);
//        print("sortCourse: \(courseList)");
//        print(calendar!.columns);
//        print(calendar!.rows);
//        print(calendar![0,0])
//        print(courseList[0]["lecturer"]["schedule"]);
        for var col = 0; col < calendar?.columns; col++ {
            for var row = 0; row < calendar?.rows; row++ {
                courseSchedule(col, row: row);
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //冒泡排序课程
    func sortCourse(var courses:Array<PFObject>) -> Array<PFObject>{
        for (var i = 0; i < courses.count - 1; i++){
            for(var j = 0; j < courses.count - 1 - i; j++){
//                print("j: \(courses[j]["name"]) \(courses[j]["exam"]) \n j+1: \(courses[j + 1]["name"]) \(courses[j + 1]["exam"])")
                if courses[j]["exam"] as! NSDate > courses[j + 1]["exam"] as! NSDate{
                    let temp = courses[j];
                    courses[j] = courses[j + 1];
                    courses[j + 1] = temp;
//                    print("swap \(courses[j]["name"]) with \(courses[j+1]["name"])")
                }
            }
        }
        return courses;
    }
    
    
    func courseSchedule(column:Int, row:Int){
        let time = startDate!.toTimezone("UTC+10")! + column.day + (row * 3).hour;
        var courseCell: Array<PFObject> = [];
        print("time is \(time) with \(column) columns and \(row) rows");
        //选出可以在这时间上课的课程
        for course in courseList {
            var arrange = true;
            if course["lecturer"] != nil{
                for courseTime in course["lecturer"]["schedule"] as! Array<NSDate> {
                    let courseRealTime = courseTime.toTimezone("UTC+10");
                    if courseRealTime >= time && courseRealTime <= time + 2.hour {
                        arrange = false;
                    }
                }
            }else{
                arrange = false;
            }
            if arrange == true {
                print("\(course["name"]) can be added to \(time) with schedue \(course["schedule"]) ");
                //没有检测课程是否安排完了
                courseCell.append(course);
            }
        }
        arrangeCourse(courseCell, numRoom: roomNum!);
    }
    
    func arrangeCourse(availableCourse: Array<PFObject>, numRoom:Int){
        var courseCalendar : Array<Array<PFObject>>?;
        if availableCourse.count == 1 {
            var courseCoop = Array<PFObject>();
            courseCoop.append(availableCourse[0]);
            courseCalendar?.append(courseCoop);
            print("there is only one course available in that time, \(availableCourse[0]["name"]).")
        }else if availableCourse.count == 2{
            let lecturer1 = availableCourse[0]["lecturer"] as! PFObject;
            let lecturer2 = availableCourse[1]["lecturer"] as! PFObject;
            var courseShare = true;
            if  lecturer1 != lecturer2 {
                var students1: Array<String> = [];
                var students2: Array<String> = [];
                if (availableCourse[0]["students"] != nil) {
                    students1 = availableCourse[0]["students"] as! Array<String>;
                }
                if (availableCourse[1]["students"] != nil){
                    students2 = availableCourse[1]["students"] as! Array<String>;
                }
                if (students1 != []) && (students2 != [])  {
                    for st1 in students1 {
                        if students2.contains(st1){
                            courseShare = false;
                            print("\(availableCourse[0]["name"]) and \(availableCourse[1]["name"]) CANT both stay in this time because of same STUDENT")
                        }
                    }
                }
            } else {
                courseShare = false;
                print("\(availableCourse[0]["name"]) and \(availableCourse[1]["name"]) CANT both stay in this time because of same LECTURER")
            }
            if courseShare {
                var courseCoop = Array<PFObject>();
                courseCoop.append(availableCourse[0]);
                courseCoop.append(availableCourse[1]);
                courseCalendar?.append(courseCoop);
                print("there is two courses available in that time, \(availableCourse[0]["name"]) and \(availableCourse[1]["name"]).")
            }
        }else if availableCourse.count > 2{
            var courseCalendar : Array<Array<PFObject>>?;
            //通过set的交集来求课程的学生是不是互斥
            for (var i = 0; i < availableCourse.count - 2; i++) {
                var stuISet: Set<String> = [];
                let lecturerI = availableCourse[i]["lecturer"] as! PFObject;
                for studentID in availableCourse[i]["students"] as! Array<String> {
                    stuISet.insert(studentID);
                }
                for (let j = i + 1; j < availableCourse.count - 1; i++){
                    var stuJSet: Set<String> = [];
                    let lecturerJ = availableCourse[j]["lecturer"] as! PFObject;
                    for studentID in availableCourse[j]["students"] as! Array<String> {
                        stuJSet.insert(studentID);
                    }
                    for(let k = j + 1; k < availableCourse.count; i++){
                        var stuKSet: Set<String> = [];
                        let lecturerK = availableCourse[k]["lecturer"] as! PFObject;
                        for studentID in availableCourse[k]["students"] as! Array<String> {
                            stuKSet.insert(studentID);
                        }
                        if lecturerI != lecturerJ && lecturerI != lecturerJ && lecturerJ != lecturerK {
                            if !stuISet.intersect(stuJSet).isEmpty && !stuJSet.intersect(stuKSet).isEmpty && !stuISet.intersect(stuKSet).isEmpty {
                                var courseCoop = Array<PFObject>();
                                courseCoop.append(availableCourse[i]);
                                courseCoop.append(availableCourse[j]);
                                courseCoop.append(availableCourse[k]);
                                courseCalendar?.append(courseCoop);
                                print("\(availableCourse[i]["name"]) \(availableCourse[j]["name"]) \(availableCourse[k]["name"]) CAN be added at same time: \(time)");
                            }else{
                                print("\(availableCourse[i]["name"]) \(availableCourse[j]["name"]) \(availableCourse[k]["name"]) CAN NOT be added at same time: \(time) because of same students");
                            }
                        }else{
                            print("\(availableCourse[i]["name"]) \(availableCourse[j]["name"]) \(availableCourse[k]["name"]) CAN NOT be added at same time: \(time) because of same lecturer \(availableCourse[i]["lecturer"]["name"])");
                        }
                    }
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
