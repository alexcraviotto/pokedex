import SwiftUI
import UIKit

struct VistaDetalle: View {
    var id: Int
    @State var pokemon: Pokemon2?
    @State private var evolutions: [(Pokemon2, String, Pokemon2)] = []
    
    // Estado para cambiar de pestaña
    @State private var selectedTab: Tab = .about
    
    // Estado para los movimientos y la paginación
    @State private var movimientos: [(String, String, Int, Int)] = [] // Almacenar movimientos
    @State private var moveNames: [String] = [] // Lista de nombres de movimientos
    @State private var isLoading = false // Controlar si está cargando más movimientos
    @State var apiCalls = ApiCalls()
    
    enum Tab {
        case about, movimientos, evoluciones
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Fondo superior con imagen y tipo
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(colorPicker(tipo: pokemon?.types.first ?? "")) // Reemplazamos tipoColor con colorPicker
                        .frame(height: 350) // Aumenté la altura
                        .offset(y: -100) // Mantuve el offset superior
                        .ignoresSafeArea()
                    
                    VStack(spacing: 10) { // Compacto
                        if let pokemon = pokemon {
                            pokemon.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350) // Tamaño ajustado
                                .zIndex(0)
                                .offset(y:-30)
                            
                            // Nombre del Pokémon
                            Text("\(pokemon.name.capitalized) #\(String(format: "%04d", pokemon.id))")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.top, -60)
                            
                            // Tipos del Pokémon
                            HStack(spacing: 10) {
                                ForEach(pokemon.types, id: \.self) { type in
                                    Text(type.capitalized)
                                        .font(.caption)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 6)
                                        .background(colorPicker(tipo: type)) // Reemplazamos tipoColor con colorPicker
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                            }
                        } else {
                            Text("Cargando...")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }
                    }
                    .zIndex(2)
                }
                
                // Descripción
                Text(pokemon?.description ?? "Sin descripción disponible.")
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
                self.pokemon = await apiCalls.pokemonPorId(id: id)
            }
        }
    }
    
    // Vista del contenido para "About"
        var aboutContent: some View {
            VStack(alignment: .leading, spacing: 15) {
                Text("About")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    // Se utiliza un VStack para que cada InfoRow ocupe una porción del espacio
                    VStack {
                        InfoRow(
                            title: "Altura",
                            value: "\(String(format: "%.1f", (pokemon?.height ?? 0) / 10))m" // Ajuste de altura
                        )
                    }
                    .frame(maxWidth: .infinity) // Centrado del campo
                    VStack {
                        InfoRow(
                            title: "Peso",
                            value: "\(String(format: "%.1f", (pokemon?.weight ?? 0) / 10))kg" // Ajuste de peso
                        )
                    }
                    .frame(maxWidth: .infinity) // Centrado del campo
                    
                    VStack {
                        // Obtener los HP de pokemon.stats
                        if let hp = pokemon?.stats["hp"] {
                            InfoRow(
                                title: "Health Points",
                                value: "\(hp)" // Muestra los puntos de vida (HP)
                            )
                        } else {
                            InfoRow(
                                title: "Health Points",
                                value: "N/A" // Si no hay HP, muestra N/A
                            )
                        }
                    }
                    .frame(maxWidth: .infinity) // Centrado del campo
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Debilidad")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Usar un LazyVGrid para que las debilidades se distribuyan en varias líneas
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(pokemon?.weakTypes ?? [], id: \.self) { debilidad in
                            Text(debilidad)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(colorPicker(tipo: debilidad)) // Usamos colorPicker en lugar de tipoColor
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .padding()
        }
    // Vista del contenido para "Movimientos"
    var movimientosContent: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Movimientos")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView {
                LazyVStack(spacing: 15) { // Separación consistente entre elementos
                    ForEach(movimientos.indices, id: \.self) { index in
                        let move = movimientos[index]
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(index + 1). \(move.0)") // Nombre del movimiento
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            // Descripción sin indentación
                            Text("Descripción: \(move.1.isEmpty ? "Sin descripción disponible" : move.1)") // Descripción del movimiento
                            
                            HStack() {
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
                        .frame(maxWidth: .infinity) // Se asegura de que el contenedor ocupe todo el ancho
                        .background(Color(UIColor.systemGray6)) // Fondo sutil para destacar
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .onAppear {
                            // Cargar más movimientos si se acerca al final
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
                .padding(.horizontal) // Espaciado general
            }
        }
        .padding()
        .onAppear {
            Task {
                // Si los nombres de los movimientos no están cargados, los obtenemos
                if moveNames.isEmpty {
                    moveNames = await apiCalls.loadMoves(pokemon_id: id)
                }
                await fetchMoreMoves()
            }
        }
    }


    // Método para cargar más movimientos
    private func fetchMoreMoves() async {
        guard !isLoading else { return }
        isLoading = true
        
        let newMoves = await apiCalls.listMoves(
            move_names: moveNames,
            offset: movimientos.count, // Cargar a partir de donde terminamos
            limit: 10
        )
        
        await MainActor.run {
            movimientos.append(contentsOf: newMoves.map { move in
                (move.name, move.description, move.accuracy, move.power)
            })
            isLoading = false
        }
    }
        
    


    
    var evolucionesContent: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Evoluciones")
                .font(.title2)
                .fontWeight(.bold)
            
            if evolutions.isEmpty {
                // Mostrar un mensaje de carga mientras las evoluciones no están disponibles
                Text("No tiene evoluciones")
                    .font(.body)
                    .foregroundColor(.gray)
                    .onAppear {
                        Task {
                            evolutions = await apiCalls.obtenerEvoluciones(evolutionChainId: pokemon?.evolution_chain_id ?? 1)
                        }
                    }
            } else {
                // Mostrar las evoluciones
                ForEach(Array(evolutions.enumerated()), id: \.offset) { index, evolution in
                    VStack {
                        HStack(spacing: 10) {
                            // Pokémon inicial
                            VStack {
                                evolution.0.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                Text(evolution.0.name.capitalized)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            
                            // Método de evolución
                            VStack {
                                Text(evolution.1)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 5)
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 100) // Ancho fijo para consistencia
                            
                            // Pokémon evolucionado
                            VStack {
                                evolution.2.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                Text(evolution.2.name.capitalized)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
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
#Preview {
    VistaDetalle(id: 6)

}
