//
//  MessageCoreData+CoreDataProperties.swift
//  Chatting
//
//  Created by Yuriy Balabin on 28.01.2021.
//  Copyright © 2021 None. All rights reserved.
//
//

import Foundation
import CoreData


extension MessageCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageCoreData> {
        return NSFetchRequest<MessageCoreData>(entityName: "MessageCoreData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var text: String?
    @NSManaged public var reciever: UserCoreData?
    @NSManaged public var sender: UserCoreData?

}
