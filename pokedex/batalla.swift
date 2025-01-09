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
    @State private var team2: [Pokemon2] = []  // Equipo 2 que puede ser personalizado

    @State private var log: [String] = []
    @State private var currentTurn: Int = 1
    @State private var hpTeam1: Int = 0
    @State private var hpTeam2: Int = 0
    @State private var attacker: Int = 0
    @State private var damageTeam1: Int = 0
    @State private var damageTeam2: Int = 0
    @State private var movesTeam1: [[(String, Int, Int)]] = []
    @State private var movesTeam2: [[(String, Int, Int)]] = []
    @State private var fin: Bool = false

    init(pokemonsUsuario: [Pokemon2?], campoBatalla: String) {
        self.pokemonsUsuario = pokemonsUsuario
        self.campoBatalla = campoBatalla
        print("Datos pokemon")
        for pokemon in pokemonsUsuario {
            if let pokemon = pokemon {
                print("Pokemon: \(pokemon.name)")
            }
        }
    }

    func calcularVida(team: [Pokemon2]) -> Int {
        return team.reduce(0) { $0 + ($1.stats["hp"] ?? 0) }
    }

    func calcularPrimerAtacante() {
        let velocidadTeam1 = team1.reduce(0) { $0 + ($1.stats["speed"] ?? 0) }
        let velocidadTeam2 = team2.reduce(0) { $0 + ($1.stats["speed"] ?? 0) }

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
            var moveLogs: [String] = []
            for index in team1.indices {
                if let move = movesTeam1[index].randomElement() {
                    let moveName = move.0
                    let damage = move.1
                    let accuracy = move.2
                    let hitChance = Int.random(in: 1...100)
                    if hitChance <= accuracy {
                        hpTeam2 -= damage
                        if hpTeam2 < 0 { hpTeam2 = 0 }
                        moveLogs.append("\(team1[index].name) usa \(moveName) e inflige \(damage) de daño con accuracy \(accuracy)")
                    } else {
                        moveLogs.append("El movimiento de \(team1[index].name) ha fallado con accuracy \(accuracy)")
                    }
                }
            }
            log.append("Equipo 1: \n" + moveLogs.joined(separator: "\n"))
            if hpTeam2 == 0 {
                log.append("¡Equipo 1 gana el combate!")
                fin = true
                return
            }
            attacker = 2
        } else {
            var moveLogs: [String] = []
            for index in team2.indices {
                if let move = movesTeam2[index].randomElement() {
                    let moveName = move.0
                    let damage = move.1
                    let accuracy = move.2
                    let hitChance = Int.random(in: 1...100)
                    if hitChance <= accuracy {
                        hpTeam1 -= damage
                        if hpTeam1 < 0 { hpTeam1 = 0 }
                        moveLogs.append("\(team2[index].name) usa \(moveName) e inflige \(damage) de daño con accuracy \(accuracy)")
                    } else {
                        moveLogs.append("El movimiento de \(team2[index].name) ha fallado con accuracy \(accuracy)")
                    }
                }
            }
            log.append("Equipo 2: \n" + moveLogs.joined(separator: "\n"))
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
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                HStack(alignment: .top) {
                    VStack {
                        Text("Ramón")
                            .font(.headline)
                            .padding(.bottom, 5)
                        ProgressView(value: Float(hpTeam1), total: Float(calcularVida(team: team1)))
                            .frame(width: 180)
                            .padding(.bottom, 5)
                        Text("Vida: \(hpTeam1)/\(calcularVida(team: team1))")
                            .font(.subheadline)

                        ForEach(team1.indices, id: \ .self) { index in
                            VStack {
                                team1[index].image
                                    .resizable()
                                    .frame(width: 90, height: 90)
                                    .padding(.bottom, 5)
                                Text(team1[index].name)
                                    .font(.caption)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()

                    VStack {
                        Text("Paco")
                            .font(.headline)
                            .padding(.bottom, 5)
                        ProgressView(value: Float(hpTeam2), total: Float(calcularVida(team: team2)))
                            .frame(width: 180)
                            .padding(.bottom, 5)
                        Text("Vida: \(hpTeam2)/\(calcularVida(team: team2))")
                            .font(.subheadline)

                        ForEach(team2.indices, id: \ .self) { index in
                            VStack {
                                team2[index].image
                                    .resizable()
                                    .frame(width: 90, height: 90)
                                    .padding(.bottom, 5)
                                Text(team2[index].name)
                                    .font(.caption)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }

                Spacer()

                Button(action: {
                    if fin {
                        // Lógica para navegar a VistaCombate
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: VistaCombate())
                            window.makeKeyAndVisible()
                        }
                    } else {
                        realizarTurno()
                    }
                }) {
                    Text(!fin ? "Turno actual: \(currentTurn == 1 ? 0 : currentTurn - 1)" : "Fin del combate")
                        .font(.headline)
                        .padding(.bottom, 10)
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)

                if let lastAction = log.last {
                    Text(lastAction)
                        .font(.subheadline)
                        .padding(.bottom, 10)
                }

                Spacer()

            }
            .padding()
            .onAppear {
                team1 = pokemonsUsuario.compactMap { $0 }.prefix(3).map { $0 }
                team2 = pokemonsUsuario.compactMap { $0 }.suffix(3).map { $0 }

                hpTeam1 = calcularVida(team: team1)
                hpTeam2 = calcularVida(team: team2)
                calcularPrimerAtacante()

                if attacker == 1 {
                    log.append("Turno 0: Empieza el equipo 1, sus pokemons tienen mayor velocidad.")
                } else {
                    log.append("Turno 0: Empieza el equipo 2, sus pokemons tienen mayor velocidad.")
                }

                cargarMovimientos()
            }
        }
    }

}







//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Aula03 on 12/11/24.
//
