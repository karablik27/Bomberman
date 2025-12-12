//
//  InformationView.swift
//  Bomberman
//
//  Created by Sergey on 12.12.2025.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.dismiss) var dismiss
    private let audioService = DIContainer.shared.audioService
    
    var body: some View {
        ZStack {
            Color.bombermanBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        audioService.playButtonSound()
                        dismiss()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.bombermanRed)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Text("Информация")
                    .font(.kenneyFuture(size: 32))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0, x: 2, y: 2)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Описание")
                                .font(.kenneyFuture(size: 24))
                                .foregroundColor(.white)
                            
                            Text("Bomberman — аркадная многопользовательская игра. Каждый игрок управляет персонажем, находящимся в лабиринте, который состоит из разрушаемых и неразрушаемых стен. Он может оставлять бомбу, взрывающуюся через некоторое фиксированное время и разрушающую стены рядом с ней. Основная цель игры — пройти лабиринт, устанавливая бомбы для разрушения стен и уничтожения врагов. Раунд завершается, когда на поле остается один выживший игрок или когда истекает отведенное на него время.")
                                .font(.kenneyFuture(size: 16))
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 30)
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                            .padding(.horizontal, 30)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Управление")
                                .font(.kenneyFuture(size: 24))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                            
                            // Правило 1 - Передвижение
                            VStack(spacing: 12) {
                                Image("Rules1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                
                                Text("Для передвижения персонажа используйте стрелки: влево, вправо, вверх, вниз")
                                    .font(.kenneyFuture(size: 16))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                            .padding(.horizontal, 30)
                            
                            // Правило 2 - Постановка бомбы
                            VStack(spacing: 12) {
                                Image("Rules2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                
                                Text("Для того, чтобы поставить бомбу нажмите на центральную кнопку бомбы между стрелками передвижения")
                                    .font(.kenneyFuture(size: 16))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                            .padding(.horizontal, 30)
                            
                            // Правило 3 - Подсветка траектории взрыва
                            VStack(spacing: 12) {
                                Image("Rules3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                
                                Text("Если вы включили в лобби режим подсвечивания бомб, то все клетки, которые поражает бомба, горят красным цветом")
                                    .font(.kenneyFuture(size: 16))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
        }
    }
}

#Preview {
    InformationView()
}
