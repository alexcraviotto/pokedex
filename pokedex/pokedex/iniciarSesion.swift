//
//  iniciarSesion.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 12/11/24.
//

import SwiftUI
struct iniciarSesion: View {
    @Binding var nombreUsuario: String
    @Binding var contrasena: String
    @State private var navegarARegistrarse = false

    private var camposRellenos: Bool {
        !nombreUsuario.isEmpty && !contrasena.isEmpty
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 40 / 255, green: 47 / 255, blue: 56 / 255)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image("logoIniciarSesion").padding(.bottom)
                    
                    TextField("Nombre de usuario", text: $nombreUsuario)
                        .padding(5)
                        .frame(width: 350, height: 50)
                        .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                        .disableAutocorrection(true)
                        .scrollContentBackground(.hidden)
                        .background(Color.white).cornerRadius(10)
                    
                    TextField("Contraseña", text: $contrasena)
                        .padding(5)
                        .frame(width: 350, height: 50)
                        .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                        .disableAutocorrection(true)
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Button("Iniciar Sesión") {

                    }
                    .frame(width: 350, height: 50)
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                    .background(Color(red: 100 / 255, green: 80 / 255, blue: 0 / 255))
                    .foregroundColor(.black)
                    .padding(10)
                    .cornerRadius(10)
                    .disabled(!camposRellenos)
                    
                    Image("imagenInicioSesion").resizable().scaledToFit().padding()
                    
                    Button("Registrarse") {
                        navegarARegistrarse = true
                    }
                    .frame(width: 350, height: 50)
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                    .background(Color(red: 100 / 255, green: 80 / 255, blue: 0 / 255))
                    .foregroundColor(.black)
                    .padding(10)
                    .cornerRadius(10)
                    
                    NavigationLink(
                        destination: NavegacionVistaRegistrarse(),
                        isActive: $navegarARegistrarse
                    ) {
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct NavegacionVistaRegistrarse: View {
    @State private var nombreUsuario = ""
    @State private var contrasena = ""
    @State private var repetirContrasena = ""

    var body: some View {
        VistaRegistrarse(
            nombreUsuario: $nombreUsuario,
            contrasena: $contrasena,
            repetirContrasena: $repetirContrasena
        )
    }
}

#Preview {
    @State var nombreUsuario = "Nombre de usuario"
    @State var contrasena = "Contraseña"
    iniciarSesion(nombreUsuario: $nombreUsuario, contrasena: $contrasena)
}
