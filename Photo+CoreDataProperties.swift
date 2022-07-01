//
//  Photo+CoreDataProperties.swift
//  Mc2_Modifier
//
//  Created by Hyeonsoo Kim on 2022/07/01.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photoName: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var category: Category?
    @NSManaged public var pin: Pin?

}

extension Photo : Identifiable {

}
