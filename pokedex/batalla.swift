import SwiftUI

struct CamposBatalla {
    static let hierbaAlta: String = "fondoCombateHierba"
    static let desierto: String = "fondoCombateDesierto"
    static let altoMando: String = "fondoCombateAltoMando"
}

struct Combate: View {
    var pokemonsUsuario: [Pokemon2?]  // Lista de Pokémon personalizados por el usuario
    var campoBatalla: String  // Fondo del combate personalizado
    @State private var team1: [Pokemon2] = []  // Equipo 1 que puede ser personalizado
    @State private var team2: [Pokemon2] = [
        // Equipo 2 por defecto
        Pokemon2(
            id: 4, name: "Squirtle", description: "Water turtle", types: ["Water"],
            weakTypes: ["Electric", "Grass"], weight: 9.0, height: 0.5,
            stats: ["HP": 44, "Speed": 43], image: Image("squirtle"),
            image_shiny: Image("squirtle_shiny"), evolution_chain_id: 4),
        Pokemon2(
            id: 5, name: "Jigglypuff", description: "Fairy/Normal", types: ["Fairy", "Normal"],
            weakTypes: ["Steel", "Poison"], weight: 5.5, height: 0.5,
            stats: ["HP": 115, "Speed": 20], image: Image("jigglypuff"),
            image_shiny: Image("jigglypuff_shiny"), evolution_chain_id: 5),
        Pokemon2(
            id: 6, name: "Meowth", description: "Cat Pokémon", types: ["Normal"],
            weakTypes: ["Fighting"], weight: 4.2, height: 0.4, stats: ["HP": 40, "Speed": 90],
            image: Image("meowth"), image_shiny: Image("meowth_shiny"), evolution_chain_id: 6),
    ]

    @State private var log: [String] = []
    @State private var currentTurn: Int = 1
    @State private var hpTeam1: Int = 0
    @State private var hpTeam2: Int = 0
    @State private var attacker: Int = 0
    @State private var damageTeam1: Int = 0
    @State private var damageTeam2: Int = 0
    @State private var movesTeam1: [[(String, Int)]] = []
    @State private var movesTeam2: [[(String, Int)]] = []
    @State private var fin: Bool = false

    init(pokemonsUsuario: [Pokemon2?], campoBatalla: String) {
        self.pokemonsUsuario = pokemonsUsuario
        self.campoBatalla = campoBatalla
        print("Datos pokemon")
        //for each nombre pokjemonusuario
        for pokemon in pokemonsUsuario {
            if let pokemon = pokemon {
                print("Pokemon: \(pokemon.name)")
            }
        }
    }

    func calcularVida(team: [Pokemon2]) -> Int {
        var totalHP = 0
        for pokemon in team {
            totalHP += pokemon.stats["HP"] ?? 0
        }
        return totalHP
    }

    func calcularPrimerAtacante() {
        let velocidadTeam1 = team1.reduce(0) { $0 + ($1.stats["Speed"] ?? 0) }
        let velocidadTeam2 = team2.reduce(0) { $0 + ($1.stats["Speed"] ?? 0) }

        if velocidadTeam1 > velocidadTeam2 {
            attacker = 1  // Equipo 1 ataca primero
        } else {
            attacker = 2  // Equipo 2 ataca primero
        }
    }

    func cargarMovimientos() {
        movesTeam1 = Array(repeating: [], count: team1.count)
        movesTeam2 = Array(repeating: [], count: team2.count)

        for index in team1.indices {
            getMovesWithPP(id: team1[index].id) { result in
                switch result {
                case .success(let moves):
                    DispatchQueue.main.async {
                        movesTeam1[index] = moves
                        log.append(
                            "\(team1[index].name) movimientos: \(moves.map { $0.0 }.joined(separator: ", "))"
                        )
                    }
                case .failure(let error):
                    print("Error cargando movimientos para \(team1[index].name):", error)
                }
            }
        }

        for index in team2.indices {
            getMovesWithPP(id: team2[index].id) { result in
                switch result {
                case .success(let moves):
                    DispatchQueue.main.async {
                        movesTeam2[index] = moves
                        log.append(
                            "\(team2[index].name) movimientos: \(moves.map { $0.0 }.joined(separator: ", "))"
                        )
                    }
                case .failure(let error):
                    print("Error cargando movimientos para \(team2[index].name):", error)
                }
            }
        }
    }

    func turnDamage() {
        damageTeam1 = team1.indices.reduce(0) { total, index in
            guard index < movesTeam1.count, !movesTeam1[index].isEmpty else { return total }
            let randomMove = movesTeam1[index].randomElement()?.1 ?? 0
            return total + randomMove
        }

        damageTeam2 = team2.indices.reduce(0) { total, index in
            guard index < movesTeam2.count, !movesTeam2[index].isEmpty else { return total }
            let randomMove = movesTeam2[index].randomElement()?.1 ?? 0
            return total + randomMove
        }
    }

    func realizarTurno() {
        guard !fin else { return }

        turnDamage()

        if attacker == 1 {
            hpTeam2 -= damageTeam1
            if hpTeam2 < 0 { hpTeam2 = 0 }
            log.append("Equipo 1 ataca e inflige \(damageTeam1) de daño")
            if hpTeam2 == 0 {
                log.append("¡Equipo 1 gana el combate!")
                fin = true
                return
            }
            attacker = 2
        } else {
            hpTeam1 -= damageTeam2
            if hpTeam1 < 0 { hpTeam1 = 0 }
            log.append("Equipo 2 ataca e inflige \(damageTeam2) de daño")
            if hpTeam1 == 0 {
                log.append("¡Equipo 2 gana el combate!")
                fin = true
                return
            }
            attacker = 1
        }
        currentTurn += 1
    }

    var body: some View {
        ZStack {
            Image(campoBatalla)  // Fondo de batalla dinámico
                .scaledToFit()
                .ignoresSafeArea()
            VStack {
                Text("\n\n\nHP del Equipo 1: \(hpTeam1)")
                Text("HP del Equipo 2: \(hpTeam2)")
                Spacer()
                /* List(log, id: \.self) { entry in
                        Text(entry)
                    } */
                if !fin {
                    Button("Siguiente Turno") {
                        realizarTurno()
                    }
                } else {
                    Text("Combate finalizado")
                }
                Spacer()
            }
            .padding()
            .onAppear {
                team1 = pokemonsUsuario.compactMap { $0 }.filter { !$0.name.isEmpty }

                print("TEAM 1")
                for pokemon in team1 {
                    print("Pokemon: \(pokemon.name)")
                }
                hpTeam1 = calcularVida(team: team1)
                hpTeam2 = calcularVida(team: team2)
                calcularPrimerAtacante()
                cargarMovimientos()
            }
        }
    }
}
