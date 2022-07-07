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
    
    //Map용.
    @AppStorage("selection") var currentCategoryIndex: Int = 0 //앱 껐다 켰을 때 상태를 저장하기위한 index. mapView의 onAppear에서 사용호출.
    @Published var currentMapPin: Pin?
    @Published var currentCategory: Category? { //1)새로 생성 시, 2)카테고리 변경 시 -> 값이 변경됨.
        didSet { //앱 최초 및 초기 실행 & 카테고리 모두 삭제 시에만 nil.
            //category가 모두 삭제됐을 때는 조건문 통과안되도록.
            if let currentCategory = currentCategory {
                self.currentCategoryIndex = categories.firstIndex(where: { currentCategory.uuid == $0.uuid }) ?? 0
                getMapPins()
            }
        }
    } //MARK: 1. pin과 관련된 핸들링이 진행되는 시점들에 getMapPins 호출하는 방법.
    
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
    @Published var pinLatitude: Double = 30.0 //MARK: Need to check
    @Published var pinLongitude: Double = 120.0
    
    
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
    
    func getMapPins() {
        let request = Pin.fetchRequest()
        let filter = NSPredicate(format: "category == %@", currentCategory!)
        request.predicate = filter
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Pin.createAt, ascending: true)]
        
        do {
            self.pins = try manager.viewContext.fetch(request)
//            print("pins fetch")
//            print(pins)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getPins() {
        let request = Pin.fetchRequest()
        let filter = NSPredicate(format: "category == %@", selectedCategory!)
        request.predicate = filter
        
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
        category.uuid = UUID() //MARK: Need to check
        category.title = categoryTitle
        category.startDate = categoryStartDate
        category.photoName = categoryPhoto
        category.categoryColor = categoryColor
        
        manager.saveContext()
        getCategories()
        if !editCategoryMode {
            self.selectedCategory = category
            //Map용
            self.currentCategory = category
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
            manager.saveContext()
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
//        pin.category = selectedCategory! //MARK: Need to check
        pin.category = currentCategory! //nil이 뜰 확률 no.
        pin.content = pinContent
        pin.createAt = Date()
        pin.latitude = pinLatitude
        pin.longitude = pinLongitude
        
        manager.saveContext()
        resetPin()
    }
    
    func resetPin() {
        pinTitle = ""
        pinEmotion = "love"
        pinContent = ""
        pinLatitude = 30
        pinLongitude = 120
    }
}
