//
//  listadoTarjetas.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 16/11/24.
//

import SwiftUI

struct listadoTarjetas: View {
    @State private var pokemons: [Pokemon] = []
    let columnas = [
          GridItem(.flexible()),
          GridItem(.flexible())
      ]
    @State var count = 0
    var items = 20
    @State var isloading = false
    var body: some View {
        VStack {
            HStack{
                Image("Pokedex").scaledToFit().frame(height: 50)
                Spacer()
            }.padding()
            ScrollView {
                LazyVGrid(columns: columnas, spacing: 20) {
                    ForEach(pokemons.sorted(by: { $0.id < $1.id })){ pokemon in
                        PokemonTarjeta2(
                            pokemon: pokemon
                        ).scaleEffect(0.9)
                            .onAppear(){
                                if pokemon.id == self.pokemons.count{
                                    carga()
                                }
                            }
                    }
                }
            }.onAppear(){
                carga()
            }
        }
    }
    
    func carga() -> Void {
        var start = count * items
        let end = start + items
        start += 1
        for i in start...end{
            //print(i)
            fetchPokemonData(pokemonId: i) { result in
                switch result {
                case .success(let pokemon):
                    pokemons.append(pokemon)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        count += 1
    }
    
}


#Preview {
    listadoTarjetas()
}


