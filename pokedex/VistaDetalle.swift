import SwiftUI

struct VistaDetalle: View {
    var id: Int
    @State private var pokemon: Pokemon2?
    @State private var evolutions: [(Pokemon2, String, Pokemon2)] = []
    @State private var movimientos: [(String, String, Int, Int)] = []
    @State private var moveNames: [String] = []
    @State private var offset = 0
    @State private var isLoading = false
    @State private var selectedTab: Tab = .about
    @State private var apiCalls = ApiCalls()
    @State private var isFavorite: Bool = false
    @State private var isShiny: Bool = false // Nueva variable de estado para alternar imagen
    
    
    enum Tab: String, CaseIterable {
        case about = "About"
        case movimientos = "Movimientos"
        case evoluciones = "Evoluciones"
    }
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(colorPicker(tipo: pokemon?.types.first ?? ""))
                        .frame(height: 350)
                        .offset(y: -100)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 10) {
                        if let pokemon = pokemon {
                            ZStack {
                                // Imagen del Pokémon (normal o shiny)
                                (isShiny ? pokemon.image_shiny : pokemon.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 350, height: 350)
                                    .offset(y: -20)
                                
                                // Botón para alternar entre las imágenes
                                Button(action: {
                                    isShiny.toggle()
                                }) {
                                    Text("Shiny version")
                                        .font(.custom("Press Start 2P Regular", size: 10))
                                        .padding(10)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                                .frame(width: 150) // El botón es más grande para garantizar el área tocable
                                .offset(x: 110, y: -165) // Desplaza el botón hacia la izquierda (x: -50)
                            }

                            
                            
                            HStack(spacing: 2) {
                                Text("\(pokemon.name.capitalized) #\(String(format: "%04d", pokemon.id))")
                                    .font(.custom("Press Start 2P Regular", size: 18))
                                    .fontWeight(.bold)
                                
                                Image(isFavorite ? "pokeheart_filled" : "pokeheart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .offset(y: 2)
                                    .zIndex(1)
                                    .onTapGesture {
                                        let userId: UUID = obtenerUserIdDesdeLocalStorage()
                                        var vm = ViewModel()
                                        
                                        if isFavorite {
                                            vm.eliminarFavoritePokemon(userId: userId, pokemonId: Int64(pokemon.id))
                                            print("Eliminado de favoritos")
                                            isFavorite = false
                                        } else {
                                            vm.agregarFavoritePokemon(userId: userId, pokemonId: Int64(pokemon.id))
                                            print("Agregado a favoritos")
                                            isFavorite = true
                                        }
                                    }
                            }
                            
                            HStack(spacing: 10) {
                                ForEach(pokemon.types, id: \.self) { type in
                                    Text(type.capitalized)
                                        .font(.caption)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 6)
                                        .background(colorPicker(tipo: type))
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                            }
                        } else {
                            Text("Cargando...").font(.title).foregroundColor(.gray)
                        }
                    }
                }
                
                // Descripción y pestañas
                Text(pokemon?.description ?? "Sin descripción disponible.")
                    .font(.body)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                HStack {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        TabButton(title: tab.rawValue.capitalized, isSelected: selectedTab == tab) {
                            selectedTab = tab
                        }
                    }
                }
                .padding(.vertical, 10)
                
                // Contenido dinámico
                Group {
                    if selectedTab == .about { aboutContent }
                    else if selectedTab == .movimientos { movimientosContent }
                    else { evolucionesContent }
                }
            }
        }
        .onAppear {
            Task {
                await cargarPokemon()
                checkIfFavorite()
            }
        }
    }
    
    func checkIfFavorite() {
        let userId = obtenerUserIdDesdeLocalStorage()
        let vm = ViewModel()
        isFavorite = vm.esPokemonFavorito(userId: userId, pokemonId: Int64(id))
    }
    
    private var aboutContent: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("About")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 5)
            
            // Sección de Altura, Peso y HP
            HStack(spacing: 0) {
                InfoRow(title: "Altura", value: "\(String(format: "%.1f", (pokemon?.height ?? 0) / 10))m")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Divider()
                    .frame(width: 1, height: 60)
                    .background(Color.gray.opacity(0.4))
                
                InfoRow(title: "Peso", value: "\(String(format: "%.1f", (pokemon?.weight ?? 0) / 10))kg")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Divider()
                    .frame(width: 1, height: 60)
                    .background(Color.gray.opacity(0.4))
                
                InfoRow(title: "HP", value: "\(pokemon?.stats["hp"] ?? 0)")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .frame(maxWidth: .infinity)
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
            
            // Sección de Debilidades
            VStack(alignment: .leading, spacing: 10) {
                Text("Debilidad")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                    ForEach(pokemon?.weakTypes ?? [], id: \.self) { debilidad in
                        Text(debilidad.capitalized)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(colorPicker(tipo: debilidad))
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                    }
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    // Contenido "Movimientos"
    private var movimientosContent: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Movimientos")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(movimientos.indices, id: \.self) { index in
                        let move = movimientos[index]
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(index + 1). \(move.0)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("Descripción: \(move.1.isEmpty ? "Sin descripción disponible" : move.1)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                            
                            HStack(spacing: 20) {
                                Label {
                                    Text("\(move.2)")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                } icon: {
                                    Image(systemName: "scope")
                                        .foregroundColor(.blue)
                                }
                                
                                Label {
                                    Text("\(move.3)")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.red)
                                } icon: {
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.top, 5)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .onAppear {
                            if index >= movimientos.count - 2 && !isLoading {
                                Task { await fetchMoreMoves() }
                            }
                        }
                    }
                    
                    if isLoading {
                        ProgressView()
                            .padding()
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .onAppear {
            Task {
                if moveNames.isEmpty {
                    moveNames = await apiCalls.loadMoves(pokemon_id: id)
                }
                
                if movimientos.isEmpty {
                    await fetchMoreMoves()
                }
            }
        }
    }
    
    private func fetchMoreMoves() async {
        guard !isLoading else { return }
        isLoading = true
        let newMoves = await apiCalls.listMoves(move_names: moveNames, offset: movimientos.count, limit: 10)
        await MainActor.run {
            movimientos.append(contentsOf: newMoves.map { ($0.name, $0.description, $0.accuracy, $0.power) })
            isLoading = false
        }
    }
    
    // Contenido "Evoluciones"
    private var evolucionesContent: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Evoluciones").font(.title2).fontWeight(.bold)
            if evolutions.isEmpty {
                Text("No tiene evoluciones").font(.body).foregroundColor(.gray)
                    .onAppear {
                        Task {
                            evolutions = await apiCalls.obtenerEvoluciones(evolutionChainId: pokemon?.evolution_chain_id ?? 1)
                        }
                    }
            } else {
                ForEach(evolutions, id: \.0.id) { evolution in
                    HStack(spacing: 10) {
                        evolutionView(evolution.0)
                        VStack {
                            Text(evolution.1).font(.caption).foregroundColor(.gray)
                        }
                        .frame(width: 100)
                        evolutionView(evolution.2)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .padding()
    }
    
    private func evolutionView(_ pokemon: Pokemon2) -> some View {
        VStack {
            pokemon.image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text(pokemon.name.capitalized)
                .font(.caption).fontWeight(.semibold)
        }
    }
    
    private func cargarPokemon() async {
        pokemon = await apiCalls.pokemonPorId(id: id)
    }
}

// Componentes reutilizables
struct TabButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .black : .gray)
                .padding(.vertical, 6).padding(.horizontal, 12)
                .background(isSelected ? Color.gray.opacity(0.2) : Color.clear)
                .cornerRadius(10)
        }
    }
}

struct InfoRow: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundColor(.gray)
            Text(value).fontWeight(.bold)
        }
    }
}

#Preview {
    VistaDetalle(id: 147)
}
