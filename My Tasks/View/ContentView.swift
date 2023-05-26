//
//  ContentView.swift
//  My Tasks
//
//  Created by Seyyed Ali Tabatabaei on 5/9/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = TaskViewModel()
    @State private var showAddTask : Bool = false
    @State private var task : Task?
    @State private var searchTask : String = ""
    @Environment(\.colorScheme) var colorSchema

    var body: some View {
        NavigationView {
            VStack{
                if vm.listTasks.isEmpty{
                    Spacer()
                    emptyList
                    Spacer()
                } else {
                    List{
                        ForEach(searchResult , id: \.id) { t in
                            CardView(task: t, isDoneTask: {
                                vm.isDoneTask(at: t)
                            } , deleteTask: {
                                withAnimation { vm.deleteTask(at: t) }
                            } , updateTask: { title, description, importance , reminder in
                                vm.updateTask(at: t, title: title, description: description, importance: importance , reminder : reminder)
                            }, isDone: t.done)
                        }
                    }
                    .searchable(text: $searchTask , prompt: String.search)
                }
                
                buttonNewTask
            }
            .navigationTitle(String.app_name)
        }
    }
    
    
    var searchResult: [Task] {
        guard !searchTask.isEmpty else { return vm.listTasks }
        return vm.listTasks.filter { $0.title?.contains(searchTask) ?? false }
        }
    
    
    var emptyList : some View {
        VStack{
            Image("ic_empty")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(colorSchema == .dark ? .white : .black)
                .frame(width: 50 , height: 50)
                .padding()

            
            Text(String.list_empty)
            Text(String.add_new_task)
                .bold()
                .foregroundColor(.blue)
                .padding([.top] , 0)
                .onTapGesture {
                    showAddTask.toggle()
                }
        }
    }
    
    
    var buttonNewTask : some View {
        Button {
            showAddTask.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.colorPrimary)
                .frame(maxHeight: 50)
                .overlay {
                    Text(String.new_task)
                        .foregroundColor(Color.white)
                        .bold()
                }
        }
        .padding(.horizontal)
        .popover(isPresented: $showAddTask) {
            AddTask(showAddTask: $showAddTask , task: nil) { title, description, importance , reminder in
                vm.addTask(title: title, description: description , importance: importance , reminder: reminder)
            }
            .wrappedNavigationViewToMakeDismissable { showAddTask = false }
        }
    }
}

struct CardView : View{
    
    var task : Task
    var isDoneTask : () -> Void
    var deleteTask : () -> Void
    var updateTask : (_ title : String , _ description : String , _ importance : String , _ reminder : Date?) -> Void
    @State var isDone : Bool
    @State private var showUpdateTask : Bool = false
    @Environment(\.colorScheme) var colorSchema
    
    var body: some View{
        HStack {
            VStack(alignment: .leading){
                Text(task.title ?? "")
                    .bold()
                    .font(Font.title2)
                
                Text(task.description_task ?? "")
            }
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 30 , height: 30)
                .foregroundColor(getColorImportance(task.importance ?? String.medium))
                .overlay {
                    if isDone { Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .bold()
                    }
                    
                }.onTapGesture {
                    isDone.toggle()
                    isDoneTask()
                }
        }
        .swipeActions(edge : .trailing) {
            Button() {
                showUpdateTask.toggle()
            } label: { Image(systemName: "square.and.pencil").bold() }
            .tint(.green)
            
            
            Button() {
                deleteTask()
            } label: { Image(systemName: "trash").bold() }
            .tint(.red)
        }
        .swipeActions(edge : .leading) {
            Button() {
                isDone.toggle()
                isDoneTask()
            } label: { Image(systemName: "checkmark.square").bold() }
                .tint(.purple)
        }
        .popover(isPresented: $showUpdateTask) {
            AddTask(showAddTask: $showUpdateTask, task: task , addTask: updateTask)
                .wrappedNavigationViewToMakeDismissable { showUpdateTask = false }

        }
    }
    
    
    
    
    private func getColorImportance(_ imp : String) -> Color {
        switch imp{
        case ImportanceLevel.HIGH.rawValue :
            return Color.red
        case ImportanceLevel.MEDIUM.rawValue:
            return Color.green
        case ImportanceLevel.LITTLE.rawValue :
            return Color.blue
        default:
            return Color.green
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
