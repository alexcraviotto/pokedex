import SwiftUI

struct listadoTarjetas: View {
    var usuarioId = obtenerUserIdDesdeLocalStorage() // Obtenemos el ID de usuario desde el almacenamiento local
    @State private var pokemons: [Pokemon] = []
    @State private var isLoading = false
    @State private var favoritePokemons: [Pokemon] = []
    
    let columnas = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var count = 0
    @State var countex = 0
    var items = 20
    
    // Incluimos el tipo de letra
    let font = Font.custom("Inter", size: 18)

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image("Pokedex").scaledToFit().frame(height: 50)
                    Spacer()
                    NavigationLink(
                        destination: FavoritesView(favoritePokemons: $favoritePokemons, loadFavoritePokemons: loadFavoritePokemons) // Pasar la función
                    ) {
                        Image("pokeheart")
                            .padding()
                    }
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
                            .zIndex(0)
                            .buttonStyle(PlainButtonStyle()) // Previene el estilo predeterminado del NavigationLink
                        }
                    }
                }
                .onAppear {
                    carga() // Cargar Pokémon cuando la vista aparece
                }
            }
            .font(font) // Aplica la fuente a todo el VStack
        }
    }
    
    func loadFavoritePokemons() {
        
        var viewModel = ViewModel()
        let favoritos = viewModel.obtenerFavoritePokemonsPorUsuario(userId: usuarioId)
        favoritePokemons.removeAll()
        for favorito in favoritos {
            print(favorito)
            fetchPokemonData(pokemonId: String(favorito.pokemonId)) { result in
                switch result {
                case .success(let pokemon):
                    DispatchQueue.main.async {
                        if !favoritePokemons.contains(where: { $0.id == pokemon.id }) {
                            favoritePokemons.append(pokemon)
                        }
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
                case .failure:
                    break
                }
            }
        }
        pokemons = pokemons.sorted(by: { $0.id < $1.id })
        isLoading = false
    }
}

struct FavoritesView: View {
    @Binding var favoritePokemons: [Pokemon] // Usamos Binding para que se actualice cada vez que se recarguen los favoritos
    var loadFavoritePokemons: () -> Void // Pasamos la función como parámetro
    
    let font = Font.custom("Inter", size: 18)

    var body: some View {
        HStack {
            Text("Favoritos")
                .font(.custom("Press Start 2P Regular", size: 24))
                .foregroundColor(.black)
            Spacer()
        }.padding()
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
        .font(font)
        .onAppear {
            loadFavoritePokemons()
        }
    }
}

#Preview {
    listadoTarjetas()
}
