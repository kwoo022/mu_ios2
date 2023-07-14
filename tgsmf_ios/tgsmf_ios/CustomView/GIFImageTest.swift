//
//  GIFImageTest.swift
//  tgsmf_ios
//
//  Created by idino on 2023/05/15.
//

import SwiftUI

struct GIFImageTest: View {
  @State private var imageData: Data? = nil

  var body: some View {
    VStack {
      //GIFImage(name: "loading")
       // .frame(height: 300)
      if let data = imageData {
        GIFImage(data: data)
          .frame(width: 300)
      } else {
        Text("")
          .onAppear(perform: loadData)
      }
    }
  }

  private func loadData() {
    let task = URLSession.shared.dataTask(with: URL(string: "https://haksa.namhae.ac.kr/common/images/loading.gif")!) { data, response, error in
      imageData = data
    }
    task.resume()
  }
}

struct GIFImageTest_Previews: PreviewProvider {
    static var previews: some View {
        GIFImageTest()
    }
}
