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
    var title: String = ""
    var text: String = ""
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
//    @FetchRequest(entity: Quote.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Quote.text, ascending: false)], predicate: NSPredicate(format: "text CONTAINS %@", text)) var quotes: FetchedResults<Quote>
    var quote: Quote?
    @State private var quotes = [Quote]()
    var body: some View {
        
        ZStack {
        LinearGradient(gradient: Gradient(colors: [.red, .pink, .yellow]), startPoint: .bottomTrailing, endPoint: .topLeading)
            VStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Home")
                    }
                }
                if quotes.count > 0 {
                    QuoteCard(quote: quotes[0])
                } else {
                    Text("Loading...")
                }
            }
            .onAppear {
                self.findQuoteInDb()
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
    func findQuoteInDb() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Quote")
        request.predicate = NSPredicate(format: "text like %@", text)
        let results = try? moc.fetch(request)
        if let resultQuotes = results as? [Quote] {
            resultQuotes.forEach { quote in
                self.quotes.append(quote)
            }
        }
    }
    
}

//struct NotificationQuoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationQuoteView()
//    }
//}
