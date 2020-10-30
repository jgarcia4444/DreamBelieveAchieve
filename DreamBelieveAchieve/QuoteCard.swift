//
//  QuoteCard.swift
//  DreamBelieveAchieve
//
//  Created by Jake Garcia on 10/14/20.
//  Copyright © 2020 Jake Garcia. All rights reserved.
//

import SwiftUI
import Alamofire
import SwiftyJSON

extension UIView {
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct QuoteCard: View {
    @Environment(\.managedObjectContext) var moc
    @State private var showSocialAlert = false
    @State private var socialAlertTitle = ""
    @State private var socialAlertMessage = ""
    var quote: Quote
    var authorName: String {
        if quote.author == "" {
            return "Unknown"
        } else {
            return quote.author!
        }
    }
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("\(authorName)")
                        .font(.largeTitle)
                }
                .padding(.bottom, 25)
                HStack {
                    Text("\(quote.text ?? "No quote text...")")
                        .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(15)
            .background(LinearGradient(gradient: Gradient(colors: [.orange, .red, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.yellow, lineWidth: 4)
            )
            .shadow(radius: 20)
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
            .fixedSize(horizontal: true, vertical: false)
                .padding(15)
                .background(Color.orange)
                .clipShape(Capsule())
                .shadow(color: Color.black, radius: 4, x: 0, y: 0)
                .foregroundColor(.white)
                HStack {
                    Image("facebook")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.leading, 20)
                        .onTapGesture {
                            self.shareToSocialMedia(medium: .Facebook)
                    }
                    .animation(.easeIn)
                    
                    Image("instagram")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.leading, 20)
                        .onTapGesture {
                            self.shareToSocialMedia(medium: .Instagram)
                    }
                    .animation(.easeIn)
//                    Image("twitter")
//                        .resizable()
//                        .frame(width: 40, height: 40)
//                        .padding(.leading, 20)
//                        .onTapGesture {
//                            self.shareToSocialMedia(medium: .Twitter)
//                    }
                }
                
                .padding(.leading, 20)
            }
        }
    .padding(25)
        .animation(.default)
        .alert(isPresented: $showSocialAlert) {
             Alert(title: Text(socialAlertTitle), message: Text(socialAlertMessage), dismissButton: .default(Text("Okay")))
        }
    }
    
    enum MediaType {
        case Facebook
//        case Twitter
        case Instagram
    }
    
    func shareToSocialMedia(medium: MediaType) {
        let height = UIScreen.main.bounds.size.height * 0.5
        let width = UIScreen.main.bounds.size.width
        let rect = CGRect(x: 0, y: UIScreen.main.bounds.size.height * 0.25, width: width, height: height)
        guard let image = UIApplication.shared.windows.first?.rootViewController?.view.asImage(rect: rect) else {
            print("Could not convert view into an image")
            return
        }
        
        guard let imageData = image.pngData() else {
            print("Could not convert image to NSData")
            return
        }
        switch(medium) {
        case .Instagram:
            guard let url = URL(string: "instagram-stories://share") else {
                print("Could not change instagram url string to url")
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                let pasteBoardItems: [String: Any] = [
                    "com.instagram.sharedSticker.backgroundTopColor": "#fecb2e",
                    "com.instagram.sharedSticker.backgroundBottomColor" : "#fc3158",
                    "com.instagram.sharedSticker.stickerImage": imageData
                ]
                let pasteBoard = UIPasteboard.general
                pasteBoard.setItems([pasteBoardItems], options: [.expirationDate: Date().addingTimeInterval(600)])
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Cannot open the Instagram app. Instagram app not on user's device.")
                self.setAlertContent(appName: "Instagram")
            }
            break
        case .Facebook:
            guard let url = URL(string: "facebook-stories://share") else {
                print("Could not change facebook url string to url")
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                let items: [String: Any] = [
                    "com.facebook.sharedSticker.appID": "327002905407721",
                    "com.facebook.sharedSticker.backgroundTopColor": "#fecb2e",
                    "com.facebook.sharedSticker.backgroundBottomColor": "#fc3158",
                    "com.facebook.sharedSticker.stickerImage": imageData
                ]
                let pasteBoard = UIPasteboard.general
                pasteBoard.setItems([items], options: [.expirationDate: Date().addingTimeInterval(600)])
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Could not open Facebook.")
                self.setAlertContent(appName: "Facebook")
            }
            break
//        case .Twitter:
//            AF.request("https://upload.twitter.com/1.1/media/upload.json", method: .post, parameters: ["media": CIImage(data: imageData) as Any], encoding: URLEncoding.queryString)
//                .response { response in
//                    if let data = response.data {
//                        let json = try? JSON(data: data)
//                        print(json)
//                    }
//            }
//            break
        }
    }
    
    func setAlertContent(appName: String) {
        self.socialAlertTitle = "\(appName) not found"
        self.socialAlertMessage = "You must have \(appName) downloaded on your device to share to your story on \(appName)"
        self.showSocialAlert = true
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
