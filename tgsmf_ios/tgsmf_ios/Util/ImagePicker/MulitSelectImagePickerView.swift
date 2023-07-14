
import SwiftUI
import BSImagePicker
import Photos

public struct MulitSelectImagePickerView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var arrSelectImage:[SelectedMedia]
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
    public typealias UIViewControllerType = ImagePickerController
    
    public func makeUIViewController(context: Context) -> ImagePickerController {
        let picker = ImagePickerController()
        
        picker.settings.selection.max = 5
        picker.settings.selection.unselectOnReachingMax = false
        picker.settings.theme.selectionStyle = .numbered
        picker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        picker.imagePickerDelegate = context.coordinator
        
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: ImagePickerController, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, arrSelectImage: $arrSelectImage)
    }
    
    
    public class Coordinator: ImagePickerControllerDelegate {
        private let parent: MulitSelectImagePickerView
        @Binding var arrSelectImage:[SelectedMedia]
        
        //        public init(_ parent: MulitSelectImagePickerView ) {
        //                self.parent = parent
        //            }
        init(parent: MulitSelectImagePickerView, arrSelectImage: Binding<[SelectedMedia]>) {
            self.parent = parent
            self._arrSelectImage = arrSelectImage
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didSelectAsset asset: PHAsset) {
            print("Selected: \(asset)")
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didDeselectAsset asset: PHAsset) {
            print("Deselected: \(asset)")
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didFinishWithAssets assets: [PHAsset]) {
            print("Finished with selections: \(assets)")
            
            if assets.count != 0 {
                
                for i in 0..<assets.count {
                    
                    let imageManager = PHImageManager.default()
                    let option = PHImageRequestOptions()
                    option.isSynchronous = true
                    var thumbnail = UIImage()
                    
                    imageManager.requestImage(for: assets[i],
                                              targetSize: CGSize(width: 200, height: 200),
                                              contentMode: .aspectFit,
                                              options: option) { (result, info) in
                        thumbnail = result!
                    }
                    
                    let data = thumbnail.jpegData(compressionQuality: 0.7)
                    let newImage = UIImage(data: data!)
                    
                    
                    // [이미지 뷰에 표시 실시]
                    self.arrSelectImage.append(SelectedMedia(image: newImage! as UIImage))
                    // self.imageView.image = newImage! as UIImage
                }
            }
            
            parent.dismiss()
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didCancelWithAssets assets: [PHAsset]) {
            print("Canceled with selections: \(assets)")
            parent.dismiss()
        }
        
        public func imagePicker(_ imagePicker: ImagePickerController, didReachSelectionLimit count: Int) {
            print("Did Reach Selection Limit: \(count)")
        }
    }
    
    
    
    
    
    //
    ////    private let sourceType: ImagePickerController .SourceType
    ////    private let onImagePicked: (UIImage) -> Void
    //
    //    //private let onImagePicked: ([UIImage]) -> Void
    //    @Environment(\.presentationMode) private var presentationMode
    //
    ////    public init(onImagePicked: @escaping ([UIImage]) -> Void) {
    ////        self.onImagePicked = onImagePicked
    ////    }
    //
    //
    //
    //    public func makeUIViewController(context: Context) -> BSImagePicker.ImagePickerController {
    //        let imagePicker = BSImagePicker.ImagePickerController(selectedAssets: selectedAssets)
    //        imagePicker.settings.selection.max = 5
    //        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
    //
    //        imagePicker.delegate = context.coordinator
    //
    //        return imagePicker
    //    }
    //
    //    public func updateUIViewController(_ uiViewController: BSImagePicker.ImagePickerController, context: Context) {}
    //
    //    public func makeCoordinator() -> MultiSelectCoordinator {
    //       return  MultiSelectCoordinator()
    //    }
    //
    //    func onImagePicked(_ arrImage : [UIImage]) {
    //
    //    }
    
    public class MultiSelectCoordinator: NSObject, UINavigationControllerDelegate, BSImagePicker.ImagePickerControllerDelegate {
        
        
        
        //        private let onDismiss: () -> Void
        //        private let onImagePicked: ([UIImage]) -> Void
        //
        //        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping ([UIImage]) -> Void) {
        //            self.onDismiss = onDismiss
        //            self.onImagePicked = onImagePicked
        //        }
        
        
        public func imagePicker(_ imagePicker: BSImagePicker.ImagePickerController, didSelectAsset asset: PHAsset) {
            print("---------------------didSelectAsset")
        }
        
        public func imagePicker(_ imagePicker: BSImagePicker.ImagePickerController, didDeselectAsset asset: PHAsset) {
            print("---------------------didDeselectAsset")
        }
        
        public func imagePicker(_ imagePicker: BSImagePicker.ImagePickerController, didFinishWithAssets assets: [PHAsset]) {
            print("---------------------didFinishWithAssets")
            //            if assets.count != 0 {
            //
            //                for i in 0..<assets.count {
            //
            //                    let imageManager = PHImageManager.default()
            //                    let option = PHImageRequestOptions()
            //                    option.isSynchronous = true
            //                    var thumbnail = UIImage()
            //
            //                    imageManager.requestImage(for: assets[i],
            //                                              targetSize: CGSize(width: 200, height: 200),
            //                                              contentMode: .aspectFit,
            //                                              options: option) { (result, info) in
            //                        thumbnail = result!
            //                    }
            //
            //                    let data = thumbnail.jpegData(compressionQuality: 0.7)
            //                    let newImage = UIImage(data: data!)
            //
            //
            //                    // [이미지 뷰에 표시 실시]
            //                    self.imageView.image = newImage! as UIImage
            //                }
            //            }
        }
        
        public func imagePicker(_ imagePicker: BSImagePicker.ImagePickerController, didCancelWithAssets assets: [PHAsset]) {
            print("---------------------didCancelWithAssets")
        }
        
        public func imagePicker(_ imagePicker: BSImagePicker.ImagePickerController, didReachSelectionLimit count: Int) {
            print("---------------------didReachSelectionLimit")
        }
        
        
    }
    
}

