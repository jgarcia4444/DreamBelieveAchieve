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
                            print(swiftifiedJson.count)
                        }
                    }
            }
        }
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
