//
//  pantallaInicial.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 5/11/24.
//
import SwiftUI

struct pantallaInicial: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination:navegarIniciarSession()) {
                    ZStack {
                        VStack {
                            Image("carga")
                                .resizable()
                                .scaledToFill()
                        }
                        Image("logoPokemon")
                            .resizable()
                            .scaledToFit()
                            .padding(.top, -300.0)
                        Text("Pulsa para continuar")
                            .padding(.top, 620.0)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .navigationBarHidden(true)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

struct navegarIniciarSession: View {
    @State private var nombreUsuario = ""
    @State private var contrasena = ""

    var body: some View {
        iniciarSesion(nombreUsuario: $nombreUsuario, contrasena: $contrasena)
    }
}

#Preview {
    pantallaInicial()
}
