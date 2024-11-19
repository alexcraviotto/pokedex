//
//  VistaBusqueda.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 16/11/24.
//

import SwiftUI

struct VistaBusqueda: View {
    let pokemons = [
        Pokemon(nombre: "Charizard", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
        Pokemon(nombre: "Bulbasaur", tipo: "fire", tipoS: "flying", numero: "0006", imagen: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"),
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
    
    var filtrado: [Pokemon] {
           if query.count >= 3 {
               return pokemons.filter { pokemon in
                   pokemon.nombre.lowercased().contains(query.lowercased())
               }
           } else {
               return []
           }
       }
    
    @State var query: String = ""
    var body: some View {
        VStack {
            HStack{
                Image("logoBusqueda").scaledToFit().frame(height: 50)
                Spacer()
            }.padding()
                BusquedaView(text:$query)
            ScrollView {
                if !filtrado.isEmpty {
                    LazyVGrid(columns: columnas, spacing: 20) {
                        ForEach(filtrado) { pokemon in
                            PokemonTarjeta2(
                                nombre: pokemon.nombre,
                                tipo: pokemon.tipo,
                                tipoS: pokemon.tipoS,
                                numero: pokemon.numero,
                                imagen: pokemon.imagen
                            )
                            .scaleEffect(0.9)
                        }
                    }
                } else if query.count >= 3 {
                    Text("No se encontraron resultados").padding()
                }
            }
                }
                
            }
        }


struct BusquedaView: View {
    @Binding var text: String
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(text.isEmpty
                ? Color(UIColor.gray).opacity(0.6)
                : Color(UIColor.gray).opacity(0.9))
            TextField("Buscar…", text:$text)
            Button(){
                text = ""
            }label:{
                Image(systemName: "x.circle")
            }.opacity(text.isEmpty ? 0.0 : 1.0)
        }
        .frame(width: 320, height: 30).shadow(radius: 9)
        .background(
            RoundedRectangle(cornerRadius: 9)
            .fill(Color.gray.opacity(0.1))
        )
    }
}

#Preview {


    VistaBusqueda()
}
