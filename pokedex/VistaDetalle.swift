import SwiftUI

struct VistaDetalle: View {
    var id: Int
    @State var pokemon: Pokemon2?
    
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
                        .fill(colorPicker(tipo: pokemon?.types[0] ?? ""))
                        .frame(height: 300)
                    
                    VStack {
                        // Nombre y número del Pokémon
                        if let pokemon = pokemon {
                            Text("\(pokemon.name.capitalized) #\(String(format: "%04d", pokemon.id))")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        } else {
                            Text("Cargando...")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }
                    }
                    .zIndex(0)
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
        .onAppear {
            Task {
                await cargarPokemon()
            }
        }
    }
    
    // Método para cargar datos asíncronamente
    func cargarPokemon() async {
        self.pokemon = await pokemonPorId(id: id)
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
            /*ForEach(pokemon.moves, id: \.move.name) { move in
                HStack {
                    Text(move.move.name.capitalized)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(move.type.capitalized)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(move.power ?? 0)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(move.accuracy ?? 100)%")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 5)
                .background(Color.gray.opacity(0.1)) // Fondo gris suave para cada fila
                .cornerRadius(5)
            }*/
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
