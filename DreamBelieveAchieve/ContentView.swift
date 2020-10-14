//
//  ContentView.swift
//  DreamBelieveAchieve
//
//  Created by Jake Garcia on 10/13/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI
import CoreData
import Alamofire
import SwiftyJSON

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Quote.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Quote.text, ascending: false)]) var quotes: FetchedResults<Quote>
    
    var body: some View {
        Text("Hello, World!")
        .onAppear {
            self.loadQuotes()
        }
    }
    
    func loadQuotes() {
        if self.quotes.count < 1 {
            AF.request("https://type.fit/api/quotes")
                .response { res in
                    if let error = res.error {
                        fatalError("\(error.localizedDescription)")
                    }
                    if let data = res.data {
                        let json = try? JSON(data: data)
                        if let swiftifiedJson = json {
                            self.loopThroughQuotes(quotesJson: swiftifiedJson)
                        }
                    }
            }
        }
        else {
            print(self.quotes.count)
            guard let firstQuote = self.quotes.first else {
                print("No quote saved")
                return
            }
            print(firstQuote.text)
        }
    }
    
    func loopThroughQuotes(quotesJson: JSON) {
        quotesJson.forEach { (id, json) in
            let quoteToBeSaved = Quote(context: moc)
            let text = json["text"]
            let author = json["author"] ?? "Unknown"
            quoteToBeSaved.author = author.stringValue
            quoteToBeSaved.text = text.stringValue
            do {
                try moc.save()
            } catch {
                print(error.localizedDescription)
                return
            }
        }
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
