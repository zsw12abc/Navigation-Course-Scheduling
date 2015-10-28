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
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationItem.title = type;
        if (type != nil) {
            downloadData(type!);
        }
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
                if let objects = objects {
                    for object in objects {
                        print("\(self.type): \(object.objectId)");
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
            detailObjectList.removeAtIndex(indexPath.row)
            //Parse的数据库没有删除
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
                
            }else{
                print("lecutrer point: \(course["lecturer"])")
                var query = PFQuery(className:"Lecturer")
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "changeSegue" {
            let vc = segue.destinationViewController as! DetailViewController;
            let indexPath = tableView.indexPathForSelectedRow;
            if let index = indexPath {
               //修改还没写
            }
        } else if segue.identifier == "addSegue" {
            let vc = segue.destinationViewController as! DetailViewController;
            vc.type = type;
        }

    }
}