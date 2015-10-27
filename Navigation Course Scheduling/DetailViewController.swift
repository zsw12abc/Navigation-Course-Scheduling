//
//  DetailViewController.swift
//  Navigation Course Scheduling
//
//  Created by ShaoweiZhang on 15/10/27.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController {
    var type: String?;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "add new \(type!)";
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
