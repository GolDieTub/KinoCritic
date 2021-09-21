
import SwiftUI

struct MovieList: View {
    @EnvironmentObject var app: Application
    @EnvironmentObject var movieRepository: MovieRepository
    
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(movieRepository.movies) { movie in
                    NavigationLink(destination: MovieDetails(movie: movie)) {
                        MoviePreview(movie: movie)
                            .accentColor(app.colorScheme == .dark ? .white : .black)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(app.color, lineWidth: 0))
                    }
                }
            }.padding()
        }
    }
}
