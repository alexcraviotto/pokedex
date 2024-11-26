import SwiftUI

struct listadoTarjetas: View {
    @State private var pokemons: [Pokemon] = []
    @State private var isLoading = false
    let columnas = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var count = 0
    var items = 20
    
    var body: some View {
        NavigationView { // Aseguramos que el NavigationView está presente
            VStack {
                HStack {
                    Image("Pokedex").scaledToFit().frame(height: 50)
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: columnas, spacing: 20) {
                        ForEach(pokemons.sorted(by: { $0.id < $1.id })) { pokemon in
                            NavigationLink(
                                destination: NavegacionVistaDetalle(pokemon: pokemon) // Pasamos el objeto pokemon directamente
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
                    carga()
                }
            }
        }
    }
    
    func carga() {
        guard !isLoading else { return }
        isLoading = true
        
        let start = count * items
        let end = start + items
        for i in start..<end {
            fetchPokemonData(pokemonId: i) { result in
                switch result {
                case .success(let pokemon):
                    DispatchQueue.main.async {
                        pokemons.append(pokemon)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        
        count += 1
        isLoading = false
    }
}

#Preview {
    listadoTarjetas()
}
