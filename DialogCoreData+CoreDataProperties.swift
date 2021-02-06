//
//  DialogCoreData+CoreDataProperties.swift
//  Chatting
//
//  Created by Yuriy Balabin on 28.01.2021.
//  Copyright © 2021 None. All rights reserved.
//
//

import Foundation
import CoreData


extension DialogCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DialogCoreData> {
        return NSFetchRequest<DialogCoreData>(entityName: "DialogCoreData")
    }

    @NSManaged public var masterUsername: String?
    @NSManaged public var messages: NSSet?
    @NSManaged public var unreadMessages: NSSet?
    @NSManaged public var user: UserCoreData?

}

// MARK: Generated accessors for messages
extension DialogCoreData {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageCoreData)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageCoreData)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

// MARK: Generated accessors for unreadMessages
extension DialogCoreData {

    @objc(addUnreadMessagesObject:)
    @NSManaged public func addToUnreadMessages(_ value: MessageCoreData)

    @objc(removeUnreadMessagesObject:)
    @NSManaged public func removeFromUnreadMessages(_ value: MessageCoreData)

    @objc(addUnreadMessages:)
    @NSManaged public func addToUnreadMessages(_ values: NSSet)

    @objc(removeUnreadMessages:)
    @NSManaged public func removeFromUnreadMessages(_ values: NSSet)

}
