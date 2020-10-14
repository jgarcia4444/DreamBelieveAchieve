//
//  QuoteCard.swift
//  DreamBelieveAchieve
//
//  Created by Jake Garcia on 10/14/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct QuoteCard: View {
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
            }
        }
    .padding()
    }
}

//struct QuoteCard_Previews: PreviewProvider {
//    static var previews: some View {
//        QuoteCard()
//    }
//}
