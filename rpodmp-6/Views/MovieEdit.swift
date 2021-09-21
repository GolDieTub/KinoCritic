
import SwiftUI
import FirebaseFirestore

enum SheetMode {
    case video, image
}

class SheetConfig: ObservableObject {
    @Published var mode: SheetMode?
    @Published var show: Bool = false
    
    func show(mode: SheetMode) {
        self.mode = mode
        self.show = true
    }
}

struct MovieEdit: View {
    @EnvironmentObject var app: Application
    @EnvironmentObject var movieRepository: MovieRepository
    @Binding var showEditSheet: Bool
    @State private var name = ""
    @State private var password = ""
    @State private var director = ""
    @State private var description = ""
    @State private var year = 0
    @State private var rating = 0
    @State private var latitude: Double? = nil
    @State private var longitude: Double? = nil
    @ObservedObject private var config = SheetConfig()
    @State private var image: UIImage? = nil
    @State private var videoURL: URL? = nil
    @State private var wantToRemoveVideo = false
    @State private var showSpinner = false
    @State private var uploadedImages = [UIImage]()
    @State private var removedImages = [String]()
    @State private var removedUIImages = [UIImage]()
    @State var movie: Movie
    var afterDelete: () -> Void
    
    func createLabel(label: String) -> some View {
        Text(LocalizedStringKey(label))
            .opacity(0.3)
            .frame(width: 85, alignment: .leading)
    }
    
    func onDelete() {
        movieRepository.delete(id: movie.id!, completion: { showEditSheet = false; afterDelete() })
    }
    
    func onImageUpload(image: UIImage) {
        uploadedImages.append(image)
    }
    
    func afterVideoUploaded() {
        app.storageService.uploadImages(images: uploadedImages, name: movie.name) { imageNames in
            movie.images += imageNames
            movie.uiImages += uploadedImages
            uploadedImages = []
            
            app.storageService.removeImages(imageNames: removedImages) {
                movie.images.removeAll(where: { removedImages.contains($0) })
                movie.uiImages.removeAll(where: { removedUIImages.contains($0) })
                
                movie.name = name
                movie.password = password
                movie.director = director
                movie.description = description
                movie.year = year
                movie.rating = rating
                
                if latitude != nil && longitude != nil {
                    movie.location = GeoPoint(latitude: latitude!, longitude: longitude!)
                }
                
                movieRepository.update(movie: movie) { showSpinner = false; showEditSheet = false }
            }
        }
    }
    
    func onSave() {
        showSpinner = true
        
        if let url = videoURL {
            app.storageService.uploadVideo(url: url, name: name) {
                movie.video = $0
                afterVideoUploaded()
            }
        } else {
            if wantToRemoveVideo {
                movie.video = nil
                app.storageService.removeVideo(name: movie.name) { afterVideoUploaded() }
            } else {
                afterVideoUploaded()
            }
        }
    }
    
    func onAppear(){
        name = movie.name
        password = movie.password
        director = movie.director
        description = movie.description
        year = movie.year
        rating = movie.rating
        latitude = movie.location?.latitude
        longitude = movie.location?.longitude
    }
    
    var body: some View {
        Form {
            Section(header: Text("Primary information")) {
                HStack {
                    createLabel(label: "Name")
                    TextField("", text: $name)
                }
                
                HStack {
                    createLabel(label: "Director")
                    TextField("", text: $director)
                }
                
                HStack {
                    createLabel(label: "Description")
                    TextField("", text: $description)
                }
                
                HStack {
                    createLabel(label: "Year")
                    TextField("", text: Binding(get: { "\(year)" }, set: { year = Int($0) ?? year })).keyboardType(.numberPad)
                }
                
                HStack {
                    createLabel(label: "Password")
                    TextField("", text: $password)
                }
            }
            
            Section(header: Text("Rating").textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)) {
                HStack {
                    createLabel(label: "Rating")
                    TextField("", text:  Binding(get: { "\(rating)" }, set: { rating = Int($0) ?? rating })).keyboardType(.numberPad)
                }
                
            }
            
            Section(header: Text("Location").textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)) {
                HStack {
                    createLabel(label: "Latitude")
                    TextField("", text:  Binding(
                                get: { if let l = latitude { return "\(l)" } else { return "" } },
                                set: { latitude = Double($0) ?? latitude })).keyboardType(.numberPad)
                }
                
                HStack {
                    createLabel(label: "Longitude")
                    TextField("", text: Binding(
                                get: { if let l = longitude { return "\(l)" } else { return "" } },
                                set: { longitude = Double($0) ?? longitude })).keyboardType(.numberPad)
                }
            }
            
            
            Section(header: Text("Video").textCase(.uppercase)) {
                if videoURL != nil || movie.video != nil && !wantToRemoveVideo {
                    Button(action: { wantToRemoveVideo = true; videoURL = nil }) {
                        HStack {
                            Spacer()
                            Text("Remove video")
                            Spacer()
                        }
                    }.accentColor(.red)
                } else {
                    Button(action: { config.show(mode: .video) }){
                        HStack{
                            Spacer()
                            Text("Upload video")
                            Spacer()
                        }
                    }
                }
            }
            
            Section(header: Text("Images").textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)) {
                ForEach(0..<movie.uiImages.count, id: \.self) { i in
                    if !removedImages.contains(movie.images[i]) {
                        HStack(spacing: 80) {
                            Image(uiImage: movie.uiImages[i])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .cornerRadius(7)
                            
                            Button(action: { removedImages.append(movie.images[i]); removedUIImages.append(movie.uiImages[i]) }) { Text("Remove") }.accentColor(.red)
                        }
                    }
                }
                
                ForEach(0..<uploadedImages.count, id: \.self) { i in
                    HStack(spacing: 80) {
                        Image(uiImage: uploadedImages[i])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .cornerRadius(7)
                        
                        Button(action: { uploadedImages.remove(at: i) }) { Text("Remove") }.accentColor(.red)
                    }
                }
                
                HStack {
                    Spacer()
                    Button(action: { config.show(mode: .image) }) { Text("Upload image") }
                    Spacer()
                }
            }
            
            Section {
                Button(action: onDelete){
                    HStack{
                        Spacer()
                        Text("Delete")
                        Spacer()
                    }
                }.accentColor(.red)
            }
        }
        .onAppear { onAppear() }
        .navigationBarTitle("Edit details", displayMode: .inline)
        .navigationBarItems(leading: Spinner(show: showSpinner))
        .toolbar { Button(action: onSave) { Text("Save") } }
        .sheet(isPresented: $config.show) {
            if config.mode == .video {
                VideoPicker(videoURL: $videoURL)
            } else if config.mode == .image {
                ImagePicker(cb: onImageUpload)
            } else {
                EmptyView()
            }
        }
    }
}
