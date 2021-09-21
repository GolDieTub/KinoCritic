import SwiftUI

struct SignUp: View {
    @EnvironmentObject var app: Application
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var director = ""
    @State private var description = ""
    @State private var year = ""
    @State private var rating = ""
    
    func onSignUp() {
        app.authService.signUp(
            name: name,
            email: email,
            password: password,
            director: director,
            description: description,
            year: Int(year)!,
            rating: Int(rating)! ) {
            if $0 { app.loggedMovie = $1 }
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Primary information").textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                TextField("Director", text: $director)
                TextField("Description", text: $description)
                TextField("Year", text: $year).keyboardType(.numberPad)
                TextField("Rating", text: $rating).keyboardType(.numberPad)
            }
            
            Section {
                Button(action: onSignUp) {
                    HStack{
                        Spacer()
                        Text("Sign up")
                        Spacer()
                    }
                }
            }
        }.navigationBarTitle("Sign up")
    }
}
