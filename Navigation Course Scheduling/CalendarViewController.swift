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

    override func viewDidLoad() {
        super.viewDidLoad()
//        var calendar: Array<hourSchedule<PFObject>>?;
//        for (var i = 0; i <= totalDays; i++){
//            let daySchedule = hourSchedule<PFObject>(columns: roomNum!, rows: 9);
//            calendar?.append(daySchedule);
//            
//        }
//        print("calendar: \(calendar?.count)")
        print("startDate: \(startDate!)");
        print("endDate: \(endDate!)");
        print("room num: \(roomNum!)");
        print("course Hours: \(courseHours!)");
        
        for (var i = 0; startDate! + i.day <= endDate!; i++){
//            print(i);
            if (startDate! + i.day == endDate!){
                print("Total Days are:  \(i) days");
                totalDays = i;
            }
        }
        
        let courseQuery = PFQuery(className: "Course");
        let lecturerQuery = PFQuery(className: "Lecturer");
        let studentQuery = PFQuery(className: "Student");
        courseQuery.findObjectsInBackgroundWithBlock { (courses, error) -> Void in
            if error == nil {
               if let courses = courses{
                    for course in courses {
                        self.courseList.append(course);
                        self.totalHours = self.totalHours + (course["hours"] as! Int);
                    }
                }
                print("Total Hours are: \(self.totalHours)hours");
                if self.totalHours > self.totalDays * 8 * self.roomNum!{
                    print("not enought time")
                }else{
                    print("enought time")
                }
            }else{
                print("courseQuery: \(error)");
            }
        }
        lecturerQuery.findObjectsInBackgroundWithBlock { (lecturers, error) -> Void in
            if error == nil {
                if let lecturers = lecturers {
                    for lecturer in lecturers{
                        self.lecturerList.append(lecturer);
                    }
                }
            } else {
                print("lecturerQuery: \(error)");
            }
        }
        studentQuery.findObjectsInBackgroundWithBlock { (students, error) -> Void in
            if error == nil {
                if let students = students {
                    for student in  students {
                        self.studentList.append(student);
                    }
                }
            }else {
                print("studentQuery: \(error)");
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
