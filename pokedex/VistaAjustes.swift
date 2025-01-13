import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding(.horizontal, 24)
            .foregroundColor(.black)
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding(.horizontal, 24)
    }
}

struct VistaAjustes: View {
    @State private var usuario: String
    @State private var correo: String
    @State private var password: String
    @State private var confirmDelete: Bool = false
    @State private var usuarioInicial: String
    @State private var correoInicial: String
    @State private var passwordInicial: String
    @State private var selectedAvatar: Int64
    @State private var showAvatarMenu: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var viewModel: ViewModel
    var userId: UUID

    init(userId: UUID, viewModel: ViewModel) {
        if let user = viewModel.usersArray.first(where: { $0.id == userId }) {
            _usuario = State(initialValue: user.username ?? "")
            _correo = State(initialValue: user.email ?? "")
            _password = State(initialValue: user.password ?? "")
            _usuarioInicial = State(initialValue: user.username ?? "")
            _correoInicial = State(initialValue: user.email ?? "")
            _passwordInicial = State(initialValue: user.password ?? "")
            _selectedAvatar = State(initialValue: user.avatar)
        } else {
            _usuario = State(initialValue: "")
            _correo = State(initialValue: "")
            _password = State(initialValue: "")
            _usuarioInicial = State(initialValue: "")
            _correoInicial = State(initialValue: "")
            _passwordInicial = State(initialValue: "")
            _selectedAvatar = State(initialValue: 1)
        }
        self.userId = userId
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack {
                    Button(action: {
                        showAvatarMenu.toggle()
                    }) {
                        VStack(spacing: 12) {
                            Image("avatar\(selectedAvatar)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)

                            Text("Seleccionar Avatar")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(16)

                Group {
                    TextField("Usuario", text: $usuario)
                        .modifier(TextFieldModifier())

                    TextField("Correo electrónico", text: $correo)
                        .modifier(TextFieldModifier())

                    SecureField("Contraseña", text: $password)
                        .modifier(TextFieldModifier())
                }

                Button(action: actualizarDatos) {
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
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 24)
                }
                .alert(isPresented: $confirmDelete) {
                    Alert(
                        title: Text("¿Estás seguro?"),
                        message: Text("Esta acción eliminará permanentemente tu cuenta y todos los datos asociados."),
                        primaryButton: .destructive(Text("Eliminar")) {
                            eliminarUsuario()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Ajustes")
                        .font(.custom("Press Start 2P Regular", size: 24))
                        .foregroundColor(.black)
                }
            }
            .actionSheet(isPresented: $showAvatarMenu) {
                ActionSheet(
                    title: Text("Selecciona un Avatar"),
                    buttons: [
                        .default(Text("Avatar 1")) { selectedAvatar = 1 },
                        .default(Text("Avatar 2")) { selectedAvatar = 2 },
                        .default(Text("Avatar 3")) { selectedAvatar = 3 },
                        .cancel()
                    ]
                )
            }
        }
    }

    private func actualizarDatos() {
        if usuario != usuarioInicial {
            viewModel.actualizarUsuario(userId: userId, newUsername: usuario, newEmail: nil, newPassword: nil, avatar: selectedAvatar)
        }
        if correo != correoInicial {
            viewModel.actualizarUsuario(userId: userId, newUsername: nil, newEmail: correo, newPassword: nil, avatar: selectedAvatar)
        }
        if password != passwordInicial {
            viewModel.actualizarUsuario(userId: userId, newUsername: nil, newEmail: nil, newPassword: password, avatar: selectedAvatar)
        }
        
        viewModel.actualizarUsuario(userId: userId, newUsername: nil, newEmail: nil, newPassword: nil, avatar: selectedAvatar)
        
    }

    private func eliminarUsuario() {
        if let user = viewModel.usersArray.first(where: { $0.id == userId }) {
            viewModel.eliminarUsuario(user: user)
            presentationMode.wrappedValue.dismiss()
        }
    }
}
