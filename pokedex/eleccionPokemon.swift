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
            VStack {
                HStack {
                    ForEach(0..<3) { index in
                        if index < pokemonsUsuario.count {
                            let pokemon = pokemonsUsuario[index]
                            VStack(spacing: 20) {
                                Button(action: { seleccionarPokemon(pokemon) }) {
                                    if let imageUrl = URL(string: pokemon.sprites.other.officialArtwork.frontDefault) {
                                        AsyncImage(url: imageUrl) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    } else {
                                        Image(systemName: "questionmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                }
                                .frame(width: 90, height: 90)
                                .padding()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                                .shadow(radius: 10)
                            }
                        } else {
                            VStack(spacing: 20) {
                                Button(action: {
                                }) {
                                    Image("Pulsa para elegir")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                .frame(width: 90, height: 90)
                                .padding()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                                .shadow(radius: 10)
                            }
                        }
                    }
                }
                .padding()

                
                Text("VS")
                    .font(.custom("Press Start 2P Regular", size: 24))
                    .foregroundColor(.black)
                    .padding()
                
                HStack {
                    if !contrincante {
                        ForEach(pokemonsRival) { pokemon in
                            VStack(spacing: 20) {
                                if let imageUrl = URL(string: pokemon.sprites.other.officialArtwork.frontDefault) {
                                    AsyncImage(url: imageUrl) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                } else {
                                    Image(systemName: "questionmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                            .frame(width: 90, height: 90)
                            .padding()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                            .shadow(radius: 10)
                        }
                    }
                }
                .onAppear(){
                    if(!contrincante){
                       // inicializarPokemonsRival(&pokemonsRival)
                        inicializarPokemonsRival(&pokemonsRival, &pokemonsUsuario)
                    }
                }
                
                if !contrincante {
                    Button(action: seleccionarPokemonAleatorios) {
                        Text("Aleatorio")
                            .font(.custom("Press Start 2P Regular", size: 10))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(100)
                            .shadow(radius: 3)
                    }
                    .padding(.top, 20)
                }
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

    func seleccionarPokemon(_ pokemon: Pokemon) {
           if pokemonsUsuario.count < 3 {
               pokemonsUsuario.append(pokemon)
           }
       }

    func seleccionarPokemonAleatorios() {
        // Lógica para seleccionar Pokémon aleatorios.
        print("Seleccionar Pokémon aleatorios")
    }
}

//func inicializarPokemonsRival(_ pokemonsRival: inout [Pokemon]) {
func inicializarPokemonsRival(_ pokemonsRival: inout [Pokemon], _ pokemonsUsuario: inout [Pokemon]) {
    pokemonsUsuario = [
        Pokemon(
            id: 1,
            name: "Bulbasaur",
            types: [Pokemon.Types(type: Pokemon.PokemonType(name: "Grass"))],
            sprites: Pokemon.Sprites(
                other: Pokemon.OtherSprites(
                    officialArtwork: Pokemon.OfficialArtwork(
                        frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
                    )
                )
            )
        )]
    
       pokemonsRival = [
           Pokemon(
               id: 1,
               name: "Bulbasaur",
               types: [Pokemon.Types(type: Pokemon.PokemonType(name: "Grass"))],
               sprites: Pokemon.Sprites(
                   other: Pokemon.OtherSprites(
                       officialArtwork: Pokemon.OfficialArtwork(
                           frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
                       )
                   )
               )
           ),
           Pokemon(
               id: 4,
               name: "Charmander",
               types: [Pokemon.Types(type: Pokemon.PokemonType(name: "Fire"))],
               sprites: Pokemon.Sprites(
                   other: Pokemon.OtherSprites(
                       officialArtwork: Pokemon.OfficialArtwork(
                           frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png"
                       )
                   )
               )
           ),
           Pokemon(
               id: 7,
               name: "Squirtle",
               types: [Pokemon.Types(type: Pokemon.PokemonType(name: "Water"))],
               sprites: Pokemon.Sprites(
                   other: Pokemon.OtherSprites(
                       officialArtwork: Pokemon.OfficialArtwork(
                           frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png"
                       )
                   )
               )
           )
       ]
   }

#Preview {
    eleccionPokemon(contrincante: false)
}
