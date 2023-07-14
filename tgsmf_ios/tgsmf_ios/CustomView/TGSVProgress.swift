
import Foundation
import SwiftUI
import Gifu

struct TGSVProgress: View {
    @State private var isAnimating: Bool = false
    @State private var imageData: Data? = nil
    var body: some View {
//        GeometryReader { (geometry: GeometryProxy) in
//            TGSVImage(R.Image.ic_loading)
//            .frame(width: geometry.size.width, height: geometry.size.height)
//                                .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
//                                .animation(Animation
//                                            .timingCurve(0.5, 0.15  / 5, 0.25, 1, duration: 1.5)
//                                            .repeatForever(autoreverses: false))
//        }
//        .aspectRatio(1, contentMode: .fit)
//        .onAppear {
//            self.isAnimating = true
//        }
        VStack {
            if let data = imageData {
              GIFImage(data: data)
                //.frame(width: 100)
            } else {
              Text("")
                    .onAppear(perform: loadData)
            }
        }
        .onAppear()
    }
    private func loadData() {
      let task = URLSession.shared.dataTask(with: URL(string: "https://haksa.namhae.ac.kr/common/images/loading2.gif")!) { data, response, error in
        imageData = data
      }
      task.resume()
    }
    
}

struct TGSVProgress_Previews: PreviewProvider {
    static var previews: some View {
        TGSVProgress()
    }
}
