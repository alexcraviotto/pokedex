import SwiftUI

struct listadoTarjetas: View {
    var usuarioId = obtenerUserIdDesdeLocalStorage() // ID del usuario
    @State private var pokemons: [Pokemon] = []
    @State private var isLoading = false
    @State private var favoritePokemons: [Pokemon] = []
    @State private var navigateTo: String? = nil // Controlador de navegación
    
    let columnas = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var count = 0
    @State var countex = 0
    var items = 20

    // Fuente personalizada
    let font = Font.custom("Inter", size: 18)

    var body: some View {
        NavigationStack { // Uso de NavigationStack para navegación sin botón de volver
            VStack {
                // Encabezado
                HStack {
                    Image("Pokedex").scaledToFit().frame(height: 50)
                    Spacer()
                    NavigationLink(destination: FavoritesView(
                        favoritePokemons: $favoritePokemons,
                        loadFavoritePokemons: loadFavoritePokemons
                    )) {
                        Image("pokeheart")
                            .padding()
                    }
                }
                .padding()
                
                // Vista principal
                ScrollView {
                    LazyVGrid(columns: columnas, spacing: 20) {
                        ForEach(pokemons.sorted(by: { $0.id < $1.id })) { pokemon in
                            NavigationLink(destination: VistaDetalle(id: pokemon.id)) {
                                PokemonTarjeta2(pokemon: pokemon)
                                    .scaleEffect(0.9)
                                    .onAppear {
                                        if pokemon.id == self.pokemons.count && !isLoading {
                                            carga()
                                        }
                                    }
                            }
                        }
                    }
                }
                .onAppear {
                    carga()
                }
                
                // Ocultar Footer solo en ciertas vistas
                if navigateTo == nil {
                    footer.navigationBarBackButtonHidden(true)
                }
            }
            .font(font)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: String.self) { view in
                // Navegación sin opción de regresar
                switch view {
                case "Favoritos":
                    FavoritesView(
                        favoritePokemons: $favoritePokemons,
                        loadFavoritePokemons: loadFavoritePokemons
                    )
                default:
                    if view.starts(with: "Detalle-") {
                        let id = Int(view.split(separator: "-")[1]) ?? 0
                        VistaDetalle(id: id)
                    }
                }
            }
        }
    }
    
    // Footer que se oculta en otras vistas
    var footer: some View {
        HStack {
            NavigationLink(destination: listadoTarjetas()) {
                VStack {
                    Image("inicio")
                    Text("Inicio")
                }
            }.navigationBarBackButtonHidden(true)
            Spacer()
            NavigationLink(destination: VistaBusqueda()) {
                VStack {
                    Image("busqueda")
                    Text("Búsqueda")
                }.navigationBarBackButtonHidden(true)
            }.navigationBarBackButtonHidden(true)
            Spacer()
            NavigationLink(destination: VistaCombate()) {
                VStack {
                    Image("pelea")
                    Text("Combate")
                }.navigationBarBackButtonHidden(true)
            }.navigationBarBackButtonHidden(true)
            Spacer()
            NavigationLink(destination: VistaAjustes(userId: usuarioId, viewModel: ViewModel())) {
                VStack {
                    Image("ajustes")
                    Text("Ajustes")
                }.navigationBarBackButtonHidden(true)
            }.navigationBarBackButtonHidden(true)
        }.navigationBarBackButtonHidden(true)
        .frame(height: 60)
        .background(Color.gray.opacity(0.1))
        .padding(.horizontal)
    }

    func loadFavoritePokemons() {
        var viewModel = ViewModel()
        let favoritos = viewModel.obtenerFavoritePokemonsPorUsuario(userId: usuarioId)
        favoritePokemons.removeAll()
        for favorito in favoritos {
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
