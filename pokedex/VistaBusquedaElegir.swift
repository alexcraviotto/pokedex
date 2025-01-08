import SwiftUI

struct VistaBusquedaElegir: View {
    @Environment(\.presentationMode) var presentationMode  // Para cerrar la vista
    @State private var pokemons: [PokemonPair] = []
    @State private var query: String = ""
    @State private var log: String = "" // Nueva variable de estado para reflejar el contenido actual de la barra de búsqueda
    @State private var filtrado: [Pokemon] = []
    @State private var apiCalls = ApiCalls()
    @State private var pokemonSeleccionado: Pokemon2?
    var onPokemonSelected: (Pokemon2) -> Void  // Callback para devolver el Pokémon seleccionado

    let columnas = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack {
            // Título de la vista
            HStack {
                Text("Búsqueda")
                    .font(.custom("Press Start 2P Regular", size: 24))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding()

            // Barra de búsqueda
            BusquedaView(text: $query)
                .onChange(of: query) { newValue in
                    log = newValue // Sincronizamos `log` con el contenido actual de la barra de búsqueda
                    buscar()       // Ejecutamos el método `buscar`
                }

            // Lista de Pokémon filtrados con un límite de altura
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
                            .buttonStyle(PlainButtonStyle())  // Evita estilos no deseados
                        }
                    }
                    .padding(.bottom, 20) // Espacio adicional para evitar solapamiento
                } else if query.count >= 3 {
                    Text("No se encontraron resultados").padding()
                }
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.8) // Limita la altura de la lista

            Spacer() // Añade espacio en la parte inferior
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

    // Filtra los Pokémon por nombre
    func filterPokemonByName(pokemonArray: [PokemonPair], searchTerm: String) -> [String] {
        pokemonArray
            .filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
            .map { $0.name }
    }

    // Realiza la búsqueda
    func buscar() {
        let currentLog = log // Capturamos el valor actual de `log` al inicio

        filtrado = [] // Reiniciamos el filtro antes de realizar la búsqueda

        // Si la barra de búsqueda está vacía, no hacemos nada
        if currentLog.isEmpty {
            return
        }

        // Obtener nombres coincidentes
        let nombres = filterPokemonByName(pokemonArray: pokemons, searchTerm: currentLog)

        // Si no hay nombres coincidentes, salimos
        if nombres.isEmpty {
            return
        }

        // Preparar para realizar las consultas
        var pokemonTemp: [Pokemon] = []
        let group = DispatchGroup()

        for nombre in nombres {
            group.enter() // Indicamos que una consulta comienza
            fetchPokemonData(pokemonId: nombre) { result in
                defer { group.leave() } // Marcamos el final de la consulta
                if currentLog != log {
                    return // Salimos si `log` ha cambiado
                }
                switch result {
                case .success(let newpokemon):
                    pokemonTemp.append(newpokemon)
                case .failure(let error):
                    print("Error al buscar \(nombre): \(error)")
                }
            }
        }

        // Procesar los resultados una vez que todas las consultas hayan finalizado
        group.notify(queue: .main) {
            if currentLog != log {
                return // Salimos si `log` ha cambiado
            }
            self.filtrado = pokemonTemp
        }
    }

    // Selecciona un Pokémon y llama al callback
    private func seleccionarPokemon(id: Int) async {
        await MainActor.run {
            pokemonSeleccionado = nil  // Reinicia el valor para evitar mostrar datos incorrectos
        }

        let fetchedPokemon = await apiCalls.pokemonPorId(id: id)
        await MainActor.run {
            pokemonSeleccionado = fetchedPokemon
            onPokemonSelected(fetchedPokemon)  // Devuelve el Pokémon seleccionado
            presentationMode.wrappedValue.dismiss()  // Cierra la vista
        }
    }
}
