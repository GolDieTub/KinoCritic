
import SwiftUI

struct MoviePreview: View {
    @EnvironmentObject var app: Application
    var movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            ImagePreview(images: movie.uiImages.map { Image(uiImage: $0) }).padding([.top])
            
            Spacer()
            Text(movie.name).truncationMode(.tail)
            Spacer()
            Text("Director: \(movie.director)").font(.footnote)
            Spacer()
            Text("Rating: \(String(movie.rating))").font(.footnote)
        }
        .padding()
        .frame(width: 340, height: 150, alignment: .center)
    }
}
