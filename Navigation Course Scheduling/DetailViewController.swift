//
//  DetailViewController.swift
//  Navigation Course Scheduling
//
//  Created by ShaoweiZhang on 15/10/27.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import UIKit
import Parse
import Social

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var type: String?;
    var datePicker:UIDatePicker!
    var itemPicker: UIPickerView!
    var itemList: Array<PFObject> = [];
//    var dateList: Array<NSDate>?;
    var itemName: Array<String> = [];
    var itemSelected : PFObject?;
    var oldLecturerID: String?;
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var hourTextField: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thridLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        print("type: \(type)");
        if (type! == "Course") {
            downloadData("Lecturer");
            self.datePickerChosen(dateTextField);
            self.itemPickerChosen(itemTextField);
            self.hourTextField.keyboardType = UIKeyboardType.NumberPad;
            if (itemSelected != nil) {
                self.navigationItem.title = "Change \(itemSelected!["name"])";
                self.nameTextField.text = (itemSelected!["name"] as! String);
                self.hourTextField.text = "\(itemSelected!["hours"])";
                if itemSelected!["lecturer"] != nil {
                    self.oldLecturerID = itemSelected!["lecturer"].objectId;
                    self.itemTextField.text = "id: \(itemSelected!["lecturer"].objectId)";
                    let query = PFQuery(className: "Lecturer");
                    query.getObjectInBackgroundWithId(itemSelected!["lecturer"].objectId!!) {
                        (lecturer: PFObject?, error: NSError?) -> Void in
                        if error == nil && lecturer != nil {
                            self.itemTextField.text = (lecturer!["name"] as! String);
                        } else {
                            print(error)
                        }
                    }
                }
                if (itemSelected!["schedule"] != nil){
                    var dateResult = "";
                    let dateArray: Array<NSDate> = itemSelected!["schedule"] as! Array<NSDate>;
                    for d in dateArray {
                        if dateResult == "" {
                            dateResult = timeToString(d);
                        }else{
                            dateResult = "\(dateResult); \(timeToString(d))";
                        }
                    }
                    self.dateTextField.text = dateResult;
                }
            }else{
                self.navigationItem.title = "add new \(type!)";
            }
        }else if (type == "Lecturer"){
//            downloadData("Course");
            self.secondLabel.text = "Phone:";
            self.thridLabel.text = "Email:";
            self.lastLabel.text = "Schedule:"
            self.hourTextField.keyboardType = UIKeyboardType.NumberPad;
            self.itemTextField.keyboardType = UIKeyboardType.EmailAddress;
            self.datePickerChosen(dateTextField);
            if (itemSelected != nil) {
                self.navigationItem.title = "Change \(itemSelected!["name"])";
                self.nameTextField.text = itemSelected!["name"] as? String;
                self.hourTextField.text = itemSelected!["phone"] as? String;
                self.itemTextField.text = itemSelected!["email"] as? String;
                if (itemSelected!["schedule"] != nil){
                    var dateResult = "";
                    let dateArray: Array<NSDate> = itemSelected!["schedule"] as! Array<NSDate>;
                    for d in dateArray {
                        if dateResult == "" {
                            dateResult = timeToString(d);
                        }else{
                            dateResult = "\(dateResult); \(timeToString(d))";
                        }
                    }
                    self.dateTextField.text = dateResult;
                }
            }else{
                self.navigationItem.title = "add new \(type!)";
            }
        }else if (type == "Student"){
            downloadData("Course");
            self.secondLabel.text = "Phone:";
            self.thridLabel.text = "Email:";
            self.lastLabel.text = "Course:"
            self.hourTextField.keyboardType = UIKeyboardType.NumberPad;
            self.itemTextField.keyboardType = UIKeyboardType.EmailAddress;
            self.itemPickerChosen(dateTextField);
            if (itemSelected != nil) {
                self.navigationItem.title = "Change \(itemSelected!["name"])";
                self.nameTextField.text = itemSelected!["name"] as? String;
                self.hourTextField.text = itemSelected!["phone"] as? String;
                self.itemTextField.text = itemSelected!["email"] as? String;
            }else{
                self.navigationItem.title = "add new \(type!)";
            }
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadData(type: String){
        let query = PFQuery(className: type);
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print("\(type): \(object.objectId)");
                        self.itemName.append(object["name"] as! String);
                        self.itemList.append(object);
                    }
                    if (self.type == "Course") {
                        self.itemPicker.reloadAllComponents();
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    
    func datePickerChosen(textField: UITextField) {
        let customView:UIView = UIView (frame: CGRectMake(0, 100, self.view.frame.size.width, 160))
        customView.backgroundColor = UIColor.whiteColor()
        datePicker = UIDatePicker(frame: CGRectMake(0, 0, self.view.frame.size.width, 160))
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        customView .addSubview(datePicker)
        textField.inputView = customView
        let doneButton:UIButton = UIButton (frame: CGRectMake(100, 100, self.view.frame.size.width, 44))
        doneButton.setTitle("选择", forState: UIControlState.Normal)
        doneButton.addTarget(self, action: "datePickerSelected", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.backgroundColor = UIColor .blueColor()
        textField.inputAccessoryView = doneButton
    }
    
    func itemPickerChosen(textField: UITextField){
        let customView:UIView = UIView (frame: CGRectMake(0, 100, self.view.frame.size.width, 160))
        customView.backgroundColor = UIColor.whiteColor()
        itemPicker = UIPickerView(frame: CGRectMake(0, 0, self.view.frame.size.width, 160));
        itemPicker.delegate = self;
        itemPicker.dataSource = self;
        customView .addSubview(itemPicker)
        textField.inputView = customView
        let doneButton:UIButton = UIButton (frame: CGRectMake(100, 100, self.view.frame.size.width, 44))
        doneButton.setTitle("选择", forState: UIControlState.Normal)
        doneButton.addTarget(self, action: "itemPickerSelected", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.backgroundColor = UIColor .blueColor()
        textField.inputAccessoryView = doneButton
    }
    
    func datePickerSelected() {
        print(dateTextField.text);
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm +1000"
        let date = dateFormatter.stringFromDate(datePicker.date)
        if (dateTextField.text == "") {
            dateTextField.text =  date;
        }else{
            dateTextField.text = "\(dateTextField.text!); \(date)";
        }
    }
    
    func itemPickerSelected(){
        var textField: UITextField?;
        if type == "Course" {
            textField = itemTextField;
        }else{
            textField = dateTextField;
        }
        print(textField!.text);
        let item = itemName[itemPicker.selectedRowInComponent(0)];
        if type == "Course" {
            textField!.text = item;
        }else{
            if textField!.text == "" {
                textField!.text = item;
            } else {
                if textField!.text!.rangeOfString(item) == nil{
                    textField!.text = "\(textField!.text!); \(item)";
                }
            }
        }
    }
    
    func stringToTime(time: String) -> NSDate{
        let formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm +1000";
//        formatter.timeZone = NSTimeZone(name: "UTC");
        let date = formatter.dateFromString(time)!;
        
        return date;
    }
    
    func stringToTimeString(time: String) -> String{
        let formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm +1000";
//        formatter.timeZone = NSTimeZone(name: "UTC");
        let date = formatter.dateFromString(time)!;
        formatter.dateFormat = "yyyy-MM-dd HH:mm +1000";
        let dateString = formatter.stringFromDate(date);
        return dateString;
    }
    
    func timeToString(date: NSDate) -> String{
        let formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm +1000";
//        formatter.timeZone = NSTimeZone(name: "UTC");
        let dateString = formatter.stringFromDate(date);
        return dateString;
    }


    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemList.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemName[row]
    }

    
    //点击键盘 enter 后会去掉焦点(自动隐藏键盘)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dateTextField.resignFirstResponder();
        nameTextField.resignFirstResponder();
        hourTextField.resignFirstResponder();
        itemTextField.resignFirstResponder();
        return true
    }
    
    //点击其他地方也去掉焦点
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dateTextField.resignFirstResponder();
        nameTextField.resignFirstResponder();
        hourTextField.resignFirstResponder();
        itemTextField.resignFirstResponder();
    }
    
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        //Course 界面的提交数据
        if (type == "Course") {
            if (itemSelected == nil){
                if nameTextField.text != "" && hourTextField.text != "" && dateTextField.text != "" && itemTextField.text != "" {
                    var lecturer: PFObject?;
                    let course = PFObject(className:type!);
                    course["name"] = nameTextField.text;
                    course["hours"] = Int(hourTextField.text!);
                    if (itemTextField.text != "" && itemTextField.text != nil) {
                        lecturer = itemList[itemName.indexOf(itemTextField.text!)!];
                        print("lecturer is \(lecturer)");
            //            course["lecturer"] = PFObject(withoutDataWithClassName:"Lecturer", objectId:lecturer.objectId);
                        course["lecturer"] = lecturer;
                    }
                    if (dateTextField.text != "" && dateTextField.text != nil) {
                        let dateString = dateTextField.text;
                        let dateArray = dateString?.componentsSeparatedByString("; ");
                        var dateList = Array<NSDate>();
                        for d in dateArray! {
                            let date = stringToTime(d);
                            dateList.append(date);
                        }
                        print("dateList: \(dateList)");
                        course["schedule"] = dateList;
                    }

                    course.saveEventually{
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                            print("added new course: \(course)");
                            lecturer!.addUniqueObjectsFromArray([course.objectId!], forKey: "courses")
                            lecturer!.saveEventually();
//                            lecturer!.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
//                            if (success) {
//                                    print("added course to lecturer: \(lecturer)");
//                                }else{
//                                    print(error);
//                                }
//                            }
                        } else {
                            // There was a problem, check error.description
                            print(error);
                        }
                    }
                }
            }else{
                let query = PFQuery(className:type!);
                query.getObjectInBackgroundWithId((itemSelected?.objectId)!) {
                    (course: PFObject?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else if let course = course {
                        var lecturer: PFObject?;
                        course["name"] = self.nameTextField.text;
                        course["hours"] = Int(self.hourTextField.text!);
                        if (self.itemTextField.text != "" && self.itemTextField.text != nil) {
                            lecturer = self.itemList[self.itemName.indexOf(self.itemTextField.text!)!];
                            print("lecturer is \(lecturer)");
                            if lecturer!.objectId != self.oldLecturerID {
                                course["lecturer"] = lecturer;
                            }
                        }
                        if (self.dateTextField.text != "" && self.dateTextField.text != nil) {
                            let dateString = self.dateTextField.text;
                            let dateArray = dateString?.componentsSeparatedByString("; ");
                            var dateList = Array<NSDate>();
                            for d in dateArray! {
                                let date = self.stringToTime(d);
                                dateList.append(date);
                            }
                            print("dateList: \(dateList)");
                            course["schedule"] = dateList;
                        }
                        course.saveEventually();
                        if lecturer!.objectId != self.oldLecturerID {
                            lecturer!.addUniqueObjectsFromArray([course.objectId!], forKey: "courses");
                            lecturer!.saveEventually();
                            for l in self.itemList {
                                if l.objectId == self.oldLecturerID {
                                    l.removeObjectsInArray([course.objectId!], forKey: "courses");
                                    l.saveEventually();
                                    print("\(l["name"]) \(self.itemSelected!["lecturer"].objectId) courseID should be removed: \(course.objectId)");
                                }
                            }
                        }
                    }
                }
            }
        } else if type == "Lecturer"{
            if (itemSelected == nil){
                let lecturer = PFObject(className: type!);
                lecturer["name"] = nameTextField.text;
                lecturer["phone"] = hourTextField.text;
                lecturer["email"] = itemTextField.text;
                if (dateTextField.text != "" && dateTextField.text != nil) {
                    let dateString = dateTextField.text;
                    let dateArray = dateString?.componentsSeparatedByString("; ");
                    var dateList = Array<NSDate>();
                    for d in dateArray! {
                        let date = stringToTime(d);
                        dateList.append(date);
                    }
                    print("dateList: \(dateList)");
                    lecturer["schedule"] = dateList;
                }
                lecturer.saveEventually({ (success, error) -> Void in
                    if success {
                        print("added new lecturer: \(lecturer)");
                    }else{
                        print(error);
                    }
                })
            }else{
                if nameTextField.text != "" && hourTextField.text != "" && dateTextField.text != "" && itemTextField.text != "" {
                    let query = PFQuery(className: type!);
                    query.getObjectInBackgroundWithId(itemSelected!.objectId!, block: { (lecturer, error) -> Void in
                        if error != nil {
                            print(error);
                        }else if let lecturer = lecturer{
                            lecturer["name"] = self.nameTextField.text;
                            lecturer["phone"] = self.hourTextField.text;
                            lecturer["email"] = self.itemTextField.text;
                            if (self.dateTextField.text != "" && self.dateTextField.text != nil) {
                                let dateString = self.dateTextField.text;
                                let dateArray = dateString?.componentsSeparatedByString("; ");
                                var dateList = Array<NSDate>();
                                for d in dateArray! {
                                    let date = self.stringToTime(d);
                                    dateList.append(date);
                                }
                                print("dateList: \(dateList)");
                                lecturer["schedule"] = dateList;
                            }
                            lecturer.saveEventually();
                        }
                    })
                }
            }
        }
    }
}
