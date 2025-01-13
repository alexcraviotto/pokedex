import SwiftUI

struct VistaHistorialBatalla: View {
    @StateObject private var viewModel = ViewModel()
    var userId: UUID

    // Para formatear las fechas
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    // Estructura para agrupar las batallas por resultado
    private var battlesByResult: [String: [BattleLogEntity]] {
        Dictionary(grouping: viewModel.obtenerBatallasPorUsuario(userId: userId)) {
            $0.result ?? ""
        }
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Estadísticas generales
                    battleStatisticsCard

                    // Lista de batallas
                    battlesList
                }
                .padding()
            }
            .navigationTitle("Historial de Combates")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.cargarDatos()
            }

            // Botón flotante en el centro
            floatingButton
        }
    }
    class PokemonViewModel: ObservableObject {
        @Published var pokemon: Pokemon2?
        private let apiCalls = ApiCalls()

        func fetchPokemon(by id: Int) async {
            do {
                let fetchedPokemon = await apiCalls.pokemonPorId(id: id)
                DispatchQueue.main.async {
                    self.pokemon = fetchedPokemon
                }
            } catch {
                print("Error al cargar el Pokémon con ID \(id): \(error)")
            }
        }
    }
    // Tarjeta de estadísticas
    private var battleStatisticsCard: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Estadísticas generales")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.bottom, 10)

            let totalBattles = viewModel.obtenerBatallasPorUsuario(userId: userId).count
            let victories = battlesByResult["Victoria"]?.count ?? 0
            let winRate = totalBattles > 0 ? Double(victories) / Double(totalBattles) * 100 : 0

            HStack(spacing: 30) {
                StatisticItem(title: "Total", value: "\(totalBattles)")
                StatisticItem(title: "Victorias", value: "\(victories)")
                StatisticItem(title: "Ratio", value: String(format: "%.1f%%", winRate))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }

    // Lista de batallas
    private var battlesList: some View {
        LazyVStack(spacing: 15) {
            ForEach(
                viewModel.obtenerBatallasPorUsuario(userId: userId).sorted(by: {
                    ($0.battleDate ?? Date()) > ($1.battleDate ?? Date())
                }), id: \.id
            ) { battle in
                BattleCard(battle: battle)
            }
        }
    }

    // Tarjeta individual de batalla
    private struct BattleCard: View {
        let battle: BattleLogEntity

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label(
                        battle.result ?? "Desconocido",
                        systemImage: battle.result == "Victoria"
                            ? "trophy.fill" : "xmark.circle.fill"
                    )
                    .foregroundColor(battle.result == "Victoria" ? .yellow : .red)
                    .font(.headline)

                    Spacer()

                    Text(
                        battle.battleDate ?? Date(),
                        formatter: {
                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "es_ES")
                            formatter.dateStyle = .medium
                            formatter.timeStyle = .short
                            return formatter
                        }()
                    )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Tu equipo:")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    HStack {
                        PokemonIdView(pokemonId: Int(battle.pokemonId1))
                        PokemonIdView(pokemonId: Int(battle.pokemonId2))
                        PokemonIdView(pokemonId: Int(battle.pokemonId3))
                    }

                    Text("Equipo rival:")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    HStack {
                        PokemonIdView(pokemonId: Int(battle.opponentPokemonId1))
                        PokemonIdView(pokemonId: Int(battle.opponentPokemonId2))
                        PokemonIdView(pokemonId: Int(battle.opponentPokemonId3))
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 3)
        }
    }

    // Vista para mostrar un Pokémon por ID
    private struct PokemonIdView: View {
        let pokemonId: Int
        @StateObject private var viewModel = PokemonViewModel()

        var body: some View {
            VStack {
                if let pokemon = viewModel.pokemon {
                    pokemon.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                } else {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchPokemon(by: pokemonId)
                }
            }
        }
    }

    // Componente para mostrar una estadística individual
    private struct StatisticItem: View {
        let title: String
        let value: String

        var body: some View {
            VStack(spacing: 5) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
    }

    // Botón flotante en el centro
    private var floatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if let window = UIApplication.shared.windows.first {
                        let rootView = vistaMenu()
                        window.rootViewController = UIHostingController(rootView: rootView)
                        window.makeKeyAndVisible()
                    }
                }) {
                    Text("Volver al Inicio")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
    }
}
