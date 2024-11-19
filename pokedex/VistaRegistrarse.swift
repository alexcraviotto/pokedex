//
//  VistaRegistrarse.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 16/11/24.
//

import SwiftUI

struct VistaRegistrarse: View {
    @Binding var nombreUsuario: String
    @Binding var contrasena: String
    @Binding var repetirContrasena: String
    @State private var mensajeError: String = ""
    @Environment(\.presentationMode) var presentationMode
    private var camposRellenos: Bool {
           !nombreUsuario.isEmpty && !contrasena.isEmpty && !repetirContrasena.isEmpty
       }
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 40 / 255, green: 47 / 255, blue: 56 / 255)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image("logoRegistrarse").padding(.bottom)
                    
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
                    TextField("Repita su contraseña", text: $repetirContrasena)
                        .padding(5)
                        .frame(width: 350, height: 50)
                        .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                        .disableAutocorrection(true)
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                        .cornerRadius(10).disabled(!camposRellenos)
                    
                    
                    Image("imagenRegistro").resizable().scaledToFit().padding()
                    
                    Button("Registrarse") {
                        guard contrasena == repetirContrasena else {
                            mensajeError = "Las contraseñas no coinciden. Por favor, inténtalo de nuevo."
                            return
                        }
                        
                    }.frame(width: 350, height: 50)
                        .overlay(Rectangle().stroke(Color.black, lineWidth: 2))
                        .background(Color(red: 100 / 255, green: 80 / 255, blue: 0 / 255)).foregroundColor(.black).padding(10).cornerRadius(10)
                }
            }
        }.navigationBarBackButtonHidden(true).navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("< Iniciar sesión")
                .foregroundColor(.yellow)
        })
        }
    }


#Preview {
    @State var nombreUsuario = "Nombre de usuario"
    @State var contrasena = "Contraseña"
    @State var repetirContrasena = "Repita la contraseña"

    VistaRegistrarse(nombreUsuario: $nombreUsuario, contrasena: $contrasena, repetirContrasena: $repetirContrasena)}
