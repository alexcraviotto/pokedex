//
//  Inicio.swift
//  Pokedex
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct Inicio: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination:navegarIniciarSession()) {
                ZStack {
                    GifImage("inicio")
                        .frame(height: 1000)
                        .ignoresSafeArea()
                    VStack {
                        Image("pokemon")
                            .resizable()
                            .frame(width: 400, height: 170)
                            .padding(.top, 150)
                        Spacer()
                        Text("Pulsa para continuar")
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 180)
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
        }
    }
}

struct navegarIniciarSession: View {
    @State private var nombreUsuario = ""
    @State private var contrasena = ""

    var body: some View {
        IniciarSesion(usuario: $nombreUsuario, password: $contrasena)
    }
}

#Preview {
    Inicio()
}
