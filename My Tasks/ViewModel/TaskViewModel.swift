//
//  TaskViewModel.swift
//  My Tasks
//
//  Created by Seyyed Ali Tabatabaei on 5/9/23.
//

import Foundation
import CoreData
import UserNotifications

class TaskViewModel : ObservableObject{
    private let viewContext = PersistenceController.shared.viewContext
    @Published var listTasks : [Task] = []
    var appSettings = MyAppSetting.shared

    init() {
        getAllTasks()
    }
    
    func getAllTasks() {
        let request = NSFetchRequest<Task>(entityName: "Task")

        do{
            listTasks = try viewContext.fetch(request).reversed()
            
            switch(appSettings.getSorted()){
            case SortedBy.DATE_ADDED_NEWEST.rawValue :
                sortDateAddedNewest()
            case SortedBy.DATE_ADDED_OLDEST.rawValue :
                sortDateAddedOldest()
            case SortedBy.TITLE_A_TO_Z.rawValue :
                sortTitleAToZ()
            case SortedBy.TITLE_Z_TO_A.rawValue :
                sortTitleZToA()
            case SortedBy.IMPORTANCE_H_TO_L.rawValue :
                sortImportanceHighToLittle()
            case SortedBy.IMPORTANCE_L_TO_H.rawValue :
                sortImportanceLittleToHigh()
            default:
                sortDateAddedNewest()
            }
        }catch{
            print("DEBUG: Some error occured while fetching")
        }
    }
    
    func addTask(title : String , description : String , importance : String , reminder : Date?){
        let task = Task(context: viewContext)
        task.id = (getLastID() + 1)
        task.title = title
        task.done = false
        task.importance = importance
        task.description_task = description
        task.reminder = reminder

        if reminder != nil{
            setNotification(task: task)
        }else{
            cancelNotification(task: task)
        }

        save()
    }
    
    func deleteTask(at task : Task){
        cancelNotification(task: task)
        viewContext.delete(task)
        save()
    }
    
    func updateTask(at task : Task? , title : String , description : String , importance : String , reminder : Date?){
        if let task = task{
            task.title = title
            task.description_task = description
            task.importance = importance
            task.reminder = reminder
            if reminder != nil{
                setNotification(task: task)
            }else{
                cancelNotification(task: task)
            }
            
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
    
    private func setNotification(task : Task){
        if let reminder = task.reminder{
            let content = UNMutableNotificationContent()
            content.title = "Your Task Reminder"
            content.subtitle = task.title ?? ""
            if let des = task.description_task{
                content.body = des
            }
            content.sound = UNNotificationSound.default
                
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminder)
                
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
                
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    private func cancelNotification(task : Task){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(task.id)])
    }
    
    
    private func getLastID() -> Int64{
        return listTasks.max { t0, t1 in
            t0.id < t1.id
        }?.id ?? 0
    }
    
    
    func sortDateAddedNewest(){
        listTasks.sort { $0.id > $1.id}
    }
    
    func sortDateAddedOldest(){
        listTasks.sort { $0.id < $1.id}
    }
    
    func sortTitleAToZ(){
        listTasks.sort { $0.title ?? "" < $1.title ?? ""}
    }
    
    func sortTitleZToA(){
        listTasks.sort { $0.title ?? "" > $1.title ?? ""}
    }
    
    func sortImportanceHighToLittle(){
        listTasks.sort { getNumberImportance(importance: $0.importance ?? "") > getNumberImportance(importance: $1.importance ?? "")}
    }
    
    func sortImportanceLittleToHigh(){
        listTasks.sort { getNumberImportance(importance: $0.importance ?? "") < getNumberImportance(importance: $1.importance ?? "")}
    }
    
    private func getNumberImportance(importance : String) -> Int{
        switch(importance){
        case ImportanceLevel.HIGH.rawValue:
            return 2
        case ImportanceLevel.MEDIUM.rawValue:
            return 1
        case ImportanceLevel.LITTLE.rawValue:
            return 0
        default:
            return 1
        }
    }
}
