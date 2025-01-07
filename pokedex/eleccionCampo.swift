import SwiftUI

struct eleccionCampo: View {
    var pokemonsUsuario: [Pokemon2?]

    var body: some View {
        VStack {
            Text("Elección de\ncampo de batalla\n")
                .font(.custom("Press Start 2P Regular", size: 24))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            // Botón de Hierba Alta
            Button(action: {
                print("Hierba alta seleccionada")
                // Cambiar la vista raíz programáticamente
                if let window = UIApplication.shared.windows.first {
                    let rootView = Combate(
                        pokemonsUsuario: pokemonsUsuario, campoBatalla: CamposBatalla.hierbaAlta)
                    window.rootViewController = UIHostingController(rootView: rootView)
                    window.makeKeyAndVisible()
                }
            }) {
                Image("seleccionarHierbaAlta")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Text("Hierba alta")
                            .font(.custom("Press Start 2P Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(),
                        alignment: .center
                    )
            }
            .padding()

            // Botón de Desierto
            Button(action: {
                print("Desierto seleccionado")
                // Cambiar la vista raíz programáticamente
                if let window = UIApplication.shared.windows.first {
                    let rootView = Combate(
                        pokemonsUsuario: pokemonsUsuario, campoBatalla: CamposBatalla.desierto)
                    window.rootViewController = UIHostingController(rootView: rootView)
                    window.makeKeyAndVisible()
                }
            }) {
                Image("seleccionarDesierto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Text("Desierto")
                            .font(.custom("Press Start 2P Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(),
                        alignment: .center
                    )
            }
            .padding()

            // Botón de Alto Mando
            Button(action: {
                print("Alto mando seleccionado")
                // Cambiar la vista raíz programáticamente
                if let window = UIApplication.shared.windows.first {
                    let rootView = Combate(
                        pokemonsUsuario: pokemonsUsuario, campoBatalla: CamposBatalla.altoMando)
                    window.rootViewController = UIHostingController(rootView: rootView)
                    window.makeKeyAndVisible()
                }
            }) {
                Image("seleccionarAltoMando")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Text("Alto mando")
                            .font(.custom("Press Start 2P Regular", size: 16))
                            .foregroundColor(.black)
                            .padding(),
                        alignment: .center
                    )
            }
            .padding()
        }
    }
}
