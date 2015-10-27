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
    var itemList: Array<PFObject>?;
    var dateList: Array<NSDate>?;
    var itemName: Array<String>?;
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var hourTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "add new \(type!)";
        self.datePickerChosen();
        self.itemPickerChosen();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let item = itemName![itemPicker.selectedRowInComponent(0)];
        if itemTextField.text == "" {
            itemTextField.text = item as! String
        } else {
            itemTextField.text = "\(itemTextField.text!); \(item)"
        }
    }

    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ((itemList?.count) == nil) {
            return 0
        }else{
            return itemList!.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (itemName != nil){
            return itemName![row]
        }else{
            return nil
        }
        
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
        
    }
}
