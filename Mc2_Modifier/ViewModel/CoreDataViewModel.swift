//
//  CoreDataViewModel.swift
//  CoreDateVMTest
//
//  Created by Hyeonsoo Kim on 2022/06/23.
//

import CoreData
import SwiftUI

class CoreDataViewModel: ObservableObject {
    
    let manager = PersistenceController.shared
    
    @Published var categories: [Category] = []
    @Published var pins: [Pin] = []
    
    //Map에서 현재 선택된 카테고리, 핀 확인용.
    @Published var currentCategory: Category?
    @Published var currentMapPin: Pin?
    
    //열람용
    @Published var selectedCategory: Category?
    @Published var selectedPin: Pin?
    
    //Pin Add/ Update 시 사용할 atrribute
    @Published var editPinMode = false
    @Published var pinTitle: String = ""
    @Published var pinEmotion: String = "love"
    @Published var pinContent: String = ""
    
    
    init() {
        getCategories()
    }
    
    func coreDataReset() { //업데이트 취소 시 호출.
        manager.viewContext.rollback() //reset, rollback,
    }
    
    func getCategories() { //새로 생성, 업데이트, 삭제 시 호출
        let request = Category.fetchRequest() //request 생성
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Category.startDate, ascending: true)]
        
        do {
            self.categories = try manager.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getPins() {
        let request = Pin.fetchRequest()
        let filter = NSPredicate(format: "category == %@", selectedCategory!)
        request.predicate = filter
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Pin.createAt, ascending: true)]
        
        do {
            self.pins = try manager.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    
    func deleteCategory(_ category: Category) { //or index
        withAnimation {
            manager.viewContext.delete(category)
            
            getCategories()
            
            print("\(categories.map({$0.title}))- \(categories.map({$0.startDate}))")
        }
    }
    
    func addPin() {
        var pin: Pin!
        if editPinMode {
            pin = selectedPin
        } else {
            pin = Pin(context: manager.viewContext)
        }
        
        pin.placeName = pinTitle
        pin.emotion = pinEmotion
        pin.category = selectedCategory!
        pin.content = pinContent
        pin.createAt = Date()
        
        manager.saveContext()
        resetPin()
    }
    
    func resetPin() {
        pinTitle = ""
        pinEmotion = "love"
        pinContent = ""
    }
}
