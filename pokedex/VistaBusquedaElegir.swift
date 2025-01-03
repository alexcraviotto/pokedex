import SwiftUI

struct VistaBusquedaElegir: View {
    
    @State var pokemons: [PokemonPair] = []
    @State var query: String = ""
    @State var filtrado: [Pokemon] = []
    @State private var apiCalls = ApiCalls()
    @State private var pokemonSeleccionado: Pokemon2?
    @State private var navegacionActiva = false

    let columnas = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Búsqueda")
                        .font(.custom("Press Start 2P Regular", size: 24))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()

                BusquedaView(text: $query)
                    .onChange(of: query) { newValue in
                        buscar()
                    }
                
                ScrollView {
                    if !filtrado.isEmpty {
                        LazyVGrid(columns: columnas, spacing: 20) {
                            ForEach(filtrado.sorted(by: { $0.id < $1.id }), id: \.id) { pokemon in
                                Button(action: {
                                    Task {
                                        await seleccionarPokemon(id: pokemon.id)
                                    }
                                }) {
                                    PokemonTarjeta2(pokemon: pokemon)
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
        }
        .background(
            Group {
                if let pokemonSeleccionado = pokemonSeleccionado {
                    NavigationLink(
                        destination: eleccionPokemon(
                            contrincante: false,
                            pokemonActual: pokemonSeleccionado),
                        isActive: $navegacionActiva
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        )
        Text("Hola")
    }

    func filterPokemonByName(pokemonArray: [PokemonPair], searchTerm: String) -> [String] {
        let filtros = pokemonArray.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
        return filtros.map { $0.name }
    }

    func buscar() {
        filtrado = []
        if query.count >= 1 {
            for nombre in filterPokemonByName(pokemonArray: pokemons, searchTerm: query) {
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
    
    private func seleccionarPokemon(id: Int) async {
        await MainActor.run {
            pokemonSeleccionado = nil // Reinicia el valor para evitar mostrar datos incorrectos durante la carga
            navegacionActiva = false // Asegúrate de que no se active la navegación antes de tiempo
        }

        let fetchedPokemon = await apiCalls.pokemonPorId(id: id)
        await MainActor.run {
            pokemonSeleccionado = fetchedPokemon
            if pokemonSeleccionado != nil {
                navegacionActiva = true
            }
        }
    }
}


struct VistaBusquedaElegir_Preview: PreviewProvider {
    static var previews: some View {
        VistaBusquedaElegir()
    }
}
