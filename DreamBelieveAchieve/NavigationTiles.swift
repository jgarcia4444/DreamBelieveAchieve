//
//  NavigationTiles.swift
//  DreamBelieveAchieve
//
//  Created by Jake Garcia on 10/14/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI

struct NavigationTiles: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var body: some View {
        VStack {
            HStack {
                HStack {
                    NavigationLink(destination: RandomQuoteView()) {
                        Text("Random Quote")
                    }
                }
                .frame(width: screenWidth / 2, height: screenHeight / 4)
                .background(Color.yellow)
                HStack {
                    NavigationLink(destination: DailyQuoteTimeView()) {
                        Text("Set Daily Quote Time")
                    }
                }
                .frame(width: screenWidth / 2, height: screenHeight / 4)
                .background(Color.orange)
            }
            .frame(width: screenWidth, height: screenHeight / 4)
            HStack {
                HStack {
                    NavigationLink(destination: SearchQuoteView()) {
                        Text("Search Quotes")
                    }
                }
                .frame(width: screenWidth / 2, height: screenHeight / 4)
                .background(Color.red)
                HStack {
                    NavigationLink(destination: FavoriteQuotesView()) {
                        Text("Favorites")
                    }
                }
                .frame(width: screenWidth / 2, height: screenHeight / 4)
                .background(Color.pink)
            }
            .frame(width: screenWidth, height: screenHeight / 4)
        }
    }
}

struct NavigationTiles_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTiles()
    }
}
