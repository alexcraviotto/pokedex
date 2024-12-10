//
//  VistaBusqueda.swift
//  pokedex
//
//  Created by Antonio Ordóñez on 16/11/24.
//

import SwiftUI

struct VistaBusqueda: View {
    
    @State var pokemons: [PokemonPair] = []
    @State private var showFilters = false
        @StateObject private var filterManager = FilterManager()
    
    let columnas = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var query: String = ""
    @State var filtrado: [Pokemon] = []

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Text("Búsqueda")
                            .font(.custom("Press Start 2P Regular", size: 24))
                            .foregroundColor(.black)
                        Spacer()
                    }.padding()
                    
                    Button{
                        
                    }label: {
                        Image("filtro")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                        Text("Tipo")
                    }
                    
                    BusquedaView(text: $query)
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
                                ForEach(filtrado, id: \.id) { pokemon in
                                    NavigationLink(
                                        destination: VistaDetalle(id: pokemon.id)
                                    ) {
                                        PokemonTarjeta2(
                                            pokemon: pokemon
                                        )
                                        .scaleEffect(0.9)
                                        .foregroundColor(.black)
                                        
                                    }
                                }
                            }
                        } else if query.count >= 3 {
                            Text("No se encontraron resultados").padding()
                        }
                    }
                }
                .onAppear {
                    fetchPokemonNames { result in
                        switch result {
                        case .success(let pokemons):
                            self.pokemons.append(contentsOf: pokemons)
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
                }
                if showFilters {
                    FilterView(isShowing: $showFilters, filterManager: filterManager)
                        .transition(.move(edge: .leading))
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
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(text.isEmpty
                    ? Color(UIColor.gray).opacity(0.6)
                    : Color(UIColor.gray).opacity(0.9))
            TextField("Buscar…", text: $text)
            Button {
                text = ""
            } label: {
                Image(systemName: "x.circle")
            }.opacity(text.isEmpty ? 0.0 : 1.0)
        }
        .frame(width: 320, height: 30)
        .shadow(radius: 9)
        .background(
            RoundedRectangle(cornerRadius: 9)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct FilterView: View {
    @Binding var isShowing: Bool
    @ObservedObject var filterManager: FilterManager
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Text("Filtros")
                        .font(.title)
                        .padding()
                    
                    // ScrollView para los filtros
                    ScrollView {
                        VStack(spacing: 15) {
                            // Ejemplo con muchos filtros
                            Toggle("Filtro 1", isOn: $filterManager.filter1)
                            Toggle("Filtro 2", isOn: $filterManager.filter2)
                            Toggle("Filtro 3", isOn: $filterManager.filter3)
                            Toggle("Filtro 4", isOn: $filterManager.filter4)
                            Toggle("Filtro 5", isOn: $filterManager.filter5)
                            Toggle("Filtro 6", isOn: $filterManager.filter6)
                            Toggle("Filtro 7", isOn: $filterManager.filter7)
                            Toggle("Filtro 8", isOn: $filterManager.filter8)
                            Toggle("Filtro 9", isOn: $filterManager.filter9)
                            Toggle("Filtro 10", isOn: $filterManager.filter10)
                            
                            // Puedes añadir más filtros según necesites
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    // Botones de acción
                    HStack {
                        Button("Resetear") {
                            filterManager.resetFilters()
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                        
                        Button("Cerrar") {
                            withAnimation {
                                isShowing = false
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
                .frame(width: geometry.size.width * 0.7)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
                
                // Área para descartar el menú
                Color.black.opacity(0.3)
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
            }
            .offset(x: isShowing ? 0 : -geometry.size.width)
        }
    }
}

class FilterManager: ObservableObject {
    @Published var filter1 = false
    @Published var filter2 = false
    @Published var filter3 = false
    @Published var filter4 = false
    @Published var filter5 = false
    @Published var filter6 = false
    @Published var filter7 = false
    @Published var filter8 = false
    @Published var filter9 = false
    @Published var filter10 = false
    
    func resetFilters() {
        filter1 = false
        filter2 = false
        filter3 = false
        filter4 = false
        filter5 = false
        filter6 = false
        filter7 = false
        filter8 = false
        filter9 = false
        filter10 = false
    }
}

#Preview(){
    VistaBusqueda()
}
