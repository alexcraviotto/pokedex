import SwiftUI


struct Registro: View {
    @Binding var usuario: String
    @Binding var correo: String
    @Binding var password: String
    @Binding var repetirContrasena : String
        @State private var mensajeError: String = ""
        @Environment(\.presentationMode) var presentationMode
    var viewModel = ViewModel()
        private var camposRellenos: Bool {
            !usuario.isEmpty && !password.isEmpty && !repetirContrasena.isEmpty
           }
    
    
    var body: some View {
        NavigationView {
            VStack {
                Image("registro")
                    .resizable()
                    .frame(width: 400, height: 170)
                TextField("Usuario", text: $usuario)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                TextField("Correo electrónico", text: $correo)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                TextField("Contraseña", text: $password)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                TextField("Repita contraseña", text: $password)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    .padding(.bottom, 80)
                Spacer()
                GifImage("palkiadialga")
                Button(action: {
                    
                    print("Registrarse presionado")
                    viewModel.agregarUsuario(username: usuario, email: correo, password: password)
                }) {
                    Text("Registrarse")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .padding(.vertical, -2)
                        .frame(width: 330)
                        .background(Color(red: 1.0, green: 0.8, blue: 0.00392156862745098))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 40)
            }.background(Color(red: 0.13333333333333333, green: 0.1568627450980392, blue: 0.19215686274509805))
        }
        .navigationBarBackButtonHidden(true).navigationBarItems(leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("< Iniciar sesión")
                        .foregroundColor(.yellow)
                })
                }
    }

#Preview {
    @Previewable @State var nombreUsuario = "Nombre de usuario"
    @Previewable @State var correo = "Correo"
    @Previewable @State var contrasena = "Contraseña"
    @Previewable @State var repetirContrasena = "Repita la contraseña"
    Registro(usuario: $nombreUsuario, correo: $correo, password: $contrasena, repetirContrasena: $repetirContrasena)
}
