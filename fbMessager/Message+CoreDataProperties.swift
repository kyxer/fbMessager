//
//  Message+CoreDataProperties.swift
//  fbMessager
//
//  Created by IT-German on 3/22/17.
//  Copyright © 2017 german. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var friend: Friend?

}
