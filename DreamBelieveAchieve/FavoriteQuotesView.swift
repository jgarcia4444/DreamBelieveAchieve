//
//  FavoriteQuotesView.swift
//  DreamBelieveAchieve
//
//  Created by Jake Garcia on 10/14/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI
import CoreData


struct FavoriteQuotesView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Quote.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Quote.text, ascending: false)], predicate: NSPredicate(format: "isFavorited == true")) var favoritedQuotes: FetchedResults<Quote>
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .red, .pink, .orange, .yellow]), startPoint: .bottomTrailing, endPoint: .topLeading)
            VStack {
                ScrollView {
                    ForEach(self.favoritedQuotes, id: \.self.objectID) { quote in
                        VStack {
                            QuoteCard(quote: quote)
                        }
                    }
                }
                .navigationBarTitle("Favorite Quotes", displayMode: .automatic)
                .padding(.top, 125)
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    
    }
}

//struct FavoriteQuotesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteQuotesView()
//    }
//}
