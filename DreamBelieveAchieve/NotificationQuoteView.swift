//
//  NotificationQuoteView.swift
//  DreamBelieveAchieve
//
//  Created by Jake Garcia on 10/21/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI
import CoreData

struct NotificationQuoteView: View {
    let title: String
    let text: String
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Quote.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Quote.text, ascending: false)], predicate: NSPredicate(format:"text matches text")) var quote: FetchedResults<Quote>
//    var quote: Quote {
//        var notificationQuote: Quote?
//        for item in quotes {
//            if item.text == text {
//                notificationQuote = item
//            }
//        }
//        return notificationQuote ?? quotes.first!
//    }
    
    var body: some View {
        
        ZStack {
        LinearGradient(gradient: Gradient(colors: [.red, .pink, .yellow]), startPoint: .bottomTrailing, endPoint: .topLeading)
            VStack {
                QuoteCard(quote: quote[0]).environment(\.managedObjectContext, moc)
            }
            .onAppear {
                print(self.quote)
            }
        }
    }
}

//struct NotificationQuoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationQuoteView()
//    }
//}
