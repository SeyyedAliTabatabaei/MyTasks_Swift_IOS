//
//  TaskViewModel.swift
//  My Tasks
//
//  Created by Seyyed Ali Tabatabaei on 5/9/23.
//

import Foundation
import CoreData

class TaskViewModel : ObservableObject{
    private let viewContext = PersistenceController.shared.viewContext
    @Published var listTasks : [Task] = []
    
    init() {
        getAllTasks()
    }
    
    func getAllTasks() {
        let request = NSFetchRequest<Task>(entityName: "Task")

        do{
            listTasks = try viewContext.fetch(request).reversed()
        }catch{
            print("DEBUG: Some error occured while fetching")
        }
    }
    
    func addTask(title : String , description : String , importance : String){
        let task = Task(context: viewContext)
        task.id = (getLastID() + 1)
        task.title = title
        task.done = false
        task.importance = importance
        task.description_task = description
        
        save()
    }
    
    func deleteTask(at task : Task){
        viewContext.delete(task)
        save()
    }
    
    func updateTask(at task : Task? , title : String , description : String , importance : String){
        if let task = task{
            task.title = title
            task.description_task = description
            task.importance = importance
            
            save()
        }
    }
    
    func isDoneTask(at task : Task){
        task.done.toggle()
        save()
    }
    
    private func save(){
        do {
            try viewContext.save()
            self.getAllTasks()
        } catch {
            print("Error saving")
        }
    }
    
    
    private func getLastID() -> Int64{
        return listTasks.last?.id ?? 0
    }
}
