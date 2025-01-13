import SwiftUI

struct Registro: View {
    // Usamos @State para manejar los valores localmente dentro de la vista
    @State private var usuario: String = ""
    @State private var correo: String = ""
    @State private var password: String = ""
    @State private var repetirContrasena: String = ""
    @State private var mensajeError: String = ""
    @State private var registroExitoso = false  // Estado para controlar la navegación a VistaMenu
    @State private var intentoEnvio = false  // Estado para saber si el usuario ha intentado registrar
    @Environment(\.presentationMode) var presentationMode
    var viewModel = ViewModel()

    // Validar si los campos están rellenos
    var camposRellenos: Bool {
        !usuario.isEmpty && !correo.isEmpty && !password.isEmpty && !repetirContrasena.isEmpty
    }
    
    // Verificar si las contraseñas coinciden
    var contraseñasCoinciden: Bool {
        password == repetirContrasena
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image("registro")
                    .resizable()
                    .frame(width: 400, height: 170)
                
                // Campo Usuario
                TextField("Usuario", text: $usuario)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                    .autocapitalization(.none)
                
                // Campo Correo Electrónico
                TextField("Correo electrónico", text: $correo)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    .autocapitalization(.none)
                
                // Campo Contraseña
                SecureField("Contraseña", text: $password)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                
                // Campo Repetir Contraseña
                SecureField("Repita contraseña", text: $repetirContrasena)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                
                Spacer()
                
                GifImage("palkiadialga") // Animación (supongo que es un componente separado)
                
                // Mostrar mensaje de error solo después de intentar el envío
                if intentoEnvio {
                    if !contraseñasCoinciden && !repetirContrasena.isEmpty {
                        Text("Las contraseñas no coinciden.")
                            .foregroundColor(.red)
                            .padding(.horizontal, 40)
                    }
                    
                    if !camposRellenos {
                        Text("Por favor, completa todos los campos.")
                            .foregroundColor(.red)
                            .padding(.horizontal, 40)
                    }
                }
                
                // Botón de registro
                Button(action: {
                    intentoEnvio = true  // Indicar que el usuario intentó enviar el formulario
                    
                    if camposRellenos && contraseñasCoinciden {
                        // Realizar registro
                        viewModel.agregarUsuario(username: usuario, email: correo, password: password)
                        
                        // Indicar que el registro fue exitoso
                        registroExitoso = true
                        
                        // Esperar un poco antes de navegar a VistaMenu
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            // Después de 1 segundo, navegamos a VistaMenu
                            presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        if !contraseñasCoinciden {
                            mensajeError = "Las contraseñas no coinciden."
                        } else {
                            mensajeError = "Por favor completa todos los campos."
                        }
                    }
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
                
                // Mostrar mensaje de registro exitoso
                if registroExitoso {
                    Text("¡Registro exitoso!")
                        .foregroundColor(.green)
                        .padding()
                        .transition(.opacity) // Animación para el mensaje
                }
            }
            .background(Color(red: 0.13333333333333333, green: 0.1568627450980392, blue: 0.19215686274509805))
            
            // Navegar a VistaMenu después de un registro exitoso
            NavigationLink(destination: vistaMenu(viewModel: viewModel), isActive: $registroExitoso) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("< Iniciar sesión")
                .foregroundColor(.yellow)
        })
    }
}

#Preview {
    Registro()
}
