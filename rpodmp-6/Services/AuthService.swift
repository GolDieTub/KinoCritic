import Foundation
import Firebase

class AuthService {
    private var movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func signIn(email: String, password: String, completion: @escaping (_: Bool, _: Movie?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(false, nil)
            } else {
                let id = result!.user.uid
                let movie = self.movieRepository.getById(id: id);
                
                completion(true, movie)
            }
        }
    }
    
    func signUp(name: String,
                email: String,
                password: String,
                director: String,
                description: String,
                year: Int,
                rating: Int,
                completion: @escaping (_: Bool, _: Movie?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                completion(false, nil)
            } else {
                var newMovie = Movie(authId: result!.user.uid,
                                   name: name,
                                   email: email,
                                   password: password,
                                   director: director,
                                   description: description,
                                   year: year,
                                   rating: rating);
                
                self.movieRepository.add(movie: &newMovie) { completion(true, newMovie) }
            }
        }
    }
}
