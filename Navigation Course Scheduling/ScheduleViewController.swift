//
//  ScheduleViewController.swift
//  Navigation Course Scheduling
//
//  Created by ShaoweiZhang on 15/10/30.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import UIKit
import Parse

class ScheduleViewController: UIViewController {



    @IBOutlet weak var courseHoursLabel: UILabel!
    @IBOutlet weak var roomNumLabel: UILabel!
    @IBOutlet weak var courseHoursTextField: UITextField!
    @IBOutlet weak var roomNumTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var courseHours : Int?;
    var roomNum : Int?;
    var startDate : NSDate?
    var endDate : NSDate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courseHoursLabel.text = "*课时:"
        roomNumLabel.text = "*教室数量:"
        courseHoursLabel.textColor = UIColor.redColor();
        roomNumLabel.textColor = UIColor.redColor();
        // Do any additional setup after loading the view.
        //设置默认输入
        courseHoursTextField.text = "2";
        roomNumTextField.text = "3";
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
    


    @IBAction func scheduleButtonPressed(sender: UIButton) {
        courseHours = Int(courseHoursTextField.text!);
        roomNum = Int(roomNumTextField.text!);
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startDate = startDatePicker.date;
        endDate = endDatePicker.date;
        let startString = dateFormatter.stringFromDate(startDate!);
        let endString = dateFormatter.stringFromDate(endDate!);
        startDate = dateFormatter.dateFromString(startString)!.toTimezone("UTC+10");
        endDate = dateFormatter.dateFromString(endString)!.toTimezone("UTC+10");
//        print("startDate: \(startDate!) \n endDate: \(endDate!)");
//        print((endDate!  - 1.day) == startDate!);
        if courseHoursTextField.text != "" && roomNumTextField.text != ""{
            if endDate > startDate {
                performSegueWithIdentifier("calendarSegue", sender: sender);
            }
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "calendarSegue" {
            let vc = segue.destinationViewController as! CalendarViewController;
            vc.courseHours = courseHours;
            vc.roomNum = roomNum;
            vc.startDate = startDate;
            vc.endDate = endDate;
        }
    }
}
