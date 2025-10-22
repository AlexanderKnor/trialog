# Trialog Architecture Documentation

## Overview

Trialog is built using Clean Architecture principles combined with Domain-Driven Design (DDD). The application follows a modular, feature-based structure that ensures scalability, maintainability, and testability.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, Widgets, State Management)        │
├─────────────────────────────────────────┤
│         Application Layer               │
│  (Use Cases, Business Logic)            │
├─────────────────────────────────────────┤
│           Domain Layer                  │
│  (Entities, Value Objects, Interfaces)  │
├─────────────────────────────────────────┤
│        Infrastructure Layer             │
│  (Data Sources, APIs, Storage)          │
└─────────────────────────────────────────┘
```

## Directory Structure

```
lib/
├── core/                       # Core functionality
│   ├── config/                 # App configuration
│   │   ├── app_config.dart     # Environment-specific config
│   │   └── theme_config.dart   # Theme configuration
│   ├── constants/              # Global constants
│   │   ├── app_constants.dart  # App-wide constants
│   │   └── design_constants.dart # Corporate design constants
│   ├── errors/                 # Error handling
│   │   ├── exceptions.dart     # Exception classes
│   │   └── failures.dart       # Failure classes for Result pattern
│   ├── utils/                  # Utility classes
│   │   ├── formatters.dart     # Data formatters
│   │   ├── logger.dart         # Logging utility
│   │   └── validators.dart     # Input validators
│   ├── providers/              # Global providers
│   │   └── app_providers.dart  # Core dependency injection
│   └── routes/                 # Routing configuration
│       └── app_router.dart     # GoRouter setup
│
├── shared/                     # Shared components
│   ├── components/             # Reusable UI components
│   │   ├── empty_state.dart    # Empty state widget
│   │   ├── error_view.dart     # Error display widget
│   │   └── loading_indicator.dart # Loading widget
│   ├── services/               # Shared services
│   │   ├── http_service.dart   # HTTP client wrapper
│   │   └── storage_service.dart # Local storage wrapper
│   └── models/                 # Shared models
│       ├── pagination.dart     # Pagination models
│       └── result.dart         # Result type for Either pattern
│
├── features/                   # Feature modules
│   └── [feature_name]/         # Each feature follows this structure:
│       ├── domain/             # Domain layer
│       │   ├── entities/       # Business entities
│       │   ├── repositories/   # Repository interfaces
│       │   ├── use_cases/      # Business logic use cases
│       │   └── value_objects/  # Value objects
│       ├── data/               # Data layer
│       │   ├── models/         # Data models (DTOs)
│       │   ├── repositories/   # Repository implementations
│       │   └── data_sources/   # Remote and local data sources
│       └── presentation/       # Presentation layer
│           ├── screens/        # Screen widgets
│           ├── widgets/        # Feature-specific widgets
│           └── state/          # State management (Riverpod)
│
└── main.dart                   # Application entry point
```

## Design Patterns

### 1. Repository Pattern
- Abstracts data access logic
- Interface defined in domain layer
- Implementation in data layer
- Allows easy switching between data sources

```dart
// Domain Layer
abstract class UserRepository {
  Future<Result<User>> getUser(String id);
  Future<Result<void>> saveUser(User user);
}

// Data Layer
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Result<User>> getUser(String id) async {
    // Implementation
  }
}
```

### 2. Use Case Pattern
- Encapsulates business logic
- Single responsibility per use case
- Easy to test and maintain

```dart
class GetUserProfile {
  final UserRepository repository;

  GetUserProfile(this.repository);

  Future<Result<User>> call(String userId) async {
    return await repository.getUser(userId);
  }
}
```

### 3. Result Pattern (Either)
- Type-safe error handling
- Uses dartz package
- Left: Failure, Right: Success

```dart
typedef Result<T> = Either<Failure, T>;

// Usage
final result = await useCase.call(params);
result.fold(
  (failure) => handleError(failure),
  (data) => handleSuccess(data),
);
```

### 4. Provider Pattern (Riverpod)
- State management
- Dependency injection
- Reactive programming

```dart
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.read(userRepositoryProvider));
});
```

## Layer Dependencies

### Domain Layer
- **Dependencies**: None (pure Dart)
- **Purpose**: Business logic and entities
- **Rules**:
  - No Flutter dependencies
  - No external package dependencies (except equatable, dartz)
  - Only defines interfaces, never implementations

### Data Layer
- **Dependencies**: Domain layer
- **Purpose**: Data access and persistence
- **Rules**:
  - Implements domain repository interfaces
  - Handles data transformation (models ↔ entities)
  - Manages data sources (API, local storage)

### Presentation Layer
- **Dependencies**: Domain layer (use cases)
- **Purpose**: UI and user interaction
- **Rules**:
  - Uses use cases, never repositories directly
  - Manages UI state with Riverpod
  - No business logic (only presentation logic)

### Core & Shared
- **Dependencies**: None
- **Purpose**: Reusable utilities and components
- **Rules**:
  - Used by all layers
  - No feature-specific code
  - Generic and reusable

## Corporate Design System

### Colors
- **Primary**: `#10274C` (RGB: 16, 39, 76)
- **Primary Light**: `#1A3B6B`
- **Primary Dark**: `#0A1831`

### Typography
- **Font Family**: Bodoni 72 (fallback: serif)
- **Logo Font Size**: 12pt
- **Text Font Size**: 9pt
- **Font Weights**: 300 (light), 400 (regular), 500 (medium), 600 (semibold), 700 (bold)

### Spacing
- Uses 8px grid system
- xs: 4px, sm: 8px, md: 16px, lg: 24px, xl: 32px

### Components
- All components follow Material Design 3
- Custom theme applied via `ThemeConfig`
- Consistent spacing and elevation

## State Management

### Riverpod Architecture
```dart
// 1. Define state class
class UserState {
  final User? user;
  final bool isLoading;
  final String? error;

  UserState({this.user, this.isLoading = false, this.error});
}

// 2. Create StateNotifier
class UserNotifier extends StateNotifier<UserState> {
  final GetUserProfile _getUserProfile;

  UserNotifier(this._getUserProfile) : super(UserState());

  Future<void> loadUser(String id) async {
    state = UserState(isLoading: true);
    final result = await _getUserProfile(id);
    result.fold(
      (failure) => state = UserState(error: failure.message),
      (user) => state = UserState(user: user),
    );
  }
}

// 3. Define provider
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.read(getUserProfileProvider));
});
```

## Error Handling

### Exception Hierarchy
- `AppException` (base class)
  - `ServerException`
  - `NetworkException`
  - `CacheException`
  - `ValidationException`
  - `AuthenticationException`
  - `AuthorizationException`
  - `NotFoundException`
  - `ConflictException`

### Failure Hierarchy
- `Failure` (base class, used in Result type)
  - Same hierarchy as exceptions
  - Used for functional error handling with Either

### Error Flow
1. Data source throws exception
2. Repository catches exception, converts to Failure
3. Use case returns `Result<T>` (Either)
4. Presentation layer handles both success and failure cases

## Routing

### GoRouter Configuration
```dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
  ],
);
```

### Navigation
```dart
// Navigate to named route
context.goNamed('login');

// Navigate with parameters
context.goNamed('user', pathParameters: {'id': userId});

// Go back
context.pop();
```

## Testing Strategy

### Unit Tests
- Test domain entities
- Test use cases
- Test utilities and validators
- 100% coverage for business logic

### Integration Tests
- Test repository implementations
- Test data source interactions
- Test use case → repository flow

### Widget Tests
- Test individual widgets
- Test screen layouts
- Test user interactions

### End-to-End Tests
- Test complete user flows
- Test navigation
- Test state management

## Development Workflow

### Creating a New Feature

1. **Domain Layer First**
   ```
   feature/domain/entities/
   feature/domain/repositories/
   feature/domain/use_cases/
   ```

2. **Data Layer**
   ```
   feature/data/models/
   feature/data/data_sources/
   feature/data/repositories/
   ```

3. **Presentation Layer**
   ```
   feature/presentation/state/
   feature/presentation/widgets/
   feature/presentation/screens/
   ```

4. **Wire Up Dependencies**
   - Create providers in `feature/presentation/state/providers.dart`
   - Add routes in `app_router.dart`

### Code Review Checklist
- [ ] Follows Clean Architecture principles
- [ ] Proper layer separation
- [ ] Error handling implemented
- [ ] No business logic in presentation
- [ ] Repository interfaces in domain
- [ ] Proper state management
- [ ] Documentation added
- [ ] Naming conventions followed

## Best Practices

### DO
- ✅ Keep domain layer pure (no Flutter dependencies)
- ✅ Use dependency injection
- ✅ Return `Result<T>` from use cases
- ✅ Handle all error cases
- ✅ Use value objects for complex values
- ✅ Follow naming conventions
- ✅ Write self-documenting code
- ✅ Use const constructors where possible
- ✅ Leverage null safety

### DON'T
- ❌ Put business logic in UI
- ❌ Access repositories from presentation
- ❌ Use `dynamic` types
- ❌ Ignore errors
- ❌ Mix layer responsibilities
- ❌ Create god classes
- ❌ Use global state
- ❌ Hardcode values

## Performance Considerations

### Optimization Strategies
- Use `const` constructors for immutable widgets
- Implement pagination for large lists
- Cache frequently accessed data
- Lazy load images and heavy resources
- Use `ListView.builder` for dynamic lists
- Avoid rebuilding entire widget trees

### Caching Strategy
- L1: In-memory cache (short-lived)
- L2: Local storage (persistent)
- L3: API (source of truth)

## Security

### Authentication
- JWT tokens stored securely
- Token refresh mechanism
- Automatic logout on token expiry

### Data Protection
- Sensitive data encrypted
- HTTPS for all API calls
- Input validation on all forms
- SQL injection prevention

## Deployment

### Build Configuration
- Development: `AppConfig.development()`
- Staging: `AppConfig.staging()`
- Production: `AppConfig.production()`

### Environment Variables
- API URLs configured per environment
- Feature flags for gradual rollout
- Logging enabled only in dev/staging

## Monitoring & Logging

### Logging Levels
- `Logger.debug()`: Development debugging
- `Logger.info()`: Business events
- `Logger.warning()`: Degraded performance
- `Logger.error()`: System failures

### What to Log
- User actions (login, logout, key operations)
- API calls (request/response)
- Errors and exceptions
- Performance metrics

## Future Considerations

### Planned Enhancements
- Offline-first architecture
- Real-time updates (WebSocket)
- Multi-language support expansion
- Advanced analytics
- A/B testing framework

### Scalability
- Microservices-ready architecture
- Feature flags for modular deployment
- Horizontal scaling support
- CDN for static assets

---

**Version**: 1.0.0
**Last Updated**: 2025-01-15
**Maintainer**: Trialog Development Team
