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
                    }
                    .frame(width: 100, height: 50)
                    .background(Color.yellow)
                    .clipShape(Capsule())
                    .shadow(color: .gray, radius: 5, x: 0, y: 0)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func setTimeForQuoteNotification() {
        print("Set Time Ran!")
    }
    
}

struct DailyQuoteTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyQuoteTimeView()
    }
}
