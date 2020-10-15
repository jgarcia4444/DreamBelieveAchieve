//
//  QuoteCard.swift
//  DreamBelieveAchieve
//
//  Created by Jake Garcia on 10/14/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct QuoteCard: View {
    @Environment(\.managedObjectContext) var moc
    var quote: Quote
    var body: some View {
        VStack {
            HStack {
                Text("\(quote.author ?? "Unknown")")
                    .font(.largeTitle)
            }
            .padding(.bottom, 25)
            HStack {
                Text("\(quote.text ?? "No quote text...")")
                    .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
            }
            HStack {
                Button(action: {
                    self.favoriteQuote()
                }) {
                    HStack {
                        
                        if quote.isFavorited {
                            Text("Unfavorite")
                            Image(systemName: "star.fill")
                        } else {
                            Text("Favorite")
                            Image(systemName: "star")
                        }
                    }
                }
            }
        }
    .padding()
    }
    
    func favoriteQuote() {
        quote.isFavorited = !quote.isFavorited
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

//struct QuoteCard_Previews: PreviewProvider {
//    static var previews: some View {
//        QuoteCard()
//    }
//}
