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
    @FetchRequest(entity: Quote.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Quote.text, ascending: false)]) var quotes: FetchedResults<Quote>
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
            .foregroundColor(.white)
        }
        .alert(isPresented: $allowAlertShowing) {
            Alert(title: Text("Authorization Status"), message: Text("In order to allow notifications to be sent to your device from this app it needs to be allowed. Follow these instructions. Settings -> DreamBelieveAchieve -> Notifications -> Allow Notifications."), dismissButton: .default(Text("Okay")))
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func randomQuote() -> Quote {
        let randomIndex = Int.random(in: 0..<quotes.count)
        return quotes[randomIndex]
    }
    
    func setTimeForQuoteNotification() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("Authorization status is set to authorized.")
                self.scheduleNotifications()
                print("notifications set!!!")
            } else if settings.authorizationStatus == .denied {
                self.allowAlertShowing = true
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                    print("Requesting authorization")
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    if granted {
                        self.scheduleNotifications()
                    }
                }
            }
        }
    }
    
    func scheduleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for i in 0..<25 {
            let content = UNMutableNotificationContent()
            let quote = randomQuote()
            guard let text = quote.text else {
                print("No Text value found for quote")
                return
            }
            guard let author = quote.author else {
                print("No author value found for quote")
                return
            }
            content.title = author
            content.body = text
            content.sound = .default
            if i == 0 {
                let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
            } else {
                guard let adjustedDate = Calendar.current.date(byAdding: .day, value: i, to: selectedTime) else {
                    print("Could not add one day to the selected time")
                    return
                }
                let dateComponent = Calendar.current.dateComponents([.day, .hour, .minute], from: adjustedDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
            }
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            notifications.forEach { (notification) in
                print(notification)
            }
        }
    }
    
}


struct DailyQuoteTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyQuoteTimeView()
    }
}
