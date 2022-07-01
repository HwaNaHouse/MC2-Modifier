//
//  Category+CoreDataProperties.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/07/01.
//
//

import CoreData
import SwiftUI

extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var categoryColor: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var photoName: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String
    @NSManaged public var uuid: UUID
    @NSManaged public var photo: Photo?
    @NSManaged public var pin: NSSet?
    
    public var pinArray: [Pin] {
        let pinSet = pin as? Set<Pin> ?? []
        return pinSet.sorted {
            $0.createAt > $1.createAt
        }
    }
    
    public var convertedColor: Color {
        return Color(categoryColor ?? "default")
    }

}

// MARK: Generated accessors for photo
extension Category {

    @objc(addPhotoObject:)
    @NSManaged public func addToPhoto(_ value: Photo)

    @objc(removePhotoObject:)
    @NSManaged public func removeFromPhoto(_ value: Photo)

    @objc(addPhoto:)
    @NSManaged public func addToPhoto(_ values: NSSet)

    @objc(removePhoto:)
    @NSManaged public func removeFromPhoto(_ values: NSSet)

}

// MARK: Generated accessors for pin
extension Category {

    @objc(addPinObject:)
    @NSManaged public func addToPin(_ value: Pin)

    @objc(removePinObject:)
    @NSManaged public func removeFromPin(_ value: Pin)

    @objc(addPin:)
    @NSManaged public func addToPin(_ values: NSSet)

    @objc(removePin:)
    @NSManaged public func removeFromPin(_ values: NSSet)

}

extension Category : Identifiable {

}
