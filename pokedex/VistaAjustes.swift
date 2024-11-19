import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding(.horizontal, 40)
            .foregroundColor(.black)
    }
}

// Modificador para los botones
struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .padding(.vertical, -2)
            .frame(width: 330)
            .background(Color.yellow) // Botón amarillo
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct VistaAjustes: View {
    @Binding var usuario: String
    @Binding var correo: String
    @Binding var password: String
    @State private var confirmDelete: Bool = false
    @State private var usuarioInicial: String
    @State private var correoInicial: String
    @State private var passwordInicial: String
    @State private var selectedAvatar: String = "avatar1"
    @State private var showAvatarMenu: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var viewModel: ViewModel
    var userId: UUID  // Asegúrate de pasar el userId correcto
    
    init(usuario: Binding<String>, correo: Binding<String>, password: Binding<String>, userId: UUID, viewModel: ViewModel) {
        _usuario = usuario
        _correo = correo
        _password = password
        _usuarioInicial = State(initialValue: usuario.wrappedValue)
        _correoInicial = State(initialValue: correo.wrappedValue)
        _passwordInicial = State(initialValue: password.wrappedValue)
        self.userId = userId
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                // Avatar seleccionable
                VStack {
                    Button(action: {
                        showAvatarMenu.toggle() // Muestra el menú para seleccionar un avatar
                    }) {
                        Image(selectedAvatar) // Usa el nombre del avatar seleccionado
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4)) // Borde blanco alrededor del avatar
                            .shadow(radius: 10)
                    }
                }
                .padding(.bottom, 20)

                Text("Seleccionar Avatar")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                Group {
                    TextField("Usuario", text: $usuario)
                        .modifier(TextFieldModifier())
                        .onChange(of: usuario) { _ in }

                    TextField("Correo electrónico", text: $correo)
                        .modifier(TextFieldModifier())
                        .onChange(of: correo) { _ in }

                    SecureField("Contraseña", text: $password)
                        .modifier(TextFieldModifier())
                        .onChange(of: password) { _ in }
                }

                Button(action: {
                    if usuario != usuarioInicial {
                        viewModel.actualizarUsuario(userId: userId, newUsername: usuario, newEmail: nil, newPassword: nil)
                    }
                    if correo != correoInicial {
                        viewModel.actualizarUsuario(userId: userId, newUsername: nil, newEmail: correo, newPassword: nil)
                    }
                    if password != passwordInicial {
                        viewModel.actualizarUsuario(userId: userId, newUsername: nil, newEmail: nil, newPassword: password)
                    }
                }) {
                    Text("Actualizar Información")
                        .modifier(ButtonModifier())
                }

                Spacer()

                Button(action: {
                    confirmDelete.toggle()
                }) {
                    Text("Eliminar Cuenta")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                        .frame(width: 330)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 40)
                .alert(isPresented: $confirmDelete) {
                    Alert(
                        title: Text("¿Estás seguro?"),
                        message: Text("Esta acción eliminará permanentemente tu cuenta y todos los datos asociados."),
                        primaryButton: .destructive(Text("Eliminar")) {
                            if let user = viewModel.usersArray.first {
                                viewModel.eliminarUsuario(user: user)
                                presentationMode.wrappedValue.dismiss()
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Ajustes")
                        .font(.custom("Press Start 2P Regular", size: 24))
                        .foregroundColor(.black) // Color del título
                }
            }
            .actionSheet(isPresented: $showAvatarMenu) {
                ActionSheet(
                    title: Text("Selecciona un Avatar"),
                    buttons: [
                        .default(Text("Avatar 1")) { selectedAvatar = "avatar1" },
                        .default(Text("Avatar 2")) { selectedAvatar = "avatar2" },
                        .default(Text("Avatar 3")) { selectedAvatar = "avatar3" },
                        .cancel()
                    ]
                )
            }
        }
    }
}

struct VistaAjustes_Previews: PreviewProvider {
    static var previews: some View {
        VistaAjustes(usuario: .constant("Usuario Ejemplo"),
                    correo: .constant("correo@ejemplo.com"),
                    password: .constant("password123"),
                    userId: UUID(), // Asegúrate de pasar un UUID real
                    viewModel: ViewModel()) // Asegúrate de inicializar el viewModel correctamente
    }
}
