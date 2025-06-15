//
//  PlanPreviewData.swift
//  Coashak
//
//  Created by Mohamed Magdy on 13/06/2025.
//


// MARK: - Preview Helpers

import Foundation

struct PlanPreviewData {
    static let sample = PlanForResponse(
        id: "1",
        trainer: "123",
        title: "Elite Monthly Plan",
        description: "Includes weekly personal training sessions, a nutrition guide, and progress tracking.",
        price: 49,
        durationInWeeks: 4,
        hasTrainingPlan: true,
        hasNutritionPlan: true,
        createdAt: Date(),
        updatedAt: Date(),
        v: 0
    )
}

struct ClientPreviewData {
    static let full = ClientSub(
        id: "1",
        fullName: "Jane Doe",
        profilePhoto: "https://randomuser.me/api/portraits/women/44.jpg"
    )
}

struct PlanSubPreviewData {
    static let short = PlanSub(
        id: "1",
        title: "Elite Monthly Plan"
    )
}

struct TrainerPreviewData {
    static let sample = TrainerSub(
        id: "trainer123",
        fullName: "John Coach"
    )
}

struct SubscriptionPreviewData {
    static let one = Subscription(
        id: "sub1",
        status: "active",
        trainingPlan: ["Workout 1", "Workout 2"],
        nutritionPlan: ["Meal Plan 1"],
        startedAt: "2025-06-01T00:00:00Z",
        expiresAt: "2025-07-01T00:00:00Z",
        createdAt: "2025-06-01T00:00:00Z",
        updatedAt: "2025-06-01T00:00:00Z",
        active: true,
        daysUntilExpire: 19,
        client: ClientPreviewData.full,
        trainer: TrainerPreviewData.sample,
        plan: PlanSubPreviewData.short
    )
}
