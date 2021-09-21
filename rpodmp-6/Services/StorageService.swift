import Foundation
import Firebase
import SwiftUI

class StorageService {
    let storage = Storage.storage()
    
    private func removeImageInner(imageNames: [String], index: Int, completion: @escaping () -> Void) {
        let ref = storage.reference().child(imageNames[index])
        
        ref.delete() { error in
            if error == nil {
                if index < imageNames.count - 1 {
                    self.removeImageInner(imageNames: imageNames, index: index + 1) { completion() }
                } else {
                    completion()
                }
            }
        }
    }
    
    func removeImages(imageNames: [String], completion: @escaping () -> Void) {
        if imageNames.count  == 0 {
            completion()
        } else {
            removeImageInner(imageNames: imageNames, index: 0) {
                completion()
            }
        }
    }
    
    private func uploadImagesInner(images: [UIImage], index: Int, name: String, imageNames: [String], completion: @escaping (_: [String]) -> Void) {
        let imageName = "\(name)_\(UUID()).jpg"
        var newImageNames = [] + imageNames
        newImageNames.append(imageName)
        
        let ref = storage.reference().child(imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(images[index].jpegData(compressionQuality: 1)!, metadata: metadata) { _, error in
            if error == nil {
                if index < images.count - 1 {
                    self.uploadImagesInner(images: images, index: index + 1, name: name, imageNames: newImageNames) {
                        completion($0)
                    }
                } else {
                    completion(newImageNames)
                }
            }
        }
    }
    
    func uploadImages(images: [UIImage], name: String, completion: @escaping (_: [String]) -> Void) {
        if images.count == 0 {
            completion([String]())
        } else {
            uploadImagesInner(images: images, index: 0, name: name, imageNames: [String]()) {
                completion($0)
            }
        }
    }
    
    func removeVideo(name: String, completion: @escaping () -> Void) {
        let ref = storage.reference().child("\(name).mp4")
        ref.delete { _ in completion() }
    }
    
    func uploadVideo(url: URL, name: String, completion: @escaping (_: String) -> Void) {
        let ref = storage.reference().child("\(name).mp4")
        
        do {
            let data = try Data(contentsOf: url)
            
            let metadata = StorageMetadata()
            metadata.contentType = "video/mp4"
            
            ref.putData(data, metadata: metadata) { _, error in
                if error == nil {
                    ref.downloadURL { url, error in
                        if let url = url {
                            completion(url.absoluteString)
                        }
                    }
                }
            }
        } catch _ {
            print("Error uploading video!..")
        }
    }
}
