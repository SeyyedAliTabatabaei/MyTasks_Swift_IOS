//
//  UserDefults.swift
//  My Tasks
//
//  Created by Seyyed Ali Tabatabaei on 5/27/23.
//

import Foundation


class MyAppSetting : ObservableObject{
    static let shared = MyAppSetting()
    
    private let userDefult : UserDefaults
    
    private init() {
        self.userDefult = UserDefaults.standard
        getThemeColor()
    }
    
    //MARK: - Intent(s)
    func setSorted(new value : String){
        userDefult.set(value, forKey: "sorted_by")
    }
    
    func getSorted() -> String {
        return userDefult.string(forKey: "sorted_by") ?? SortedBy.DATE_ADDED_NEWEST.rawValue
    }
    
    @Published var themeColor : ThemeColor = ThemeColor.RED
    func setThemeColor(new value : ThemeColor){
        userDefult.set(value.rawValue , forKey: "theme_color")
        getThemeColor()
    }
    
    private func getThemeColor() {
        var themeColor : ThemeColor = ThemeColor.RED
        switch(userDefult.string(forKey: "theme_color")){
        case ThemeColor.RED.rawValue :
            themeColor = ThemeColor.RED
        case ThemeColor.BLUE.rawValue :
            themeColor = ThemeColor.BLUE
        case ThemeColor.BROWN.rawValue :
            themeColor = ThemeColor.BROWN
        case ThemeColor.GREEN.rawValue :
            themeColor =  ThemeColor.GREEN
        case ThemeColor.ORANGE.rawValue :
            themeColor = ThemeColor.ORANGE
        case ThemeColor.PURPLE.rawValue :
            themeColor = ThemeColor.PURPLE
        case ThemeColor.YELLOW.rawValue :
            themeColor = ThemeColor.YELLOW
        default :
            themeColor = ThemeColor.RED
        }
        self.themeColor = themeColor
    }
    
}

enum SortedBy : String{
    case DATE_ADDED_NEWEST = "date_added_newest"
    case DATE_ADDED_OLDEST = "date_added_oldest"
    case TITLE_A_TO_Z = "title_a_to_z"
    case TITLE_Z_TO_A = "title_z_to_a"
    case IMPORTANCE_H_TO_L = "importance_h_to_l"
    case IMPORTANCE_L_TO_H = "importance_l_to_h"
}

enum ThemeColor : String{
    case RED = "red"
    case GREEN = "green"
    case BLUE = "blue"
    case BROWN = "brown"
    case ORANGE = "orange"
    case YELLOW = "yellow"
    case PURPLE = "purple"
}
