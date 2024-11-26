import SwiftUI

struct VistaDetalle: View {
    var pokemon: Pokemon
    
    // Estado para cambiar de pestaña
    @State private var selectedTab: Tab = .about
    
    enum Tab {
        case about, movimientos, evoluciones
    }
    
    var body: some View {
        ScrollView {
                   VStack(spacing: 20) {
                       // Fondo superior con imagen y tipo
                       ZStack(alignment: .top) {
                           RoundedRectangle(cornerRadius: 25)
                               .fill(Color.red)
                               .frame(height: 300)
                           
                           VStack() {
                               // Imagen del Pokémon superpuesta
                               AsyncImage(url: URL(string: pokemon.sprites.other.officialArtwork.frontDefault)) { phase in
                                   switch phase {
                                   case .empty:
                                       ProgressView()
                                           .frame(width: 250, height: 250)
                                   case .success(let image):
                                       image
                                           .resizable()
                                           .frame(width: 350, height: 350)
                                           .shadow(radius: 10)
                                           .offset(y: 50) // Superposición sobre la franja roja
                                   case .failure:
                                       Image(systemName: "xmark.circle")
                                           .resizable()
                                           .scaledToFit()
                                           .frame(width: 250, height: 250)
                                           .foregroundColor(.gray)
                                           .offset(y: -50)
                                   @unknown default:
                                       EmptyView()
                                   }
                               }
                               .zIndex(1)
                               
                               VStack() {
                                   // Nombre y número del Pokémon
                                   Text("\(pokemon.name.capitalized) #\(String(format: "%04d", pokemon.id))")
                                       .font(.title)
                                       .fontWeight(.bold)
                                       .foregroundColor(.black)
                                   // Tipos del Pokémon
                                   HStack() {
                                       ForEach(pokemon.types, id: \.type.name) { tipo in
                                           Text(tipo.type.name.capitalized)
                                               .padding(.horizontal, 12)
                                               .padding(.vertical, 6)
                                               .background(tipoColor(tipo.type.name))
                                               .foregroundColor(.white)
                                               .clipShape(Capsule())
                                       }
                                   }
                               }
                               .zIndex(0)
                           }
                       }
                       
                       // Descripción
                       Text("Cuando se enfurece de verdad, la llama de la punta de su cola se vuelve de color azul claro.")
                           .font(.body)
                           .padding(.horizontal)
                           .multilineTextAlignment(.center)
                
                // Menú interactivo
                HStack {
                    TabButton(title: "About", isSelected: selectedTab == .about) {
                        selectedTab = .about
                    }
                    TabButton(title: "Movimientos", isSelected: selectedTab == .movimientos) {
                        selectedTab = .movimientos
                    }
                    TabButton(title: "Evoluciones", isSelected: selectedTab == .evoluciones) {
                        selectedTab = .evoluciones
                    }
                }
                .padding(.vertical, 10)
                
                // Contenido dinámico según la pestaña seleccionada
                if selectedTab == .about {
                    aboutContent
                } else if selectedTab == .movimientos {
                    movimientosContent
                } else if selectedTab == .evoluciones {
                    evolucionesContent
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    // Función para asignar color según el tipo
    func tipoColor(_ tipo: String) -> Color {
        switch tipo.lowercased() {
        case "fuego": return .red
        case "agua": return .blue
        case "eléctrico": return .yellow
        case "roca": return .brown
        case "dragón": return .purple
        default: return .gray
        }
    }
    
    // Vista del contenido para "About"
    var aboutContent: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("About")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                InfoRow(title: "Altura", value: "1.7m") // Mock
                Spacer()
                InfoRow(title: "Peso", value: "90.5kg") // Mock
                Spacer()
                InfoRow(title: "Habilidad", value: "Mar Llamas") // Mock
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Debilidad")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 10) {
                    ForEach(["Agua", "Eléctrico", "Roca"], id: \.self) { debilidad in
                        Text(debilidad)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(tipoColor(debilidad))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
    }
    
    // Mock de contenido para "Movimientos"
    var movimientosContent: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Movimientos")
                .font(.title2)
                .fontWeight(.bold)
            Text("Aquí irán los movimientos del Pokémon.") // Mock temporal
        }
        .padding()
    }
    
    // Mock de contenido para "Evoluciones"
    var evolucionesContent: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Evoluciones")
                .font(.title2)
                .fontWeight(.bold)
            Text("Aquí irán las evoluciones del Pokémon.") // Mock temporal
        }
        .padding()
    }
}

// Vista para un botón de pestaña
struct TabButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .black : .gray)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(isSelected ? Color.gray.opacity(0.2) : Color.clear)
                .cornerRadius(10)
        }
    }
}

// Vista para filas de información
struct InfoRow: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .fontWeight(.bold)
        }
    }
}


struct NavegacionVistaDetalle: View {
    var pokemon: Pokemon
    
    var body: some View {
        NavigationView {
            VistaDetalle(pokemon: pokemon)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
        }
    }
}

// Mock para vista previa
struct VistaDetalle_Previews: PreviewProvider {
    static var previews: some View {
        let mockPokemon = Pokemon(
            id: 6,
            name: "charizard",
            types: [
                Pokemon.Types(type: Pokemon.PokemonType(name: "fuego")),
                Pokemon.Types(type: Pokemon.PokemonType(name: "dragón"))
            ],
            sprites: Pokemon.Sprites(
                other: Pokemon.OtherSprites(
                    officialArtwork: Pokemon.OfficialArtwork(
                        frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png"
                    )
                )
            )
        )
        
        NavegacionVistaDetalle(pokemon: mockPokemon)
    }
}
