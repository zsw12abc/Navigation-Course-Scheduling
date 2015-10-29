//
//  ViewController.swift
//  Navigation Course Scheduling
//
//  Created by ShaoweiZhang on 15/10/26.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func courseButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("courseSegue", sender: sender);
    }

    @IBAction func lecturerButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("lecturerSegue", sender: sender);
    }
    @IBAction func studentButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("studentSegue", sender: sender);
    }
    @IBAction func scheduleButtonPressed(sender: UIButton) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "courseSegue" {
            let vc = segue.destinationViewController as! DetailTableViewController;
            vc.type = "Course";
        }else if segue.identifier == "lecturerSegue" {
            let vc = segue.destinationViewController as! DetailTableViewController;
            vc.type = "Lecturer";
        }else if segue.identifier == "studentSegue" {
            let vc = segue.destinationViewController as! DetailTableViewController;
            vc.type = "Student";
        }
    }
}

