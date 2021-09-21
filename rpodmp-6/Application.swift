
import Foundation
import SwiftUI

class Application: ObservableObject {
    @Published var font: Font = Font.custom("Helvetica", size: 18)
    @Published var color: Color = .blue
    @Published var locale = "en"
    @Published var colorScheme: ColorScheme = .light
    @Published var loggedMovie: Movie? = nil
    var authService: AuthService
    var storageService = StorageService()
    
    private var _fontSize: CGFloat = 18.0
    private var _fontName = "Helvetica"
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    var fontSize: CGFloat {
        get {
            return _fontSize
        }
        
        set(size) {
            _fontSize = size
            font = Font.custom(_fontName, size: _fontSize)
        }
    }
    
    var fontName: String {
        get {
            return _fontName
        }
        
        set(name) {
            _fontName = name
            font = Font.custom(_fontName, size: _fontSize)
        }
    }
}
