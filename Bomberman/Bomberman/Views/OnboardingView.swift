//
//  OnboardingView.swift
//  Bomberman
//
//  Created by Sergey on 12.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isPresented: Bool
    private let audioService = DIContainer.shared.audioService
    
    private let onboardingPages = [
        OnboardingPage(
            imageName: "Rules1",
            title: "Передвижение",
            description: "Для передвижения персонажа используйте стрелки: влево, вправо, вверх, вниз"
        ),
        OnboardingPage(
            imageName: "Rules2",
            title: "Постановка бомбы",
            description: "Для того, чтобы поставить бомбу нажмите на центральную кнопку бомбы между стрелками передвижения"
        ),
        OnboardingPage(
            imageName: "Rules3",
            title: "Подсветка траектории",
            description: "Если вы включили в лобби режим подсвечивания бомб, то все клетки, которые поражает бомба, горят красным цветом"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.bombermanBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Индикатор страниц
                HStack(spacing: 8) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 40)
                .padding(.bottom, 20)
                
                // Карточка с контентом
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 500)
                
                // Кнопки навигации
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button {
                            audioService.playButtonSound()
                            withAnimation {
                                currentPage -= 1
                            }
                        } label: {
                            Text("Назад")
                                .font(.kenneyFuture(size: 20))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.5))
                                )
                        }
                    } else {
                        Spacer()
                            .frame(width: 100)
                    }
                    
                    Spacer()
                    
                    if currentPage < onboardingPages.count - 1 {
                        Button {
                            audioService.playButtonSound()
                            withAnimation {
                                currentPage += 1
                            }
                        } label: {
                            Text("Далее")
                                .font(.kenneyFuture(size: 20))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.bombermanGreen)
                                )
                        }
                    } else {
                        Button {
                            audioService.playButtonSound()
                            OnboardingService.shared.markOnboardingAsSeen()
                            isPresented = false
                        } label: {
                            Text("Начать игру")
                                .font(.kenneyFuture(size: 20))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.bombermanRed)
                                )
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage {
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            Text(page.title)
                .font(.kenneyFuture(size: 28))
                .foregroundColor(.white)
                .padding(.top, 20)
            
            Image(page.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(16)
                .shadow(radius: 8)
                .padding(.horizontal, 20)
            
            Text(page.description)
                .font(.kenneyFuture(size: 18))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
        )
        .padding(.horizontal, 30)
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}
