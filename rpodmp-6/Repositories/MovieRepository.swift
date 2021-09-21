import Foundation
import SwiftUI
import Firebase

class User: Codable {
    var name: String
}

class MovieRepository: ObservableObject {
    @Published var movies = [Movie]()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    init() {
        db.collection("movies")
            .addSnapshotListener { querySnapshot, error in
                guard let querySnapshot = querySnapshot else { return }
                
                self.movies = querySnapshot.documents.compactMap { try? $0.data(as: Movie.self) }
                self.loadImages()
            }
    }
    
    func loadImages() {
        for movie in movies {
            for image in movie.images {
                let ref = storage.reference().child(image)
                
                ref.getData(maxSize: 10000000) { data, error in
                    if let data = data {
                        movie.uiImages.append(UIImage(data: data)!)
                    }
                }
            }
        }
    }
    
    func add(movie: inout Movie, completion: @escaping () -> Void) {
        do {
            let ref = try db.collection("movies").addDocument(from: movie) { _ in completion() }
            movie.id = ref.documentID
        } catch _ {
            print("Error adding movie!..")
        }
    }
    
    func getById(id: String) -> Movie? {
        return movies.first(where: { $0.authId == id })
    }
    
    func update(movie: Movie, completion: @escaping () -> Void) {
        do {
            try db.collection("movies").document(movie.id!).setData(from: movie) { error in
                if error == nil { completion() }
            }
        } catch _ {
            print("Error updating movie!..")
        }
    }
    
    func delete(id: String, completion: @escaping () -> Void) {
        db.collection("movies").document(id).delete() { error in
            if error == nil { completion() }
        }
    }
}

