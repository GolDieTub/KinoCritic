import SwiftUI

struct ImagePreview: View {
    @EnvironmentObject var app: Application
    var images: [Image]
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    

    func viewAll() -> some View {
        NavigationLink(destination: ImageList(current: 9, images: images)) {
            images[9]
                .resizable()
                .scaledToFill()
                .frame(width: 65, height: 65)
                .opacity(0.4)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(app.color, lineWidth: 2).overlay(Text("View all").font(.callout)))
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<min(9, images.count), id: \.self) { i in
                NavigationLink(destination: ImageList(current: i, images: images)) {
                    images[i]
                        .resizable()
                        .scaledToFill()
                        .frame(width: 65, height: 65)
                        .cornerRadius(10)
                }
            }
            
            if images.count >= 10 {
                viewAll()
            }
        }
    }
}
