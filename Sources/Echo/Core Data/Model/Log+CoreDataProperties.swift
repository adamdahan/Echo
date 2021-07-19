//
//  Log+CoreDataProperties.swift
//  Echo_iOS
//
//  Created by Adam Dahan on 2021-07-05.
//
//

import Foundation
import CoreData

extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var uuid: String?
    @NSManaged public var location: String?
    @NSManaged public var date: Date?
    @NSManaged public var data: String?

}
