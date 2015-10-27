//
//  NCS.swift
//  Navigation Course Scheduling
//
//  Created by ShaoweiZhang on 15/10/26.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import Foundation
import Parse

public func getObjectIDByCol(className: String, colName: String, name: String) -> String{
    let query = PFQuery(className: className)
    query.whereKey(colName, equalTo:name)
    var id: String = "";
    query.whereKey(colName, equalTo: name)
    query.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
        
        if error == nil {
            // The find succeeded.
            print("Successfully retrieved \(objects!.count) scores.")
            // Do something with the found objects
            if let objects = objects {
                for object in objects {
                    print(object.objectId)
                    id = object.objectId!;
                }
            }
        } else {
            // Log details of the failure
            print("Error: \(error!) \(error!.userInfo)")
            id = "error"
        }
    }
    return id;
}