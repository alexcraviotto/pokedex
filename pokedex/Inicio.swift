import SwiftUI

struct Inicio: View {
    @StateObject private var musicPlayer = MusicPlayer()
    let musicURL = URL(string: "https://kappa.vgmsite.com/soundtracks/pokemon-firered-leafgreen-music-super-complete/nixinsogwg/1-03.%20Title%20Screen.mp3")!
    var body: some View {
        NavigationView {
            NavigationLink(destination: navegarIniciarSession()) {
                ZStack {
                    GifImage("inicio")
                        .frame(height: 1000)
                        .ignoresSafeArea()
                    VStack {
                        Image("pokemon")
                            .resizable()
                            .frame(width: 400, height: 170)
                            .padding(.top, 150)
                        Spacer()
                        Text("Pulsa para continuar")
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 180)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onDisappear{
                musicPlayer.detenerMusica()
            }
        }
        .navigationBarHidden(true)
        .onAppear{
            musicPlayer.reproducirMusica(url: musicURL)
        }
       
    }
}

struct navegarIniciarSession: View {
    @State private var nombreUsuario = ""
    @State private var contrasena = ""

    var body: some View {
        let viewModel = ViewModel()

        IniciarSesion(email: $nombreUsuario, password: $contrasena, viewModel: viewModel)
    }
}

#Preview {
    Inicio()
}
