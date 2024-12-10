import SwiftUI

struct IniciarSesion: View {
    @Binding var email: String
    @Binding var password: String
    @State private var navegarARegistrarse = false
    @State private var mostrarError = false
    @State private var mensajeError = ""
    @State private var inicioCorrecto = false  // Estado para saber si el login fue exitoso
    @State private var navegarAVistaMenu = false  // Estado para controlar la navegación a vistaMenu
    @ObservedObject var viewModel: ViewModel
    
    private var camposRellenos: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image("iniciarsesion")
                    .resizable()
                    .frame(width: 400, height: 150)
                
                TextField("Email", text: $email)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                    .autocapitalization(.none)
                
                SecureField("Contraseña", text: $password)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    .padding(.bottom, 90)
                    .autocapitalization(.none)
                
                Spacer()
                
                GifImage("pikachu") // Animación (supongo que es un componente separado)
                
                Button(action: {
                    if camposRellenos {
                        if let usuarioValido = viewModel.verificarUsuario(email: email, password: password) {
                            // Si el usuario es encontrado, iniciar animación de éxito y luego navegar
                            print("Sesión iniciada para el usuario: \(usuarioValido.username ?? "Desconocido")")
                            
                            // Guardar el userId en UserDefaults
                            UserDefaults.standard.set(usuarioValido.id?.uuidString, forKey: "userId")
                            
                            // Establecer que el login fue exitoso y luego navegar a vistaMenu
                            inicioCorrecto = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                // Esperamos 1 segundo para mostrar la animación y luego navegar
                                navegarAVistaMenu = true
                            }
                        } else {
                            // Mostrar mensaje de error si no se encuentran las credenciales
                            mostrarError = true
                            mensajeError = "Usuario o contraseña incorrectos."
                        }
                    } else {
                        mostrarError = true
                        mensajeError = "Por favor completa todos los campos."
                    }
                }) {
                    Text("Iniciar Sesión")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .padding(.vertical, -2)
                        .frame(width: 330)
                        .background(Color(red: 1.0, green: 0.8, blue: 0.00392156862745098))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 40)
                
                Button("¿No tienes cuenta? Regístrate") {
                    navegarARegistrarse = true
                }
                .font(.headline)
                .foregroundColor(.white)
                
                NavigationLink(
                    destination: Registro(),
                    isActive: $navegarARegistrarse
                ) {
                    EmptyView()
                }.navigationBarHidden(true)
                
                // Mostrar mensaje de error si es necesario
                if mostrarError {
                    Text(mensajeError)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Navegar a la vistaMenu después del inicio correcto
                NavigationLink(
                    destination: vistaMenu(userId: obtenerUserIdDesdeLocalStorage(), viewModel: viewModel),
                    isActive: $navegarAVistaMenu
                ) {
                    EmptyView()
                }.navigationBarHidden(true)
            }
            .background(Color(red: 0.13333333333333333, green: 0.1568627450980392, blue: 0.19215686274509805))
        }
        .navigationBarBackButtonHidden(true)
    }
    

}
