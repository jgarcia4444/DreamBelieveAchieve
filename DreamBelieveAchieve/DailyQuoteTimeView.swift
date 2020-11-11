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
    @State private var timeSetAlert = false
    @State private var notificationTime = ""
    @State private var showRemovalAction = false
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Quote.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Quote.text, ascending: false)]) var quotes: FetchedResults<Quote>
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .red, .pink, .orange, .yellow]), startPoint: .bottomTrailing, endPoint: .topLeading)
            VStack {
                if notificationTime != "" {
                    VStack {
                        HStack {
                            Button(action: {
                                self.showRemovalAction = true
                            }) {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            
                        }
                        Text("Notification Time")
                            .font(.title)
                        Text(notificationTime)
                            .fontWeight(.bold)
                        Text("To update the time pick another time on the picker.")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(20)
                    .padding(.bottom, 100)
                    .foregroundColor(.black)
                .shadow(radius: 10)
                }
                
                HStack {
                    Text("Pick a time to be sent a quote")
                        .font(.title)
                }
                HStack {
                    DatePicker(selection: $selectedTime, displayedComponents: .hourAndMinute) {
                        Text("")
                    }
                .labelsHidden()
                }
                .padding()
                .background(Color.yellow)
                .cornerRadius(20)
                .shadow(radius: 20)
                HStack {
                    Button(action: {
                        self.setTimeForQuoteNotification()
                    }) {
                        Text("Set")
                        .frame(width: 100, height: 50)
                        .background(Color.yellow)
                        .clipShape(Capsule())
                        .shadow(color: .gray, radius: 5, x: 0, y: 0)
                            .foregroundColor(.black)
                    }
                }
            }
            .foregroundColor(.white)
        }
        .actionSheet(isPresented: $showRemovalAction) {
            ActionSheet(title: Text("Remove Set Time"), message: Text("Tapping remove will unschedule daily notifications"), buttons: [.default(Text("Cancel")), .destructive(Text("Remove").foregroundColor(.red), action: {
                self.removeNotifications()
            })])
        }
        .alert(isPresented: $allowAlertShowing) {
            Alert(title: Text("Authorization Status"), message: Text("In order to allow notifications to be sent to your device from this app it needs to be allowed. Follow these instructions. Settings -> DreamBelieveAchieve -> Notifications -> Allow Notifications."), dismissButton: .default(Text("Okay")))
        }
        .alert(isPresented: $timeSetAlert) {
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: self.selectedTime)
            var alert = Alert(title: Text("Time Set"))
            if let hour = dateComponents.hour {
                var adjustedHour: Int
                var amPmString = "a.m"
                if hour > 12 {
                    adjustedHour = hour - 12
                    amPmString = "p.m"
                } else {
                    adjustedHour = hour
                }
                
                if let minute = dateComponents.minute {
                    var adjustedMinute = ""
                    if minute < 10 {
                        adjustedMinute = "0\(minute)"
                    } else {
                        adjustedMinute = "\(minute)"
                    }
                    alert = Alert(title: Text("Time Set"),message:Text("You will recieve a quote notification at \(adjustedHour):\(adjustedMinute) \(amPmString)"), dismissButton: .default(Text("Okay"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }))
                }
            }
            return alert
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.loadNotificationTime()
        }
    }
    
    func removeNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        self.notificationTime = ""
    }
    
    func loadNotificationTime() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (notifications) in
            guard let notification = notifications.first else {
                print("No notifications set")
                return
            }
            let notificationTrigger = notification.trigger as? UNCalendarNotificationTrigger
            guard let hour = notificationTrigger?.dateComponents.hour else {
                print("No hour for calendar trigger.")
                return
            }
            guard let minute = notificationTrigger?.dateComponents.minute else {
                print("No minute for calendar trigger.")
                return
            }
            var amPm = ""
            var adjustedHour = ""
            if hour > 12 {
                adjustedHour = String(hour - 12)
                amPm = "p.m."
            } else {
                amPm = "a.m."
                adjustedHour = String(hour)
            }
            var adjustedMinute = ""
            if minute < 10 {
                adjustedMinute += "0\(minute)"
            } else {
                adjustedMinute = String(minute)
            }
            
            self.notificationTime = "\(adjustedHour):\(adjustedMinute) \(amPm)"
            
        }
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
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
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
        self.timeSetAlert = true
    }
    
}


struct DailyQuoteTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyQuoteTimeView()
    }
}
