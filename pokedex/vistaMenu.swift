import SwiftUI

struct vistaMenu: View {
    var userId = obtenerUserIdDesdeLocalStorage()
    @State var seleccion: Int = 0

    // Suponiendo que tienes un usuario actual y un viewModel
    @State private var usuarioActual: String = "UsuarioEjemplo"
    @State private var correoActual: String = "correo@ejemplo.com"
    @State private var passwordActual: String = "password123"
    var viewModel: ViewModel = ViewModel()

    var body: some View {
        TabView(selection: $seleccion) {
            listadoTarjetas()
                .tabItem {
                    Image("inicio")
                    Text("Inicio")
                }
                .tag(0)
            
            VistaBusqueda()
                .tabItem(){
                    Image("busqueda")
                    Text("Busqueda")
                }
                .tag(1)
            
            VistaCombate(
            )
            .tabItem {
                Image("pelea")
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
    vistaMenu(userId: UUID())
}
