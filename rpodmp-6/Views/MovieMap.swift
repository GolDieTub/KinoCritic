import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var movies: [Movie]
    @Binding var selectedMovie: Movie?
    @Binding var shouldNavigate: Bool
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init (_ parent: MapView){
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = button
            
            return view
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            parent.selectedMovie = parent.movies.first(where: { $0.name == view.annotation?.title })
            parent.shouldNavigate = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        
        for movie in movies {
            if movie.location != nil {
                let annotation = MKPointAnnotation()
                annotation.title = movie.name
                annotation.subtitle = movie.director
                annotation.coordinate = CLLocationCoordinate2D(latitude: movie.location!.latitude, longitude: movie.location!.longitude)
                mapView.addAnnotation(annotation)
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
    }
}

struct MovieMap: View {
    @EnvironmentObject var movieRepository: MovieRepository
    @State private var shouldNavigate = false
    @State private var selectedMovie: Movie?
    
    var body: some View {
        VStack {
            MapView(movies: $movieRepository.movies, selectedMovie: $selectedMovie, shouldNavigate: $shouldNavigate).edgesIgnoringSafeArea(.all)
            
            if let selectedMovie = selectedMovie {
                NavigationLink(destination: MovieDetails(movie: selectedMovie), isActive: $shouldNavigate) {
                    EmptyView()
                }
            }
        }
    }
}
