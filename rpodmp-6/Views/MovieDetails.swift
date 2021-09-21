import SwiftUI
import AVKit

struct MovieDetails: View {
    @State var movie: Movie
    @State private var showEditSheet = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var app: Application
    
    var body: some View {
        VStack {
            if movie.video != nil && movie.video != "" {
                let player = AVPlayer(url: URL(string: movie.video!)!)
                
                VideoPlayer(player: player)
                    .onDisappear { player.pause() }
                    .frame(height: 220)
            }
        }
        
        ScrollView {
            VStack(alignment: .leading) {
                ImagePreview(images: movie.uiImages.map { Image(uiImage: $0) }).padding([.top])
                
                
                HStack(alignment: .top) {
                    Text("Name:").bold()
                    Text(movie.name)
                    Spacer()
                }
                .frame(width: 340)
                .padding([.trailing])
                Spacer()
                HStack(alignment: .top) {
                    Text("Director:").bold()
                    Text(movie.director)
                    Spacer()
                }.frame(width: 340)
             .padding([.bottom])
                
                HStack(alignment: .top) {
                    Text("Year:").bold()
                    Text("\(movie.year)")
                    Spacer()
                }.frame(width: 340)
             .padding([.bottom])
            
            
            HStack(alignment: .top) {
                Text("Rating:").bold()
                Text(String(movie.rating))
                Spacer()
            }.padding([.bottom])
            
            HStack(alignment: .top) {
                Text("Email:").bold()
                Text("\(movie.email)")
                Spacer()
            }.padding([.bottom])
        
            HStack(alignment: .top) {
                HStack(alignment: .top) {
                    Text("Description:").bold()
                    Spacer()
                    Text(movie.description)
                    Spacer()
                }
            }
            .frame(width: 380)
            .padding([.trailing])
            
            Spacer()
        }
    }
        .padding([.leading, .trailing])
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("Details", displayMode: .inline)
        .toolbar {
            if app.loggedMovie?.id == movie.id {
                Button(action: { showEditSheet = true }) { Text("Edit") }
            } else {
                EmptyView()
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationView {
                MovieEdit(showEditSheet: $showEditSheet, movie: movie) { app.loggedMovie = nil; presentationMode.wrappedValue.dismiss() }
            }
            .font(app.font)
            .colorScheme(app.colorScheme)
            .accentColor(app.color)
        }
    }
}


