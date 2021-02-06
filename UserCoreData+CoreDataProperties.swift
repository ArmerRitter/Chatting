//
//  UserCoreData+CoreDataProperties.swift
//  Chatting
//
//  Created by Yuriy Balabin on 28.01.2021.
//  Copyright © 2021 None. All rights reserved.
//
//

import Foundation
import CoreData


extension UserCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCoreData> {
        return NSFetchRequest<UserCoreData>(entityName: "UserCoreData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var username: String?

}
