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

    var body: some View {
        

        ZStack {
            Color(red: 40 / 255, green: 47 / 255, blue: 56 / 255)
                 .edgesIgnoringSafeArea(.all)
            VStack {
                TextEditor(text: $nombreUsuario)
                                .padding(5)
                                .frame(width: 350, height: 50)
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                                .disableAutocorrection(true)
                                .scrollContentBackground(.hidden)
                                .background(Color.white).cornerRadius(10)
                TextEditor(text: $contrasena)
                                .padding(5)
                                .frame(width: 350, height: 50)
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                                .disableAutocorrection(true)
                                .scrollContentBackground(.hidden)
                                .background(Color.white)
                                .cornerRadius(10)
                
                Button("Iniciar Sesión") {
                    
                }.frame(width: 350, height: 50)
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                .background(Color(red: 100 / 255, green: 80 / 255, blue: 0 / 255)).foregroundColor(.black).padding(10).cornerRadius(10)
                
            }
            
            Image("logoIniciarSesion").resizable().scaledToFit().padding(.top, -300.0)
            
        }
    }
}

#Preview {
    @State var nombreUsuario = "Nombre de usuario"
    @State var contrasena = "Contraseña"
    iniciarSesion(nombreUsuario: $nombreUsuario, contrasena: $contrasena)
}
