import SwiftUI

struct vistaMenuComabte: View {
    @State var seleccion: Int = 0
    var viewModel: ViewModel = ViewModel()

    var body: some View {
        TabView(selection: $seleccion) {
            listadoTarjetas()
                .tabItem {
                    Image("inicio")
                    Text("Pokédex")
                }
                .tag(0)
            
            VistaBusqueda()
                .tabItem(){
                    Image("busqueda")
                    Text("Busqueda")
                }
                .tag(1)

        }.navigationBarHidden(true)
    }
}

#Preview {
    vistaMenuComabte()
}
