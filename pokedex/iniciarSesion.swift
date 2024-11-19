//
//  IniciarSesion.swift
//  Pokedex
//
//  Created by Aula03 on 19/11/24.
//

import SwiftUI

struct IniciarSesion: View {
    @Binding var usuario: String
    @Binding var password: String
    @State private var navegarARegistrarse = false
    
    private var camposRellenos: Bool {
        !usuario.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image("iniciarsesion")
                    .resizable()
                    .frame(width: 400, height: 150)
                TextField("Usuario", text: $usuario)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                TextField("Contraseña", text: $password)
                    .padding()
                    .padding(.vertical, -5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    .padding(.bottom, 90)
                Spacer()
                GifImage("pikachu")
                Button(action: {
                    
                    print("Iniciar Sesión presionado")
                }) {
                    Text("Iniciar Sesión")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .padding(.vertical, -2)
                        .frame(width: 330)
                        .background(Color(red: 1.0, green: 0.8, blue: 0.00392156862745098))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 40)
                
                Button("¿No tienes cuenta? Regístrate") {
                    navegarARegistrarse = true
                }
                .font(.headline)
                .foregroundColor(.white)
                
                NavigationLink(
                    destination: NavegacionVistaRegistrarse(),
                    isActive: $navegarARegistrarse
                ) {
                }
                
            }.background(Color(red: 0.13333333333333333, green: 0.1568627450980392, blue: 0.19215686274509805))
        }
        
        
    }
}

struct NavegacionVistaRegistrarse: View {
    @State private var usuario = ""
    @State private var password = ""
    @State private var repetirContrasena = ""
    
    var body: some View {
        Registro(
            usuario: $usuario,
            password: $password,
            repetirContrasena: $repetirContrasena
        )
    }
}

#Preview {
    @Previewable @State var usuario = "Nombre de usuario"
    @Previewable @State var password = "Contraseña"
    IniciarSesion(usuario: $usuario, password: $password)
}
