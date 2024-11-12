//
//  PokemonTarjeta.swift
//  pokedex
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct PokemonTarjeta: View {
    var body: some View {
        ZStack(){
            VStack(spacing: 0){
                ParteArriba().frame(height: 500)
                ParteAbajo()
                    .clipShape(
                        .rect(
                            topLeadingRadius: 20,
                            topTrailingRadius: 20
                        )
                    )
                    .offset(CGSize(width: 0, height: -160))
            }.frame(width: .infinity, height: .infinity, alignment: .top)
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png")){ image in
                image
                    .image?.resizable()
                    .scaledToFit()
            }
            .frame(width: 300, height: 300)
            .offset(CGSize(width: 0, height: -100))
        }
    }
}

#Preview {
    PokemonTarjeta()
}

struct ParteArriba: View {
    var body: some View {
        ZStack{
            Color.red
            VStack(){
                HStack(){
                    Text("#0006").padding(.leading)
                        .font(.custom("Press Start 2P Regular", size: 32))
                        .foregroundColor(.white)
                        .offset(CGSize(width: 0, height: 50))
                    Spacer()
                }
                HStack(){
                    Spacer()
                    ZStack{
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                            .frame(width: 190, height: 190)
                        Image("fire")
                            .resizable()
                            .frame(width: 170, height: 170)
                    }
                }.padding(.trailing)
                    .offset(CGSize(width: 0, height: -20))
                Spacer()
            }.frame(height: .infinity, alignment: .top)
        }
    }
}

struct ParteAbajo: View {
    var body: some View {
        ZStack{
            Color.white
            VStack(spacing: 0){
                Text("Charizard")
                    .font(.custom("Press Start 2P Regular", size: 32))
                HStack(){
                    Spacer()
                    VStack(){
                        ZStack(){
                            Circle()
                                .fill(Color.red)
                                .frame(width: 70, height: 70)
                            Image("fire")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        Text("Fuego")
                            .font(.custom("Press Start 2P Regular", size: 16))
                    }
                    Spacer()
                    VStack(){
                        ZStack(){
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 70, height: 70)
                            Image("flying")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        Text("Volador")
                            .font(.custom("Press Start 2P Regular", size: 16))
                    }
                    Spacer()
                }.offset(CGSize(width: 0, height: 80))
            }.frame(width: .infinity, alignment: .top)
        }
    }
}
