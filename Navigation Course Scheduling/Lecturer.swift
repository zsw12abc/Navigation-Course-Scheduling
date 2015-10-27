//
//  Lecturer.swift
//  Navigation Course Scheduling
//
//  Created by ShaoweiZhang on 15/10/26.
//  Copyright © 2015年 ShaoweiZhang. All rights reserved.
//

import UIKit
import Parse

class Lecturer : PFObject, PFSubclassing {
    @NSManaged var name: String;
    @NSManaged var phone: String;
    @NSManaged var email: String;
    @NSManaged var courses: Array<PFObject>;
    @NSManaged var schedule: Array<NSDate>;
    @NSManaged var id: String;
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Lecturer"
    }

    init(name: String) {
        super.init()
        self.name = name;
    }
    
    override init() {
        super.init()
    }
    
    func getObjectIDByCol(colName: String, name: String) -> String{
        let query = PFQuery(className: Lecturer.parseClassName())
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
    
    func getObjectByID(id: String) -> PFObject{
        var result = PFObject();
        let query = PFQuery(className:Lecturer.parseClassName())
        query.getObjectInBackgroundWithId(id) {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil {
                print(object)
                result = object!;
            } else {
                print(error)
            }
        }
        return result;
    }
}