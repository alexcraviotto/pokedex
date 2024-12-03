//
//  VistaBusqueda.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 16/11/24.
//

import SwiftUI

struct VistaBusqueda: View {
    
    @State var pokemons: [PokemonPair] = []
    
    let columnas = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var query: String = ""
    //@State var aux:[Pokemon] = []
    
    @State var filtrado: [Pokemon] = []
    /*{
        var names:[String] = []
        names = filterPokemonByName(pokemonArray: pokemons, searchTerm: query)
        if(names.count == aux.count){
            return aux
        }
        print(aux.count)
        print("names \(names.count)")
        if query.count >= 3 {
            for nombre in names {
                fetchPokemonData(pokemonId: nombre) { result in
                    switch result {
                    case .success(let newpokemon):
                        aux.append(newpokemon)
                        //print("tamanno \(aux.count)")
                    case .failure(let error):
                        print("Error: \(error)")

                    }
                }
            }
            //print("tamanno al final  \(aux.count)")
            return aux
        }
        return []
    }*/

    var body: some View {
        VStack {
            HStack{
                Text("Búsqueda")
                    .font(.custom("Press Start 2P Regular", size: 24))
                    .foregroundColor(.black)
                Spacer()
            }.padding()
            BusquedaView(text:$query)
                .onChange(of: query) { oldValue, newValue in
                    print(pokemons)
                    filtrado = []
                    if query.count >= 3 {
                        for nombre in filterPokemonByName(pokemonArray: pokemons, searchTerm: query) {
                            print(nombre)
                            fetchPokemonData(pokemonId: nombre) { result in
                                switch result {
                                case .success(let newpokemon):
                                    filtrado.append(newpokemon)
                                    //print("tamanno \(aux.count)")
                                case .failure(let error):
                                    print("Error: \(error)")

                                }
                            }
                        }
                    }
                }
            ScrollView {
                if !filtrado.isEmpty {
                    LazyVGrid(columns: columnas, spacing: 20) {
                        ForEach(filtrado) { pokemon in
                            PokemonTarjeta2(
                                pokemon: pokemon
                            )
                            .scaleEffect(0.9)
                        }
                    }
                } else if query.count >= 3 {
                    Text("No se encontraron resultados").padding()
                }
            }
        }.onAppear(){
            fetchPokemonNames { result in
                switch result {
                case .success(let pokemons):
                    self.pokemons.append(contentsOf: pokemons)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            
        }
            
    }
    
    func filterPokemonByName(pokemonArray: [PokemonPair], searchTerm: String) -> [String] {
        let filtros = pokemonArray.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
        return filtros.map { PokemonPair in
            PokemonPair.name
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
