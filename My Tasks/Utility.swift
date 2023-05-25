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
}


extension Color{
    static let colorPrimary = Color(.red)
}

