//
//  SearchQuoteView.swift
//  DreamBelieveAchieve
//
//  Created by Jake Garcia on 10/14/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI
import CoreData

struct SearchQuoteView: View {
    @State private var searchTerm = ""
    @FetchRequest(entity: Quote.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Quote.text, ascending: false)]) var quotes: FetchedResults<Quote>
    var searchedQuotes: [Quote] {
        return quotes.filter { quote in
            guard let text = quote.text else {
                print("There is no text associated with this quote from: SearchQuoteView")
                return false
            }
            if text.lowercased().contains(searchTerm.lowercased()) {
                return true
            } else {
                return false
            }
        }
    }
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.red, .pink, .yellow]), startPoint: .bottomTrailing, endPoint: .topLeading)
            VStack {
                HStack {
                    TextField("Search quote text", text: $searchTerm)
                        .keyboardType(.default)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .shadow(color: .gray, radius: 5, x: 0, y: 0)
                        .padding(.top, 25)
                }
                .padding(.top, 100)
                ScrollView {
                    if searchTerm != "" {
                        ForEach(self.searchedQuotes, id: \.self.objectID) { quote in
                            VStack {
                                QuoteCard(quote: quote)
                            }
                        }
                    }
                }
                
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("Search Quotes")
    }
}

struct SearchQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        SearchQuoteView()
    }
}
