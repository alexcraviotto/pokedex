//
//  eleccionPokemon.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 3/12/24.
//

import SwiftUI

struct eleccionPokemon: View {
    @Environment(\.presentationMode) var presentationMode
    var contrincante: Bool
    @State private var pokemonsUsuario: [Pokemon] = []
    @State private var pokemonsRival: [Pokemon] = []

    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    NavigationLink(destination: eleccionPokemon(contrincante: false)) {
                        VStack(spacing: 20) {
                            Image("Mewtwo")
                                .renderingMode(.original)
                                .scaleEffect(0.5)
                        }
                        .frame(width: 90, height: 90)
                    }
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    ).shadow(radius: 10)
                    NavigationLink(destination: eleccionPokemon(contrincante: false)) {
                        VStack(spacing: 20) {
                            Image("Mewtwo")
                                .renderingMode(.original)
                                .scaleEffect(0.5)
                        }
                        .frame(width: 90, height: 90)
                    }
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    ).shadow(radius: 10)
                    NavigationLink(destination: eleccionPokemon(contrincante: false)) {
                        VStack(spacing: 20) {
                            Image("Mewtwo")
                                .renderingMode(.original)
                                .scaleEffect(0.5)
                        }
                        .frame(width: 90, height: 90)
                    }
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    ).shadow(radius: 10)
                    
                }
                .padding()
                
                Text("VS")
                    .font(.custom("Press Start 2P Regular", size: 24))
                    .foregroundColor(.black)
                    .padding()
                
                HStack {
                    NavigationLink(destination: eleccionPokemon(contrincante: false)) {
                        VStack(spacing: 20) {
                            Image("Mewtwo")
                                .renderingMode(.original)
                                .scaleEffect(0.5)
                        }
                        .frame(width: 90, height: 90)
                    }
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    ).shadow(radius: 10)
                    NavigationLink(destination: eleccionPokemon(contrincante: false)) {
                        VStack(spacing: 20) {
                            Image("Mewtwo")
                                .renderingMode(.original)
                                .scaleEffect(0.5)
                        }
                        .frame(width: 90, height: 90)
                    }
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    ).shadow(radius: 10)
                    NavigationLink(destination: eleccionPokemon(contrincante: false)) {
                        VStack(spacing: 20) {
                            Image("Mewtwo")
                                .renderingMode(.original)
                                .scaleEffect(0.5)
                        }
                        .frame(width: 90, height: 90)
                    }
                    .padding()
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    ).shadow(radius: 10)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Elección")
                                .font(.custom("Press Start 2P Regular", size: 24))
                                .foregroundColor(.black)
                            Text("de equipos")
                                .font(.custom("Press Start 2P Regular", size: 24))
                                .foregroundColor(.black)
                        }
                        .padding(.top)
                    }
                }
            }
        }
    }
}

#Preview {
    eleccionPokemon(contrincante: true)
}

