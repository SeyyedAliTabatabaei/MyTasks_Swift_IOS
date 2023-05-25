//
//  BottomSheetSettingsPermission.swift
//  My Tasks
//
//  Created by Seyyed Ali Tabatabaei on 5/25/23.
//

import SwiftUI

struct BottomSheetSettingsPermission: View {
    
    @Binding var showBottomSheet : Bool
    
    var body: some View {
        VStack{
            Image(systemName: "bell.badge.fill")
                .resizable()
                .frame(width: 80 , height: 100)
                .foregroundColor(.red)
            
            Text("Turn On Notifications")
                .bold()
                .foregroundColor(.red)
                .padding(.top , 50)
                .padding(.bottom , 10)
            
            Text("We need notifications permission to show alarm notifications.")
            Spacer()
            
            Button {
                openNotificationSettings()
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.colorPrimary)
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
                    .foregroundColor(Color.red)
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
        }
    }
}

struct BottomSheetSettingsPermission_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetSettingsPermission(showBottomSheet: .constant(true))
    }
}
