import SwiftUI
import AVFoundation
struct CamposBatalla {
    static let hierbaAlta: String = "fondoCombateHierba"
    static let desierto: String = "fondoCombateDesierto"
    static let altoMando: String = "fondoCombateAltoMando"
}
struct Combate: View {
    var pokemonsUsuario: [Pokemon2?]  // Lista de Pokémon personalizados por el usuario
    var campoBatalla: String  // Fondo del combate personalizado
    var posicion: String
    @State var audioPlay: AVPlayer?
    @State private var apiCalls = ApiCalls()
    
    @StateObject private var gifLoader = GIFLoader()
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
        switch campoBatalla {
        case CamposBatalla.hierbaAlta:
            self.posicion = "hierba"
        case CamposBatalla.desierto:
            self.posicion = "arena"
        case CamposBatalla.altoMando:
            self.posicion = "morado"
        default:
            self.posicion = "hierba"  // Valor por defecto si no hay coincidencias
        }
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
    private func guardarResultadoBatalla(resultado: String) {
        // Obtener IDs de los pokémon del equipo 1
        let pokemonIds = team1.map { Int64($0.id) }
        
        // Obtener IDs de los pokémon del equipo 2
        let opponentPokemonIds = team2.map { Int64($0.id) }
        
        let viewModel = ViewModel()
        let userId: UUID = obtenerUserIdDesdeLocalStorage()
        
        viewModel.agregarBattleLog(
            userId: userId,
            pokemonIds: pokemonIds,
            opponentPokemonIds: opponentPokemonIds,
            result: resultado
        )
        print("Resultado de la batalla guardado")
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
                        moveLogs.append(
                            "\(team1[index].name) usa \(moveName) e inflige \(damage) de daño con accuracy \(accuracy)"
                        )
                        
                    } else {
                        moveLogs.append(
                            "El movimiento de \(team1[index].name) ha fallado con accuracy \(accuracy)"
                        )
                    }
                }
            }
            // log.append("Equipo 1: \n" + moveLogs.joined(separator: "\n"))
            log.append("Turno \(currentTurn): Equipo 1 inflige un total de \(damageTeam1) de daño.")
            if hpTeam2 == 0 {
                log.append("¡Equipo 1 gana el combate!")
                fin = true
                guardarResultadoBatalla(resultado: "Victoria")
                
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
                        
                        moveLogs.append(
                            "\(team2[index].name) usa \(moveName) e inflige \(damage) de daño con accuracy \(accuracy)"
                        )
                    } else {
                        moveLogs.append(
                            "El movimiento de \(team2[index].name) ha fallado con accuracy \(accuracy)"
                        )
                    }
                }
            }
            //log.append("Equipo 2: \n" + moveLogs.joined(separator: "\n"))
            log.append("Turno \(currentTurn): Equipo 2 inflige un total de \(damageTeam2) de daño.")
            if hpTeam1 == 0 {
                log.append("¡Equipo 2 gana el combate!")
                guardarResultadoBatalla(resultado: "Derrota")
                
                fin = true
                return
            }
            attacker = 1
        }
        currentTurn += 1
    }
    /*
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
     Text(currentTurn == 1 ? "Pulsa aquí" : (!fin ? "Turno actual: \(currentTurn-1)" : "Fin del combate"))
     .font(.headline)
     .padding(.vertical, 10)
     .padding(.horizontal, 40)
     }
     .background(Color.blue)
     .foregroundColor(.white)
     .cornerRadius(10)
     .shadow(radius: 5)
     Spacer()
     ZStack {
     Image("cuadroTextoCombate")
     .resizable()
     .frame(height: 250)
     .clipped()
     .padding(.horizontal)
     
     if let lastAction = log.last {
     Text(lastAction)
     .font(.subheadline)
     .foregroundColor(.white)
     .multilineTextAlignment(.center)
     .padding(.horizontal, 25)
     .padding(.vertical, 20)
     }
     }
     Spacer()
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
     }*/
    var body: some View {
        ZStack {
            // Fondo de batalla
            Image(campoBatalla)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                ZStack {
                    Image("cuadroVida")
                        .resizable()
                        .scaledToFit()
                    
                    VStack {
                        // Nombre del entrenador o Pokémon
                        HStack {
                            Text("Ramón")
                                .font(.custom("Press Start 2P Regular", size: 20))
                                .foregroundColor(.black)
                                .offset(x: -50, y: -20)
                            
                            Text("HP:\(hpTeam1)/\(calcularVida(team: team1))")
                                .font(.custom("Press Start 2P Regular", size: 10)).foregroundColor(
                                    .black
                                )
                                .offset(x: -50, y: -20)
                        }
                        ZStack(alignment: .leading) {
                            // Fondo de la barra
                            RoundedRectangle(cornerRadius: 6)
                                .frame(width: 172, height: 19)  // Ancho y alto de la barra
                                .foregroundColor(.gray.opacity(0.3))  // Color de fondo de la barra
                            
                            // Progreso actual
                            RoundedRectangle(cornerRadius: 6)
                                .frame(
                                    width: CGFloat(hpTeam1) / CGFloat(calcularVida(team: team1))
                                    * 172, height: 19
                                )  // Calcula la proporción
                                .foregroundColor(.green)  // Color del progreso
                        }
                        .offset(x: 41, y: -6)
                        
                    }
                }
                ZStack {
                    Image(posicion)
                        .resizable()
                        .scaledToFit()
                        .offset(y: 20)
                    HStack(spacing: 20) {
                        ForEach(team1.indices, id: \.self) { index in
                            let pokemonID = team1[index].id
                            
                            if let gifURL = gifLoader.gifURLs[pokemonID], let url = URL(string: gifURL) {
                                GIFView(gifURL: url)
                                    .frame(width: 100, height: 100)
                                    .shadow(radius: 10)
                            } else {
                                ZStack {
                                    ProgressView() // Ruleta de carga
                                        .frame(width: 100, height: 100)
                                    /*team1[index].image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .shadow(radius: 5)*/
                                }
                                .task {
                                    // Llama al método con el tipo 1 para cargar el GIF delantero
                                    await gifLoader.loadGIF(for: pokemonID, type: 1)
                                }
                            }
                        }
                    }
                }
                .environmentObject(gifLoader)
                
                
                
                
                
                Spacer()
                ZStack {
                    Image(posicion)
                        .resizable()
                        .scaledToFit()
                        .offset(y: 20)
                    HStack(spacing: 20) {
                        ForEach(team2.indices, id: \.self) { index in
                            let pokemonID = team2[index].id
                            
                            if let gifURL = gifLoader.gifURLs[pokemonID], let url = URL(string: gifURL) {
                                GIFView(gifURL: url)
                                    .frame(width: 100, height: 100)
                                    .shadow(radius: 10)
                            } else {
                                ZStack {
                                    ProgressView() // Ruleta de carga
                                        .frame(width: 100, height: 100)
                                    /*team2[index].image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .shadow(radius: 5)*/
                                }
                                .task {
                                    // Llama al método con el tipo 0 para cargar el GIF trasero
                                    await gifLoader.loadGIF(for: pokemonID, type: 0)
                                }
                            }
                        }
                    }
                }
                .environmentObject(gifLoader)
                
                Spacer()
                ZStack {
                    Image("cuadroVida")
                        .resizable()
                        .scaledToFit()
                    
                    VStack {
                        // Nombre del entrenador o Pokémon
                        HStack {
                            Text("Paco")
                                .font(.custom("Press Start 2P Regular", size: 20)).foregroundColor(
                                    .black
                                )
                                .offset(x: -50, y: -20)
                            
                            Text("HP:\(hpTeam2)/\(calcularVida(team: team2))")
                                .font(.custom("Press Start 2P Regular", size: 10)).foregroundColor(
                                    .black
                                )
                                .offset(x: -50, y: -20)
                        }
                        ZStack(alignment: .leading) {
                            // Fondo de la barra
                            RoundedRectangle(cornerRadius: 6)
                                .frame(width: 172, height: 19)  // Ancho y alto de la barra
                                .foregroundColor(.gray.opacity(0.3))  // Color de fondo de la barra
                            
                            // Progreso actual
                            RoundedRectangle(cornerRadius: 6)
                                .frame(
                                    width: CGFloat(hpTeam2) / CGFloat(calcularVida(team: team2))
                                    * 172, height: 19
                                )  // Calcula la proporción
                                .foregroundColor(.green)  // Color del progreso
                        }
                        .offset(x: 41, y: -6)
                        
                    }
                }
                Spacer()
                // Cuadro de acción
                ZStack {
                    Image("cuadroTextoCombate")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                    
                    Text(log.last ?? "¡Es tu turno!")
                        .font(.custom("Press Start 2P Regular", size: 10))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(10)
                }
                
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
                
                let battleMusicURL = URL(string: "https://eta.vgmtreasurechest.com/soundtracks/pokemon-game-boy-pok-mon-sound-complete-set-play-cd/wpfiaxpxan/1-07.%20Battle%20%28Vs.%20Wild%20Pok%C3%A9mon%29.mp3")!
                    reproducirMusica(url: battleMusicURL)
            }
        }
        .onTapGesture {
            if fin {
                let userId = obtenerUserIdDesdeLocalStorage()
                if let window = UIApplication.shared.windows.first {
                    let rootView = VistaHistorialBatalla(
                        userId: userId)
                    window.rootViewController = UIHostingController(rootView: rootView)
                    window.makeKeyAndVisible()
                }
            } else {
                realizarTurno()
            }
        }
    }
    
    func reproducirMusica(url: URL) {
        audioPlay = AVPlayer(url: url)
        audioPlay?.play()
        print("Reproduciendo música desde: \(url)")
    }
    
}

#Preview {
    Combate(
        pokemonsUsuario: [
            // Equipo modificado
            Pokemon2(
                id: 952, name: "Zekrom", description: "Dragon/Electric Pokémon",
                types: ["Dragon", "Electric"],
                weakTypes: ["Ice", "Fairy", "Dragon", "Ground"], weight: 345.0, height: 2.9,
                stats: ["hp": 100, "speed": 90], image: Image("Zekrom"),
                image_shiny: Image("Zekrom"), evolution_chain_id: 1),
            Pokemon2(
                id: 2, name: "Reshiram", description: "Dragon/Fire Pokémon",
                types: ["Dragon", "Fire"],
                weakTypes: ["Rock", "Ground", "Dragon"], weight: 330.0, height: 3.2,
                stats: ["hp": 100, "speed": 90], image: Image("Reshiram"),
                image_shiny: Image("Reshiram"), evolution_chain_id: 2),
            Pokemon2(
                id: 3, name: "Mewtwo", description: "Psychic Pokémon", types: ["Psychic"],
                weakTypes: ["Bug", "Ghost", "Dark"], weight: 122.0, height: 2.0,
                stats: ["hp": 106, "speed": 130], image: Image("Mewtwo"),
                image_shiny: Image("Mewtwo"), evolution_chain_id: 3),
            Pokemon2(
                id: 1, name: "Zekrom", description: "Dragon/Electric Pokémon",
                types: ["Dragon", "Electric"],
                weakTypes: ["Ice", "Fairy", "Dragon", "Ground"], weight: 345.0, height: 2.9,
                stats: ["hp": 100, "speed": 90], image: Image("Zekrom"),
                image_shiny: Image("Zekrom"), evolution_chain_id: 1),
            Pokemon2(
                id: 2, name: "Reshiram", description: "Dragon/Fire Pokémon",
                types: ["Dragon", "Fire"],
                weakTypes: ["Rock", "Ground", "Dragon"], weight: 330.0, height: 3.2,
                stats: ["hp": 100, "speed": 90], image: Image("Reshiram"),
                image_shiny: Image("Reshiram"), evolution_chain_id: 2),
            Pokemon2(
                id: 3, name: "Mewtwo", description: "Psychic Pokémon", types: ["Psychic"],
                weakTypes: ["Bug", "Ghost", "Dark"], weight: 122.0, height: 2.0,
                stats: ["hp": 106, "speed": 130], image: Image("Mewtwo"),
                image_shiny: Image("Mewtwo"), evolution_chain_id: 3),
        ], campoBatalla: "fondoCombateHierba")
}
