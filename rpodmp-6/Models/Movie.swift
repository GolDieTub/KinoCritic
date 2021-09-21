import MapKit
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class Movie: Codable, Identifiable, ObservableObject {
    @DocumentID var id: String?
    var authId: String
    var name: String
    var email: String
    var password: String
    var director: String
    var description: String
    var year: Int
    var rating: Int
    var images: [String]
    @Published var uiImages = [UIImage]()
    var location: GeoPoint?
    var video: String?
    
    init(authId: String, name: String, email: String, password: String, director: String, description: String, year: Int, rating: Int) {
        self.authId = authId
        self.name = name
        self.email = email
        self.password = password
        self.director = director
        self.description = description
        self.year = year
        self.rating = rating
        self.images = [String]()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, authId, name, email, password, director, description, year, rating, images, location, video
    }
}
