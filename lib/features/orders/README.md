# Orders Module — Reference Implementation

This module is the **canonical template** for all new feature modules in this
codebase. It demonstrates every rule in `CODING_GUIDELINES.md` end-to-end:
`injectable` + `get_it` for DI, `retrofit` for the HTTP surface, `freezed`
+ `json_serializable` for models/entities, and a `BaseBloc` for CancelToken
hygiene.

When building a new feature, **copy this module's shape first**, then
rename. Do not invent a new structure.

## Folder Map

```
orders/
├── data/
│   ├── datasources/
│   │   └── remote/
│   │       └── orders_api.dart                # Retrofit — IS the remote data source
│   ├── models/
│   │   ├── order_info_model.dart              # freezed + JSON + toEntity()
│   │   └── orders_page_response_model.dart
│   └── repositories/
│       └── orders_repository_impl.dart        # @LazySingleton(as: OrdersRepository)
├── domain/
│   ├── entities/
│   │   ├── order_info.dart                    # pure freezed
│   │   └── orders_page.dart
│   ├── repositories/
│   │   └── orders_repository.dart             # abstract — returns Either<Failure, T>
│   └── usecases/
│       └── get_orders_page_usecase.dart       # UseCase<OrdersPage, Params>
└── presentation/
    ├── bloc/
    │   ├── orders_bloc.dart                   # extends BaseBloc
    │   ├── orders_event.dart                  # imperative commands
    │   └── orders_state.dart                  # noun-status
    ├── pages/
    │   └── orders_page.dart
    └── widgets/
        └── order_item_card.dart
```

## Key Patterns Demonstrated

### 1. Dependency Injection — injectable + get_it

Every class that participates in the graph is annotated:

| Class | Annotation |
|---|---|
| `OrdersApi` (Retrofit) | `@lazySingleton` + `@factoryMethod` |
| `OrdersRepositoryImpl` | `@LazySingleton(as: OrdersRepository)` |
| `GetOrdersPageUseCase` | `@lazySingleton` |
| `OrdersBloc` | `@injectable` (factory — fresh instance per screen) |

### Error handling — zero try/catch in feature code

All `DioException` → `AppException` → `Failure` translation happens in
exactly one place: `SafeApiCall` in `core/mixins/safe_api_call.dart`,
backed by the single `mapDioException` helper in
`core/network/dio_exception_mapper.dart`. Feature data sources and
repositories **never** try/catch. If you see one in a PR, it's wrong.

### Anti-over-abstraction policy

Only three abstractions exist in this module:

1. **`OrdersApi`** — retrofit forces an abstract class. Not a design choice.
2. **`OrdersRepository`** — the one real seam, between domain and data.
3. **`UseCase<T, Params>`** — a style constraint so every use case has
   the same call signature.

There is intentionally **no separate remote data source class** here.
`OrdersApi` already gives us a typed boundary, and another wrapper would
just forward calls without adding behavior. If local caching is added in
the future, it should be introduced deliberately at that point rather
than kept as a placeholder in the reference implementation.

See `CODING_GUIDELINES.md §2.3` for the full rule.

The `Dio` instance is provided by `core/di/register_module.dart` via
`@module`, reusing the fully-configured Dio owned by `NetworkClient`.
**Never construct a new Dio in feature code** — it bypasses auth, cookie,
and logging interceptors.

### 2. Typed HTTP — Retrofit

```dart
@RestApi()
@lazySingleton
abstract class OrdersApi {
  @factoryMethod
  factory OrdersApi(Dio dio) = _OrdersApi;

  @GET(ApiConstants.ordersListing)
  Future<OrdersPageResponseModel> getOrders({
    @Query('pageNo') required int pageNo,
    @Query('pageSize') required int pageSize,
    @CancelRequest() CancelToken? cancelToken,
  });
}
```

The remote data source wraps this and translates `DioException` →
`AppException` handling does not live here. Retrofit calls flow directly
into the repository, where `safeApiCall` maps transport and app
exceptions cleanly to `Failure`.

### 3. Pure Entities, Mapped Models

Entities live in `domain/entities/` and are `@freezed`. They import only
`freezed_annotation` — **no JSON, no Dio, no Flutter**. Models live in
`data/models/`, are `@freezed` + `@JsonSerializable`, and carry a
`toEntity()` method. **Models never extend entities.**

### 4. Network-Only Repository

The reference implementation is intentionally network-only today. That
keeps the template honest: teams copying this module get a complete
working baseline without inheriting placeholder cache code that is not
yet wired into invalidation and UX flows.

If a future feature needs cache-first behavior, add it once the cache
read path, invalidation triggers, and tests are all designed together.

### 5. CancelToken Discipline via BaseBloc

`OrdersBloc extends BaseBloc<OrdersEvent, OrdersState>`. Every handler
starts with `final token = swapCancelToken();` which auto-cancels the
previous in-flight request. On `close()`, the last token is cancelled
too. No bloc in the codebase should manage `CancelToken` by hand.

### 6. Events/States Shape

- **Events are imperative commands**: `LoadOrders`, `RefreshOrders`,
  `LoadNextOrdersPage`. All `const`.
- **States are nouns describing status**: `OrdersInitial`, `OrdersLoading`,
  `OrdersLoaded`, `OrdersError`. Sealed.

### 7. Use Case Params

`GetOrdersPageUseCase` follows `UseCase<OrdersPage, GetOrdersPageParams>`
strictly. `call(params)` is the only public entry point — there is no
ad-hoc `execute(...)` with positional arguments.

## Code Generation

This module depends on generated files:
- `order_info.freezed.dart`
- `orders_page.freezed.dart`
- `order_info_model.freezed.dart`, `order_info_model.g.dart`
- `orders_page_response_model.freezed.dart`, `orders_page_response_model.g.dart`
- `orders_api.g.dart` (Retrofit)

Run after pulling or changing these files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For active development use `watch`:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

Generated files are committed to the repository.

## Migrating to Full `configureDependencies()`

The orders module is currently double-registered:
1. Via `@LazySingleton(as: ...)` / `@injectable` annotations (inert until
   `configureDependencies()` is called).
2. Via manual `sl.registerLazySingleton(...)` in
   `main/di/injection_container.dart`.

Once the team is comfortable running `build_runner` in CI, the manual
block for orders can be deleted and replaced with a single call to the
generated `sl.init()` extension. The annotations are already correct.

## Testing

Every new file added here should ship with a test:
- `test/orders/domain/usecases/get_orders_page_usecase_test.dart`
- `test/orders/data/repositories/orders_repository_impl_test.dart`
- `test/orders/presentation/bloc/orders_bloc_test.dart`

Use `mocktail` for mocks and `bloc_test` for BLoC coverage. See
`CODING_GUIDELINES.md §2.12` for coverage targets.
