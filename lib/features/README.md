# Features Directory

This directory contains all feature modules following Domain-Driven Design (DDD) principles and Clean Architecture.

## Feature Structure

Each feature follows this structure:

```
feature_name/
├── domain/
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   ├── use_cases/          # Business logic use cases
│   └── value_objects/      # Value objects
├── data/
│   ├── models/             # Data models (DTOs)
│   ├── repositories/       # Repository implementations
│   └── data_sources/       # Remote and local data sources
└── presentation/
    ├── screens/            # Screen widgets
    ├── widgets/            # Feature-specific widgets
    └── state/              # State management (Riverpod providers)
```

## Creating a New Feature

1. Create the feature directory structure
2. Start with domain layer (entities, repositories, use cases)
3. Implement data layer (models, data sources, repository implementations)
4. Build presentation layer (screens, widgets, state management)

## Layer Dependencies

- **Presentation** depends on **Domain** (use cases)
- **Data** depends on **Domain** (implements repository interfaces)
- **Domain** has NO dependencies on other layers
- All layers can use **Core** and **Shared**

## Example Features

Features to be implemented:
- Authentication (login, registration)
- Revenue Tracking (employee revenue entries)
- Dashboard (admin overview)
- User Management (user profiles, roles)

## Naming Conventions

- Feature names: `snake_case`
- Entities: `PascalCase` (e.g., `User`, `RevenueEntry`)
- Use cases: `PascalCase` with descriptive names (e.g., `GetUserProfile`, `CreateRevenueEntry`)
- Repositories: `PascalCase` with `Repository` suffix (e.g., `UserRepository`)
- Models: `PascalCase` with `Model` suffix (e.g., `UserModel`)
