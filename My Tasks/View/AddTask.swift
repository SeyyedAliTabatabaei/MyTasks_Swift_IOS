//
//  AddTask.swift
//  My Tasks
//
//  Created by Seyyed Ali Tabatabaei on 5/9/23.
//

import Foundation
import SwiftUI

struct Importance{
    let id = UUID()
    var color : Color
    var isChecked : Bool = false
    var level : ImportanceLevel = .MEDIUM
}

enum ImportanceLevel : String {
    case HIGH = "High"
    case MEDIUM = "Medium"
    case LITTLE = "Little"
}

struct AddTask: View {
    
    var addTask : (_ title : String , _ description : String , _ importance : String) -> Void
    @Binding var showAddTask : Bool
    
    @State private var title : String = ""
    @State private var descriptionTask : String = ""
    @State private var listImportance : [Importance] = [
        Importance(color: .red , level: .HIGH) ,
        Importance(color: .green ,isChecked: true , level: .MEDIUM) ,
        Importance(color: .blue , level: .LITTLE)
    ]
    @State private var buttonSaveText : String = String.add_task
    
    init(showAddTask : Binding<Bool> , task : Task? , addTask : @escaping (_ title : String , _ description : String , _ importance : String) -> Void ) {
        
        
        self.addTask = addTask
        self._showAddTask = Binding(projectedValue: showAddTask)
        if let task = task {
            self._buttonSaveText = State(initialValue: String.edit_task)
            self._title = State(initialValue: task.title ?? "")
            self._descriptionTask = State(initialValue: task.description_task ?? "" )
            self._listImportance = State(initialValue: [
                Importance(color: .red , isChecked: task.importance == ImportanceLevel.HIGH.rawValue ? true : false , level: .HIGH) ,
                Importance(color: .green , isChecked: task.importance == ImportanceLevel.MEDIUM.rawValue ? true : false , level: .MEDIUM) ,
                Importance(color: .blue , isChecked: task.importance == ImportanceLevel.LITTLE.rawValue ? true : false , level: .LITTLE)
            ])
        }
        else {
            self._listImportance = State(initialValue: [
                Importance(color: .red , level: .HIGH) ,
                Importance(color: .green ,isChecked: true , level: .MEDIUM) ,
                Importance(color: .blue , level: .LITTLE)
            ])
        }
    }
    
    
    var body: some View {
        VStack{
            Form{
                importanceSec
                titleSec
                descriptionSec
            }
            buttonSave
            Spacer()
        }
    }
    
    var importanceSec : some View {
        Section(String.importance) {
            HStack{
                ForEach(listImportance , id: \.id) { i in
                    HStack{
                        Circle()
                            .frame(width: 30 , height: 30)
                            .foregroundColor(i.color)
                            .overlay {
                                if i.isChecked{
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.white)
                                        .bold()
                                }
                            }
                        Text(i.level.rawValue)
                    }.onTapGesture {
                        for index in listImportance.indices{
                            if listImportance[index].id == i.id{
                                listImportance[index].isChecked = true
                            }else{
                                listImportance[index].isChecked = false
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    var titleSec : some View{
        Section(header : Text(String.title)) {
            TextField(String.title , text: $title , axis: .vertical)
                .lineLimit(1)
        }
    }
    
    var descriptionSec : some View{
        Section(header : Text(String.description)) {
            TextEditor(text: $descriptionTask )
                .overlay(
                    Text(String.description)
                        .foregroundColor(.gray)
                        .opacity(descriptionTask.isEmpty ? 0.5 : 0)
                        .padding(.top, 8)
                        .padding(.horizontal, 4),
                    alignment: .topLeading
                )
        }
    }
    
    
    var buttonSave : some View {
        @State var showAlertTitle : Bool = false
        return Button {
            addTask(title , descriptionTask , getImportance())
            showAddTask  = false
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.colorPrimary)
                .frame(maxHeight: 50)
                .overlay {
                    Text(buttonSaveText)
                        .foregroundColor(Color.white)
                }
                .opacity(title.count > 0 ? 1 : 0.6)
        }
        .padding(.horizontal)
        .disabled(title.count > 0 ? false : true)
    }
    
    private func getImportance() -> String {
        for i in listImportance {
            if i.isChecked {
                return i.level.rawValue
            }
        }
        return "Medium"
    }
}

struct AddTask_Previews: PreviewProvider {

    static var previews: some View {
        AddTask(showAddTask: .constant(true) , task:  nil) { title, description, importance in
            
        }

    }
}