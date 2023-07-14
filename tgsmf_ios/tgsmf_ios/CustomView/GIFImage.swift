//
//  SwiftUIView.swift
//  nhu
//
//  Created by idino on 2023/05/15.
//

import SwiftUI

struct GIFImage: UIViewRepresentable {
    private let data : Data?
    private let name : String?
    
    init(data : Data){
        self.data = data
        self.name = nil
    }
    
    public init(name: String){
        self.data = nil
        self.name = name
    }
    
    func makeUIView(context: Context) -> UIGIFImage {
        if let data = data {
            return UIGIFImage(data: data)
        } else {
            return UIGIFImage(name: name ?? "")
        }
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let data = data {
            uiView.updateGIF(data: data)
        }else {
            uiView.updateGIF(name: name ?? "")
        }
    }
}
