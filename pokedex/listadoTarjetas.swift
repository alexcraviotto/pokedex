//
//  listadoTarjetas.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 16/11/24.
//

import SwiftUI

struct listadoTarjetas: View {
    let pokemons = [
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png")
    ]
    
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
                            nombre: pokemon.nombre,
                            tipo: pokemon.tipo,
                            tipoS: pokemon.tipoS,
                            numero: pokemon.numero,
                            imagen: pokemon.imagen
                        ).scaleEffect(0.9)
                            
                    }
                }
            }
        }
    }
}


#Preview {
    listadoTarjetas()
}
