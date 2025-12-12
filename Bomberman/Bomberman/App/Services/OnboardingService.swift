//
//  OnboardingService.swift
//  Bomberman
//
//  Created by Sergey on 12.12.2025.
//

import Foundation

class OnboardingService {
    static let shared = OnboardingService()
    
    private let hasSeenOnboardingKey = "hasSeenOnboarding"
    
    private init() {}
    
    var hasSeenOnboarding: Bool {
        get {
            UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hasSeenOnboardingKey)
        }
    }
    
    func markOnboardingAsSeen() {
        hasSeenOnboarding = true
    }
    
    func resetOnboarding() {
        hasSeenOnboarding = false
    }
}
