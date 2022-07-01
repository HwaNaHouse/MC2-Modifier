//
//  Pin+CoreDataProperties.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/07/01.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var content: String?
    @NSManaged public var createAt: Date
    @NSManaged public var emotion: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var placeName: String?
    @NSManaged public var uuid: UUID
    @NSManaged public var category: Category
    @NSManaged public var photo: NSSet?

}

// MARK: Generated accessors for photo
extension Pin {

    @objc(addPhotoObject:)
    @NSManaged public func addToPhoto(_ value: Photo)

    @objc(removePhotoObject:)
    @NSManaged public func removeFromPhoto(_ value: Photo)

    @objc(addPhoto:)
    @NSManaged public func addToPhoto(_ values: NSSet)

    @objc(removePhoto:)
    @NSManaged public func removeFromPhoto(_ values: NSSet)

}

extension Pin : Identifiable {

}
