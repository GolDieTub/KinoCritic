
import SwiftUI

struct Options: View {
    @EnvironmentObject var app: Application
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $app.locale, label: Text("Language")) {
                    Text("English").tag("en")
                    Text("Русский").tag("ru")
                }
                
                ColorPicker("Color", selection: $app.color)
                
                Picker(selection: $app.fontName, label: Text("Font")) {
                    Text("Helvetica").tag("Helvetica")
                    Text("Futura").tag("Futura")
                    Text("Papyrus").tag("Papyrus")
                    Text("Baskerville").tag("Baskerville")
                    Text("Andale Mono").tag("Andale Mono")
                }
                
                HStack {
                    Text("Size")
                    Spacer()
                    Slider(value: $app.fontSize, in: 14...26, step: 1)
                    Spacer()
                    Text("\(Int(round(app.fontSize)))")
                }
                
                Toggle(isOn: Binding(get: { app.colorScheme == .dark }, set: { app.colorScheme = $0 ? .dark : .light })) {
                    Text("Dark mode")
                }
            }
            
            Section {
                Button(action: { app.loggedMovie = nil }) {
                    HStack{
                        Spacer()
                        Text("Sign out")
                        Spacer()
                    }
                }.accentColor(.red)
            }
        }.navigationBarHidden(true)
    }
}
