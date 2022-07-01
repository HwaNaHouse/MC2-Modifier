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
//    @AppStorage("currentCategory") var currentCategory: Category?
    @Published var currentCategory: Category?
    @Published var selectedPin: Pin?
    
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
        
        manager.saveContext()
    }
    
    func addCategory(_ model: CategoryModel) {
        withAnimation {
            let newCategory = Category(context: manager.viewContext)
            newCategory.uuid = model.id
            newCategory.title = model.title!
            newCategory.categoryColor = model.categoryColor
            newCategory.startDate = model.startDate
            newCategory.endDate = model.endDate
            newCategory.photoName = model.photoName
            getCategories()
            
            print("\(categories.map({$0.title}))- \(categories.map({$0.startDate}))")
        }
    }
    
    func deleteCategory(_ category: Category) { //or index
        withAnimation {
            manager.viewContext.delete(category)
            
            getCategories()
            
            print("\(categories.map({$0.title}))- \(categories.map({$0.startDate}))")
        }
    }
    
    func addPin(_ model: PinModel, category: Category) {
        withAnimation {
            let newPin = Pin(context: manager.viewContext)
            newPin.uuid = model.id
            newPin.placeName = model.placeName
            newPin.emotion = model.emotion!
            newPin.content = model.content
            newPin.createAt = model.createAt!
            newPin.latitude = model.latitude! //나중에 다시 check
            newPin.longitude = model.longitude! //but, 핀 생성 시에 잘 넘긴다면 nil나올 수가 없는 구조.
            
            category.addToPin(newPin)
            getCategories()
        }
    }
}
