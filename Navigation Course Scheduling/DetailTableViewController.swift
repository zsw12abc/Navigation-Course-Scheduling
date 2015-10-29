//
//  DetailTableViewController.swift
//  Navigation Course Scheduling
//
//  Created by ShaoweiZhang on 15/10/26.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import UIKit
import Parse


class DetailTableViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var type :String?;
    var detailIDList: Array<String> = [];
    var detailObjectList: Array<PFObject> = [];
    var refreshControl:UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad();
//        tableView.reloadData();
        print("detailIDList.count: \(detailIDList.count)");
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "onPullToFresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.attributedTitle=NSAttributedString(string: "松手就可以刷新啦")
        self.tableView.addSubview(refreshControl!)
//        self.refreshControl?.hidden = true;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationItem.title = type;
        if (type != nil) {
            downloadData(type!);
        }
    }
    
    func onPullToFresh(){
        dispatch_async(dispatch_get_main_queue(), {
            self.downloadData(self.type!);
            self.refreshControl?.endRefreshing();
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
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
                self.detailIDList = [];
                self.detailObjectList = [];
                if let objects = objects {
                    for object in objects {
//                        print("\(self.type): \(object.objectId)");
                        self.detailIDList.append(object.objectId!);
                        self.detailObjectList.append(object);
                    }
                }
                self.tableView.reloadData();
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    @available(iOS 2.0, *)
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return detailObjectList.count;
    }
    
    //删除数据
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == UITableViewCellEditingStyle.Delete{
            if type == "Course" {
                let course = detailObjectList[indexPath.row];
                if course["lecturer"] != nil {
                let lecturerQuery = PFQuery(className:"Lecturer")
                    lecturerQuery.getObjectInBackgroundWithId(course["lecturer"].objectId!!) {
                        (lecturer: PFObject?, error: NSError?) -> Void in
                        if error == nil && lecturer != nil {
                            lecturer!.removeObjectsInArray([course.objectId!], forKey: "courses");
                            lecturer!.saveInBackground();
                        } else {
                            print(error)
                        }
                    }
                }
//                if course["student"]
                let studentQuery = PFQuery(className: "Student");
                studentQuery.findObjectsInBackgroundWithBlock({ (students, error) -> Void in
                    if error == nil {
                        for student in students! {
                            student.removeObjectsInArray([course.objectId!], forKey: "courses");
                            student.saveInBackground();
                        }
                    }else{
                        print(error);
                    }
                })
                course.deleteInBackground();
                print("\(course["name"]) is deleted");
            }else if type == "Lecturer" {
                let lecturer = detailObjectList[indexPath.row];
                let query = PFQuery(className: "Course");
                query.findObjectsInBackgroundWithBlock({ (courses, error) -> Void in
                    if error == nil {
                        for course in courses! {
                            if (course["lecturer"] != nil) {
                                if course["lecturer"].objectId == lecturer.objectId {
                                    print("delete lecturer \(course["lecturer"].objectId) from course \(course["name"])");
                                    course.removeObjectForKey("lecturer")
                                    course.saveInBackground();
                                }
                            }
                        }
                    }else{
                        print(error);
                    }
                })
                lecturer.deleteInBackground();
            }else if type == "Student" {
                let student = detailObjectList[indexPath.row];
                let query = PFQuery(className: "Course");
                query.findObjectsInBackgroundWithBlock({ (courses, error) -> Void in
                    if error != nil {
                        print(error);
                    }else{
                        for course in courses! {
                            course.removeObjectsInArray([student.objectId!], forKey: "students")
                            course.saveInBackground();
                        }
                    }
                })
                student.deleteInBackground();
            }
            detailObjectList.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath);
        let title = cell.viewWithTag(101) as! UILabel;
        let subTitle1 = cell.viewWithTag(102) as! UILabel;
        let subTitle2 = cell.viewWithTag(103) as! UILabel;
        
        if type == "Course" {
            let course = detailObjectList[indexPath.row];
            title.text = "\(course["name"])";
            title.textColor = UIColor.redColor();
            if course["lecturer"] == nil {
                subTitle1.text = "No Lecturer";
            }else{
                print("lecutrer point: \(course["lecturer"])")
                let query = PFQuery(className:"Lecturer")
                query.getObjectInBackgroundWithId(course["lecturer"].objectId!!) {
                    (lecturer: PFObject?, error: NSError?) -> Void in
                    if error == nil && lecturer != nil {
                        subTitle1.text = "Lecturer: \(lecturer!["name"])";
                    } else {
                        print(error)
                    }
                }
            }
            subTitle2.text = "\(course["hours"])hours";
        }else if type == "Lecturer" {
            let lecturer = detailObjectList[indexPath.row];
            title.text = "\(lecturer["name"])";
            title.textColor = UIColor.blueColor();
            subTitle1.text = "\(lecturer["phone"])";
            subTitle2.text = "\(lecturer["email"])";
            subTitle2.sizeToFit();
        }else if type == "Student" {
            let student = detailObjectList[indexPath.row];
            title.text = "\(student["name"])";
            title.textColor = UIColor.blueColor();
            subTitle1.text = "\(student["phone"])";
            subTitle2.text = "\(student["email"])";
            subTitle2.sizeToFit();
        }

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addSegue", sender: sender);
    }
    
    @IBAction func close(segue: UIStoryboardSegue){
        print("closed");
        tableView.reloadData();
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "changeSegue" {
            let vc = segue.destinationViewController as! DetailViewController;
            let indexPath = tableView.indexPathForSelectedRow;
            vc.type = type;
            if let index = indexPath?.row {
                vc.itemSelected = detailObjectList[index];
            }
        } else if segue.identifier == "addSegue" {
            let vc = segue.destinationViewController as! DetailViewController;
            vc.type = type;
        }

    }
}