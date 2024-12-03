import SwiftUI

struct vistaMenu: View {
    @State var seleccion: Int = 0

    // Suponiendo que tienes un usuario actual y un viewModel
    @State private var usuarioActual: String = "UsuarioEjemplo"
    @State private var correoActual: String = "correo@ejemplo.com"
    @State private var passwordActual: String = "password123"
    @State private var userId: UUID = UUID()
    var viewModel: ViewModel = ViewModel()

    var body: some View {
        TabView(selection: $seleccion) {
            listadoTarjetas()
                .tabItem {
                    Image("inicio")
                    Text("Inicio")
                }
                .tag(0)
            
            VistaAjustes(
                usuario: $usuarioActual,
                correo: $correoActual,
                password: $passwordActual,
                userId: userId,
                viewModel: viewModel
            )
            .tabItem {
                Image("busqueda")
                    .scaledToFit()
                    .scaleEffect(0.2)
                Text("Búsqueda")
            }
            .tag(1)
            
            VistaAjustes(
                usuario: $usuarioActual,
                correo: $correoActual,
                password: $passwordActual,
                userId: userId,
                viewModel: viewModel
            )
            .tabItem {
                Image("pelea")
                    .scaledToFit()
                    .scaleEffect(0.2)
                Text("Combate")
            }
            .tag(2)
    
            
            VistaAjustes(
                usuario: $usuarioActual,
                correo: $correoActual,
                password: $passwordActual,
                userId: userId,
                viewModel: viewModel
            )
            .tabItem {
                Image("ajustes")
                Text("Ajustes")
            }
            .tag(3)
        }.navigationBarHidden(true)
    }
}

#Preview {
    vistaMenu()
}
