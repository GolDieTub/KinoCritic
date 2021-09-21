import SwiftUI

struct SignIn: View {
    @EnvironmentObject var app: Application
    @State var email = "";
    @State var password = "";
    
    func onSignIn() {
        app.authService.signIn(email: email, password: password) { if $0 { app.loggedMovie = $1 } }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
                
                Section {
                    Button(action: onSignIn) {
                        HStack{
                            Spacer()
                            Text("Sign in")
                            Spacer()
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: SignUp()) { Text("Don't have an account? Sign up") }
                }
            }.navigationBarTitle("Sign in")
        }
    }
}
