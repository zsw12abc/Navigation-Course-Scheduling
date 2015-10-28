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
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var hourTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "add new \(type!)";
        print("type: \(type)");
        if (type! == "Course") {
            downloadData("Lecturer");
        }else{
            downloadData("Course");
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
                    self.datePickerChosen();
                    self.itemPickerChosen();
                   self.itemPicker.reloadAllComponents();
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    
    func datePickerChosen() {
        let customView:UIView = UIView (frame: CGRectMake(0, 100, self.view.frame.size.width, 160))
        customView.backgroundColor = UIColor.whiteColor()
        datePicker = UIDatePicker(frame: CGRectMake(0, 0, self.view.frame.size.width, 160))
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        customView .addSubview(datePicker)
        dateTextField.inputView = customView
        let doneButton:UIButton = UIButton (frame: CGRectMake(100, 100, self.view.frame.size.width, 44))
        doneButton.setTitle("选择", forState: UIControlState.Normal)
        doneButton.addTarget(self, action: "datePickerSelected", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.backgroundColor = UIColor .blueColor()
        dateTextField.inputAccessoryView = doneButton
    }
    
    func itemPickerChosen(){
        let customView:UIView = UIView (frame: CGRectMake(0, 100, self.view.frame.size.width, 160))
        customView.backgroundColor = UIColor.whiteColor()
        itemPicker = UIPickerView(frame: CGRectMake(0, 0, self.view.frame.size.width, 160));
        itemPicker.delegate = self;
        itemPicker.dataSource = self;
        customView .addSubview(itemPicker)
        itemTextField.inputView = customView
        let doneButton:UIButton = UIButton (frame: CGRectMake(100, 100, self.view.frame.size.width, 44))
        doneButton.setTitle("选择", forState: UIControlState.Normal)
        doneButton.addTarget(self, action: "itemPickerSelected", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.backgroundColor = UIColor .blueColor()
        itemTextField.inputAccessoryView = doneButton
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
        print(itemTextField.text);
        let item = itemName[itemPicker.selectedRowInComponent(0)];
//        if itemTextField.text == "" {
            itemTextField.text = item
//        } else {
//            itemTextField.text = "\(itemTextField.text!); \(item)"
//        }
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
        var lecturer: PFObject?;
        print("itemTextField: \(itemTextField.text)");
        print("dateTextField: \(dateTextField.text)");
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

        course.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("added new course: \(course)");
                lecturer!.addUniqueObjectsFromArray([course.objectId!], forKey: "courses")
                lecturer!.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
                if (success) {
                        print("added course to lecturer: \(lecturer)");
                    }else{
                        print(error);
                    }
                }
            } else {
                // There was a problem, check error.description
                print(error);
            }
        }
    }
}
