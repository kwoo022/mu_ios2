//
//  TGSVImage.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/26.
//

import SwiftUI

struct TGSVImage: View {
    var uiImage : UIImage
    let contentMode: ContentMode
    let renderingMode : Image.TemplateRenderingMode?
    
  
    init(
        _ uiImage: UIImage,
        contentMode : ContentMode = .fit,
        renderingMode : Image.TemplateRenderingMode? = nil
    ) {
        self.uiImage = uiImage
        self.contentMode = contentMode
        self.renderingMode = renderingMode
    }
    
    var body: some View {
        return Image(uiImage: uiImage)
            .renderingMode(renderingMode)
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}

struct TGSVImage_Previews: PreviewProvider {
    static var previews: some View {
        TGSVImage(R.Image.splash_logo)
    }
}
