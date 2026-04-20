//
//  WebView.swift
//  Madal
//
//  Created by Solver on 14.04.2022.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let urlString : String?
    
    func makeUIView(context: Context) -> WebView.UIViewType {
         
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
         
        if let unWrappedString = urlString{
            
            if let url = URL(string: unWrappedString){
                
                let request = URLRequest(url: url)
                
                uiView.load(request)
                
            }
        }
    }
}

 
