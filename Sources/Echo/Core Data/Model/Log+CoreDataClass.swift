//
//  Log+CoreDataClass.swift
//  Echo_iOS
//
//  Created by Adam Dahan on 2021-07-05.
//
//

import Foundation
import CoreData

@objc(Log)
public class Log: NSManagedObject {

    public override var description: String {
        var desc = ""
        
        if let uuid = uuid {
            desc += "uuid: \(uuid), "
        }
        
        if let date = date {
            desc += "date: \(date), "
        }
                
        if let location = location {
            desc += "location: \(location), "
        }
        
        if let data = data {
            desc += "data: \(data), "
        }
        
        return desc
    }
}
