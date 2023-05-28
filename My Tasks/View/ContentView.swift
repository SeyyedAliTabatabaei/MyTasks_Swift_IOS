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
    @ObservedObject var appSettings = MyAppSetting.shared
    
    @State private var selectItems = Set<Task>()
    @State private var enableSelection : Bool = false

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
                            } ,selectTask: {
                                if selectItems.contains(t){
                                    selectItems.remove(t)
                                } else {
                                    selectItems.insert(t)
                                }
                            
                            } , isDone: t.done , enableSelection : enableSelection , isItemSelect : selectItems.contains(t))
                        }
                    }
                    
                    .searchable(text: $searchTask , prompt: String.search)
                }
                
                if enableSelection{ selectionMenu }
                else{ buttonNewTask }
            }
            .navigationTitle(String.app_name)
            .toolbar {
                if !enableSelection{  menu }
                else {
                    Button(String.cancel) {
                        withAnimation { enableSelection.toggle() }
                        selectItems.removeAll()
                    }.foregroundColor(colorPrimary(theme: appSettings.themeColor))
                }
            }
        }
    }
    
    var menu : some View {
        Menu {

            Button {
                withAnimation { enableSelection.toggle() }
            } label: {
                Label(String.select_task , systemImage: "checklist")
            }.disabled(vm.listTasks.isEmpty ? true : false)
            
            Menu { menuSort } label: {
                Label(String.sort_by, systemImage: "arrow.up.arrow.down")
            }
            
            Menu { menuColorTheme } label: {
                Label(String.theme_color, systemImage: "paintbrush")
            }

        } label: {
            Label("Options", systemImage: "ellipsis.circle")
                .foregroundColor(colorPrimary(theme: appSettings.themeColor))

        }
    }
    var menuSort : some View {
        VStack{
            Menu(String.date_added) {
                
                ButtonMenu(title: String.newest_first , isChecked : appSettings.getSorted() == SortedBy.DATE_ADDED_NEWEST.rawValue) {
                    vm.sortDateAddedNewest()
                    appSettings.setSorted(new: SortedBy.DATE_ADDED_NEWEST.rawValue)
                }
                
                ButtonMenu(title: String.oldest_first , isChecked : appSettings.getSorted() == SortedBy.DATE_ADDED_OLDEST.rawValue) {
                    vm.sortDateAddedOldest()
                    appSettings.setSorted(new: SortedBy.DATE_ADDED_OLDEST.rawValue)
                }
            }
            
            Menu(String.title) {
                ButtonMenu(title: String.a_to_z , isChecked : appSettings.getSorted() == SortedBy.TITLE_A_TO_Z.rawValue) {
                    vm.sortTitleAToZ()
                    appSettings.setSorted(new: SortedBy.TITLE_A_TO_Z.rawValue)
                }
                
                ButtonMenu(title: String.z_to_a , isChecked : appSettings.getSorted() == SortedBy.TITLE_Z_TO_A.rawValue) {
                    vm.sortTitleZToA()
                    appSettings.setSorted(new: SortedBy.TITLE_Z_TO_A.rawValue)
                }
            }
            
            Menu(String.importance) {
                ButtonMenu(title: String.high_to_little , isChecked : appSettings.getSorted() == SortedBy.IMPORTANCE_H_TO_L.rawValue) {
                    vm.sortImportanceHighToLittle()
                    appSettings.setSorted(new: SortedBy.IMPORTANCE_H_TO_L.rawValue)
                }
                
                ButtonMenu(title: String.little_to_high , isChecked : appSettings.getSorted() == SortedBy.IMPORTANCE_L_TO_H.rawValue) {
                    vm.sortImportanceLittleToHigh()
                    appSettings.setSorted(new: SortedBy.IMPORTANCE_L_TO_H.rawValue)
                }
            }
        }
    }
    
    var menuColorTheme : some View {
        VStack{
            ButtonMenu(title: ThemeColor.RED.rawValue, isChecked: appSettings.themeColor == ThemeColor.RED) {
                appSettings.setThemeColor(new: ThemeColor.RED)
            }
            
            ButtonMenu(title: ThemeColor.BLUE.rawValue, isChecked: appSettings.themeColor == ThemeColor.BLUE) {
                appSettings.setThemeColor(new: ThemeColor.BLUE)
            }
            
            ButtonMenu(title: ThemeColor.BROWN.rawValue, isChecked: appSettings.themeColor == ThemeColor.BROWN) {
                appSettings.setThemeColor(new: ThemeColor.BROWN)
            }
            
            ButtonMenu(title: ThemeColor.GREEN.rawValue, isChecked: appSettings.themeColor == ThemeColor.GREEN) {
                appSettings.setThemeColor(new: ThemeColor.GREEN)
            }
            
            ButtonMenu(title: ThemeColor.ORANGE.rawValue, isChecked: appSettings.themeColor == ThemeColor.ORANGE) {
                appSettings.setThemeColor(new: ThemeColor.ORANGE)
            }
            
            ButtonMenu(title: ThemeColor.PURPLE.rawValue, isChecked: appSettings.themeColor == ThemeColor.PURPLE) {
                appSettings.setThemeColor(new: ThemeColor.PURPLE)
            }
            
            ButtonMenu(title: ThemeColor.YELLOW.rawValue, isChecked: appSettings.themeColor == ThemeColor.YELLOW) {
                appSettings.setThemeColor(new: ThemeColor.YELLOW)
            }
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
                .fill(colorPrimary(theme: appSettings.themeColor))
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
    
    var selectionMenu : some View {
        HStack{
            Spacer()
            Text("\(selectItems.count) Task selected")
            Spacer()
            Button {
                withAnimation {
                    enableSelection.toggle()
                    selectItems.forEach { t in
                        vm.deleteTask(at: t)
                    }
                }
                selectItems.removeAll()
                
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 25)
            }
        }
        .foregroundColor(colorPrimary(theme: appSettings.themeColor))
        .padding()
    }
}

struct CardView : View{
    
    var task : Task
    var isDoneTask : () -> Void
    var deleteTask : () -> Void
    var updateTask : (_ title : String , _ description : String , _ importance : String , _ reminder : Date?) -> Void
    var selectTask : () -> Void
    @State var isDone : Bool
    @State private var showUpdateTask : Bool = false
    @Environment(\.colorScheme) var colorSchema
    var enableSelection : Bool
    var isItemSelect : Bool
    var appSetting = MyAppSetting.shared
    
    var body: some View{
        
        Button {
            if enableSelection {
                withAnimation { selectTask() }
            }
        } label: {
            HStack {
                
                if enableSelection{
                    Image(systemName: isItemSelect ? "checkmark.circle.fill" : "circle" )
                        .resizable()
                        .aspectRatio(1/1 , contentMode: .fit)
                        .frame(height: 25)
                        .foregroundColor(colorPrimary(theme: appSetting.themeColor))
                }
                
                VStack(alignment: .leading){
                    Text(task.title ?? "")
                        .bold()
                        .font(Font.title2)
                        .strikethrough(isDone)
                    Text(task.description_task ?? "")
                }
                
                Spacer()
                if !enableSelection{
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
                
            }
            
        }
        .swipeActions(edge : .trailing) {
            if !enableSelection{
                Button() {
                    showUpdateTask.toggle()
                } label: { Image(systemName: "square.and.pencil").bold() }
                    .tint(.green)
                
                Button() {
                    deleteTask()
                } label: { Image(systemName: "trash").bold() }
                    .tint(.red)
            }
        }
        .swipeActions(edge : .leading) {
            if !enableSelection {
                Button() {
                    isDone.toggle()
                    isDoneTask()
                } label: { Image(systemName: "checkmark.square").bold() }
                    .tint(.purple)
            }
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
