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
                        VStack {
                            Text("Random Quote")
                                .font(.headline)
                            Image(systemName: "questionmark")
                        }
                        .foregroundColor(.pink)
                    }
                }
                .frame(width: screenWidth / 2, height: screenHeight / 4)
                .background(Color.yellow)
                .shadow(radius: 20)
                
                HStack {
                    NavigationLink(destination: DailyQuoteTimeView()) {
                        VStack {
                            Text("Set Daily Quote Time")
                            Image(systemName: "alarm")
                        }
                        
                    }
                }
                .frame(width: screenWidth / 2, height: screenHeight / 4)
                .background(Color.orange)
                .foregroundColor(.red)
                .font(.headline)
                .shadow(radius: 20)
            }
            .frame(width: screenWidth, height: screenHeight / 4)
            HStack {
                HStack {
                    NavigationLink(destination: SearchQuoteView()) {
                        VStack {
                            Text("Search Quotes")
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
                .frame(width: screenWidth / 2, height: screenHeight / 4)
                .background(Color.red)
                .foregroundColor(.orange)
                .font(.headline)
                .shadow(radius: 20)
                HStack {
                    NavigationLink(destination: FavoriteQuotesView()) {
                        VStack {
                            Text("Favorites")
                            Image(systemName: "star.fill")
                        }
                        
                    }
                }
                .frame(width: screenWidth / 2, height: screenHeight / 4)
                .background(Color.pink)
                .foregroundColor(.yellow)
                .font(.headline)
                .shadow(radius: 20)
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
