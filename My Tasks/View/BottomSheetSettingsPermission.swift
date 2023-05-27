//
//  BottomSheetSettingsPermission.swift
//  My Tasks
//
//  Created by Seyyed Ali Tabatabaei on 5/25/23.
//

import SwiftUI

struct BottomSheetSettingsPermission: View {
    
    @Binding var showBottomSheet : Bool
    var appSettings = MyAppSetting.shared

    var body: some View {
        VStack{
            Image(systemName: "bell.badge.fill")
                .resizable()
                .frame(width: 80 , height: 100)
                .foregroundColor(colorPrimary(theme: appSettings.themeColor))
            
            Text(String.turn_on_notification)
                .bold()
                .foregroundColor(colorPrimary(theme: appSettings.themeColor))
                .padding(.top , 50)
                .padding(.bottom , 10)
            
            Text(String.turn_on_notification_des)
            Spacer()
            
            Button {
                openNotificationSettings()
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorPrimary(theme: appSettings.themeColor))
                    .frame(maxHeight: 50)
                    .overlay {
                        Text(String.go_settings)
                            .foregroundColor(Color.white)
                    }
            }
            .padding(.horizontal)
            
            
            Button {
                showBottomSheet = false
            } label: {
                Text(String.cancel)
                    .foregroundColor(colorPrimary(theme: appSettings.themeColor))
            }
            .padding()
            
        }
        .padding()
        .padding(.top , 100)
    }
    
    
    private func openNotificationSettings(){
        guard let settingsURL = URL(string : UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsURL){
            UIApplication.shared.open(settingsURL , options: [:] , completionHandler: nil)
            showBottomSheet = false
        }
    }
}

struct BottomSheetSettingsPermission_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetSettingsPermission(showBottomSheet: .constant(true))
    }
}
