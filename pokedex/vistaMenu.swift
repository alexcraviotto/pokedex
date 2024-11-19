//
//  vistaMenu.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 16/11/24.
//

import SwiftUI

struct vistaMenu: View {
    @State var seleccion: Int = 0
  
    var body: some View {
        TabView(selection: $seleccion) {
            listadoTarjetas()
                .tabItem {
                    Image("inicio")
                    Text("Inicio")
                }
                .tag(0)
            
            VistaBusqueda()
                .tabItem {
                    Image("busqueda")
                    Text("Búsqueda")
                }
                .tag(1)
            
            VistaAjustes()
                .tabItem {
                    Image("ajustes")
                    Text("Ajustes")
                }
                .tag(2)
        }
    }
}


#Preview {
    vistaMenu()
}
