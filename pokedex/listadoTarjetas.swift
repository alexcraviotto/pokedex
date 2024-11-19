//
//  listadoTarjetas.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 16/11/24.
//

import SwiftUI

struct listadoTarjetas: View {
    /*let pokemons = [
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png")
    ]*/
    
    @State private var pokemons: [Pokemon] = []
    
    let columnas = [
          GridItem(.flexible()),
          GridItem(.flexible())
      ]
    
    var body: some View {
        VStack {
            HStack{
                Image("Pokedex").scaledToFit().frame(height: 50)
                Spacer()
            }.padding()
            ScrollView {
                LazyVGrid(columns: columnas, spacing: 20) {
                    ForEach(pokemons) { pokemon in
                        PokemonTarjeta2(
                            nombre: pokemon.name,
                            tipo: pokemon.types[0].types.name,
                            tipoS: pokemon.types[1].types.name,
                            numero: pokemon.id,
                            imagen: pokemon.sprites.other.officialArtwork.frontDefault
                        ).scaleEffect(0.9)
                            
                    }
                }
            }
        }.onAppear(){
            for i in 1...20{
                fetchPokemonData(pokemonId: i) { result in
                    switch result {
                    case .success(let pokemon):
                        pokemons.append(pokemon)
                        print("Imagen de official artwork: \(pokemon.sprites.other.officialArtwork.frontDefault)")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}


#Preview {
    listadoTarjetas()
}
