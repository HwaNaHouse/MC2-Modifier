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
    
    //Map의 상태를 handling하는 프로퍼티
    @Published var currentCategory: Category?
    @Published var currentMapPin: Pin?
    
    //다양한 Add, Update, 열람용으로 사용되는 프로퍼티
    @Published var selectedCategory: Category?
    @Published var selectedPin: Pin?
    @Published var selectCategoryIndex: Int = 0
    
    //Category Add/ Update 시 사용할 attribute
    @Published var editCategoryMode = false
    @Published var categoryTitle: String = ""
    @Published var categoryStartDate: Date = Date()
    @Published var categoryPhoto: String = "sample1"
    @Published var categoryColor = "red"
    @Published var editCategory: Category?
    
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
    
    //Category Add / Update 시 사용할 로직
    //기존 카테고리 Update 시 버튼으로 editCategoryMode True로 변경 해준다.
    //후에 입력되는 값을을 카테고리 Add용 Attribute에 값을 Binding 후 완료 버튼에 cVm.AddCategory() 를 해준다.
    // cVm.AddCategory 호출 후 editCategoryMode false로 변경 해준다
    func addCategory() {
        var category: Category!
        if editCategoryMode {
            category = editCategory
        } else {
            category = Category(context: manager.viewContext)
        }
        category.title = categoryTitle
        category.startDate = categoryStartDate
        category.photoName = categoryPhoto
        category.categoryColor = categoryColor
        
        manager.saveContext()
        getCategories()
        if !editCategoryMode {
            self.selectedCategory = category
        }
        resetCategory()
    }
    
    //Add 완료 후 어트리뷰트에 값이 남아 있기때문에 초기화를 진행 해준다.
    func resetCategory() {
        categoryTitle = ""
        categoryStartDate = Date()
        categoryPhoto = "sample1"
        categoryColor = "red"
    }
    //Update시 editCategory값을(selectedCategory) 을 attribute에 할당해 준다
    func setCategory() {
        if let category = editCategory {
            categoryTitle = category.title
            categoryStartDate = category.startDate ?? Date()
            categoryColor = category.categoryColor ?? "red"
            categoryPhoto = category.photoName ?? "sample1"
        }
    }
    
    //선택한 Category에 내용을 selectedCategory에 할당해 준다
    func selectCategory(_ category: Category) {
        self.selectedCategory = category
        self.editCategory = category
    }
    
    func deleteCategory() { //or index
        withAnimation {
            manager.viewContext.delete(editCategory!)
            manager.saveContext()
            getCategories()
            
            //            print("\(categories.map({$0.title}))- \(categories.map({$0.startDate}))")
        }
    }
    
    func deletePin(_ pin: Pin) {
        withAnimation {
            manager.viewContext.delete(pin)
        }
    }
    
    func setPin() {
        if let pin = selectedPin {
            pinTitle = pin.placeName ?? ""
            pinEmotion = pin.emotion
            pinContent = pin.content ?? ""
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
