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
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.purple, .red, .pink, .orange, .yellow]), startPoint: .bottomTrailing, endPoint: .topLeading)
                VStack {
                    HStack() {
                        VStack(alignment: .leading) {
                            HStack{
                                HStack {
                                    Text("D")
                                        .font(.custom("SignPainter-HouseScript", size: 50))
                                    Text("ream")
                                        .font(.custom("SignPainter-HouseScript", size: 25))
                                }
                                .foregroundColor(.pink)
                            }
                            .frame(width: 150)
                            .background(LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(radius: 5)
                            HStack {
                                HStack {
                                    Text("B")
                                        .font(.custom("SignPainter-HouseScript", size: 50))
                                    Text("elieve")
                                        .font(.custom("SignPainter-HouseScript", size: 25))
                                }
                                .foregroundColor(.white)
                            
                            }
                            .frame(width: 175)
                            .background(LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(radius: 10)
                            HStack {
                                HStack {
                                    Text("A")
                                        .font(.custom("SignPainter-HouseScript", size: 50))
                                    Text("chieve")
                                        .font(.custom("SignPainter-HouseScript", size: 25))
                                        .fixedSize(horizontal: true, vertical: false)
                                }
                            }
                                
                            .foregroundColor(.yellow)
                            .frame(width: 200)
                            .background(LinearGradient(gradient: Gradient(colors: [.red, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(radius: 15)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 2)
                    HStack {
                        NavigationTiles()
                    }
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 2)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
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
    }
    
    func loopThroughQuotes(quotesJson: JSON) {
        quotesJson.forEach { (id, json) in
            let quoteToBeSaved = Quote(context: moc)
            let text = json["text"]
            if json["author"].stringValue == "null" {
                quoteToBeSaved.author = "Unknown"
            } else {
                quoteToBeSaved.author = json["author"].stringValue
            }
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
