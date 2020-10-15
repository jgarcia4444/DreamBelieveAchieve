//
//  DailyQuoteTimeView.swift
//  DreamBelieveAchieve
//
//  Created by Jake Garcia on 10/14/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct DailyQuoteTimeView: View {
    @State private var selectedTime = Date()
    @State private var allowAlertShowing = false
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.red, .pink, .yellow]), startPoint: .bottomTrailing, endPoint: .topLeading)
            VStack {
                Text("Pick a time to be sent a quote")
                HStack {
                    DatePicker(selection: $selectedTime, displayedComponents: .hourAndMinute) {
                        Text("Pick a time to be sent a quote")
                    }
                .labelsHidden()
                }
                HStack {
                    Button(action: {
                        self.setTimeForQuoteNotification()
                    }) {
                        Text("Set")
                        .frame(width: 100, height: 50)
                        .background(Color.yellow)
                        .clipShape(Capsule())
                        .shadow(color: .gray, radius: 5, x: 0, y: 0)
                    }
                    
                }
            }
        }
        .alert(isPresented: $allowAlertShowing) {
            Alert(title: Text("Authorization Status"), message: Text("In order to allow notifications to be sent to your device from this app it needs to be allowed. Follow these instructions. Settings -> DreamBelieveAchieve -> Notifications -> Allow Notifications."), dismissButton: .default(Text("Okay")))
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func setTimeForQuoteNotification() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("Authorization status is set to authorized.")
            } else if settings.authorizationStatus == .denied {
                self.allowAlertShowing = true
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}


struct DailyQuoteTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyQuoteTimeView()
    }
}
