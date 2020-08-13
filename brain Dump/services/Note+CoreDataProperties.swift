//
//  Note+CoreDataProperties.swift
//  brain Dump
//
//  Created by natarajan k on 13/08/19.
//  Copyright © 2019 natarajan k. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var body: String?
    @NSManaged public var category: Category?

}
