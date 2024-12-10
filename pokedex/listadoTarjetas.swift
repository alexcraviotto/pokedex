import SwiftUI

struct listadoTarjetas: View {
    var usuarioId = obtenerUserIdDesdeLocalStorage() // Obtenemos el ID de usuario desde el almacenamiento local
    @State private var pokemons: [Pokemon] = []
    @State private var isLoading = false
    @State private var showingFavoritesView = false
    @State private var favoritePokemons: [Pokemon] = []
    
    let columnas = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var count = 0
    @State var countex = 0
    var items = 20
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image("Pokedex").scaledToFit().frame(height: 50)
                    Spacer()
                    Image("pokeheart")
                        .onTapGesture {
                            toggleFavorites() // Llamar a toggleFavorites al hacer clic en el ícono
                        }
                        .padding()
                }
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: columnas, spacing: 20) {
                        ForEach(pokemons.sorted(by: { $0.id < $1.id })) { pokemon in
                            NavigationLink(
                                destination: VistaDetalle(id: pokemon.id)
                            ) {
                                PokemonTarjeta2(pokemon: pokemon)
                                    .scaleEffect(0.9)
                                    .onAppear {
                                        if pokemon.id == self.pokemons.count && !isLoading {
                                            carga() // Cargar más Pokémon si hemos llegado al final
                                        }
                                    }
                            }
                            .buttonStyle(PlainButtonStyle()) // Previene el estilo predeterminado del NavigationLink
                        }
                    }
                }
                .onAppear {
                    carga() // Cargar Pokémon cuando la vista aparece
                }
            }
        }
        .sheet(isPresented: $showingFavoritesView) {
            // Mostrar la vista de favoritos
            FavoritesView(favoritePokemons: favoritePokemons)
        }
    }
    
    func toggleFavorites() {
        // Alternamos la vista de favoritos
        showingFavoritesView.toggle()
        
        // Obtener los Pokémon favoritos para el usuario desde el ViewModel
        var viewModel = ViewModel()
        let favoritos = viewModel.obtenerFavoritePokemonsPorUsuario(userId: usuarioId)
        
        // Cargar los detalles de los Pokémon favoritos por pokemonId
        loadFavoritePokemons(favoritos)
    }
    func loadFavoritePokemons(_ favoritos: [FavoritePokemonEntity]) {
        // Recorremos los favoritos y cargamos los detalles de cada Pokémon
        for favorito in favoritos {
            fetchPokemonData(pokemonId: String(favorito.pokemonId)) { result in
                switch result {
                case .success(let pokemon):
                    DispatchQueue.main.async {
                        favoritePokemons.append(pokemon) // Añadimos el Pokémon a la lista de favoritos
                    }
                case .failure(let error):
                    print("Error al cargar el Pokémon \(favorito.pokemonId): \(error)")
                }
            }
        }
    }

    func carga() {
        isLoading = true
        var start = 0
        if pokemons.count >= 1025 {
            start = 10000 + countex * items
            countex += 1
        } else {
            start = count * items
            count += 1
        }
        start += 1
        let end = start + items
        for i in start..<end {
            fetchPokemonData(pokemonId: i) { result in
                switch result {
                case .success(let pokemon):
                    DispatchQueue.main.async {
                        pokemons.append(pokemon)
                    }
                case .failure(let error):
                    break
                }
            }
        }
        pokemons = pokemons.sorted(by: { $0.id < $1.id })
        isLoading = false
    }
}

struct FavoritesView: View {
    var favoritePokemons: [Pokemon]
    
    var body: some View {
        VStack {
            if favoritePokemons.isEmpty {
                Text("Aún no tienes Pokémon favoritos.")
                    .font(.title2)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        ForEach(favoritePokemons) { pokemon in
                            PokemonTarjeta2(pokemon: pokemon)
                                .scaleEffect(0.9)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    listadoTarjetas()
}
