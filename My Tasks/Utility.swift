//
//  Utility.swift
//  My Tasks
//
//  Created by Seyyed Ali Tabatabaei on 5/9/23.
//

import Foundation
import SwiftUI

extension View{
    @ViewBuilder
    func wrappedNavigationViewToMakeDismissable(_ dismiss : (() -> Void)?) -> some View{
        if let dismiss = dismiss{
            NavigationView {
                 self
                    .navigationBarTitleDisplayMode(.inline)
                    .dismissable(dismiss)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            self
        }
    }
    
    @ViewBuilder
    func dismissable(_ dismiss : (() -> Void)?) -> some View {
        if let dismiss = dismiss{
            self.toolbar {
                ToolbarItem(placement : .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }else{
            self
        }

    }
    
}


extension String{
    static let app_name = String(localized: "app_name")
    static let add_task = String(localized: "add_task")
    static let edit_task = String(localized: "edit_task")
    static let new_task = String(localized: "new_task")
    static let high = String(localized: "high")
    static let medium = String(localized: "medium")
    static let little = String(localized: "little")
    static let importance = String(localized: "importance")
    static let title = String(localized: "title")
    static let description = String(localized: "description")
    static let search = String(localized: "search")
    static let list_empty = String(localized: "list_empty")
    static let add_new_task = String(localized: "add_new_task")
    static let alarm = String(localized: "alarm")
    static let select_date = String(localized: "select_date")
    static let select_time = String(localized: "select_time")
    static let go_settings = String(localized: "go_settings")
    static let cancel = String(localized: "cancel")
    static let turn_on_notification = String(localized: "turn_on_notification")
    static let turn_on_notification_des = String(localized: "turn_on_notification_des")
    static let sort_by = String(localized: "sort_by")
    static let date_added = String(localized: "date_added")
    static let newest_first = String(localized: "newest_first")
    static let oldest_first = String(localized: "oldest_first")
    static let a_to_z = String(localized: "a_to_z")
    static let z_to_a = String(localized: "z_to_a")
    static let theme_color = String(localized: "theme_color")
}


func colorPrimary(theme color : ThemeColor) -> Color {
    switch(color){
    case ThemeColor.RED :
        return .red
    case ThemeColor.BLUE :
        return .blue
    case ThemeColor.BROWN :
        return .brown
    case ThemeColor.GREEN :
        return .green
    case ThemeColor.ORANGE :
        return .orange
    case ThemeColor.PURPLE :
        return .purple
    case ThemeColor.YELLOW :
        return .yellow
    }
}

struct ButtonMenu : View{
    
    var title : String
    var isChecked : Bool
    var action : () -> Void

    var body: some View{
    
        Button {
            action()
        } label: {
            HStack{
                if (isChecked){
                    Image(systemName: "checkmark")
                }
                Text(title)
            }
        }
    }
}

