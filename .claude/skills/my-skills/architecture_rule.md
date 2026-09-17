# AI Agent Coding Rules

These are binding rules for any AI agent building a new feature or refactoring existing code in this repository. Read every section before writing a single line. The orders module (`lib/orders/`) is the canonical reference implementation — read it first.

---

## 0. Before You Start

1. Read the feature's existing code top-to-bottom before editing anything.
2. If the feature already exists, identify which layer you are touching and follow only the rules for that layer.
3. If building new, scaffold **all four layers** in order: domain → data → presentation → DI.
4. Run `dart analyze` after every edit. Fix all errors before continuing.
5. The reference implementation lives at `lib/orders/`. When in doubt, copy its pattern exactly.

---

## 1. Folder Structure

Every feature lives under `lib/<feature>/` with exactly these layers:

```
lib/<feature>/
  data/
    datasources/
      remote/
        <feature>_remote_datasource.dart          ← Retrofit client
        <feature>_remote_datasource.g.dart        ← generated (do not edit)
    models/
      <model>_model.dart            ← JsonSerializable + fromJson + toEntity()
      <model>_model.g.dart          ← generated
    repositories/
      <feature>_repository_impl.dart
  domain/
    entities/
      <entity>_entity.dart          ← Freezed, no JSON
      <entity>_entity.freezed.dart  ← generated
    repositories/
      <feature>_repository.dart     ← abstract interface only
    usecases/
      <action>_usecase.dart
  presentation/
    bloc/
      <feature>_bloc.dart
      <feature>_event.dart
      <feature>_state.dart
      <feature>_bloc.freezed.dart   ← generated
    pages/
      <feature>_page.dart
    widgets/
      *.dart
    <feature>_route.dart
```

No file belongs outside the layer it is responsible for. Do not create `utils/`, `helpers/`, or `mixins/` inside a feature — shared helpers go in `lib/core/`.

---

## 2. Domain Layer

### Entities

- Use `@freezed abstract class` — no `fromJson`, no `toJson`, no `Equatable`.
- All fields must be immutable (`final` via Freezed factory constructor).
- Use extension methods for derived values — do not add instance methods to the Freezed class body.

```dart
@freezed
abstract class OrderInfoEntity with _$OrderInfoEntity {
  const factory OrderInfoEntity({
    required int orderId,
    required String status,
  }) = _OrderInfoEntity;
}

extension OrderInfoEntityX on OrderInfoEntity {
  bool get isDelivered => status == 'DELIVERED';
}
```

### Repository Interface

- Abstract class only — no implementation, no annotations.
- Every method returns `Future<Either<Failure, T>>`.
- Accept `CancelToken? cancelToken` on every network method.

```dart
abstract class OrdersRepository {
  Future<Either<Failure, OrdersPageEntity>> getOrders({
    required int pageNo,
    required int pageSize,
    CancelToken? cancelToken,
  });
}
```

### Use Cases

- One class per business operation.
- Implement `UseCase<ReturnType, Params>` from `lib/core/usecases/usecase.dart`.
- Annotate `@lazySingleton`.
- Constructor-inject the repository **interface** — never the impl.
- The `call()` method only delegates to the repository — zero business logic, zero try/catch.
- For the `Params` class: use plain Dart `==`/`hashCode` (no `Equatable`). Exclude `CancelToken` from equality.

```dart
@lazySingleton
class GetOrdersPageUseCase
    implements UseCase<OrdersPageEntity, GetOrdersPageParams> {
  GetOrdersPageUseCase(this._repository);
  final OrdersRepository _repository;

  @override
  Future<Either<Failure, OrdersPageEntity>> call(GetOrdersPageParams params) =>
      _repository.getOrders(
        pageNo: params.pageNo,
        pageSize: params.pageSize,
        cancelToken: params.cancelToken,
      );
}

class GetOrdersPageParams extends Equatable {
  const GetOrdersPageParams({required this.pageNo, this.pageSize = 20, this.cancelToken});
  final int pageNo;
  final int pageSize;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [pageNo, pageSize];
  // cancelToken intentionally excluded — not a semantic field
}
```

---

## 3. Data Layer

### Models

- `@JsonSerializable(createToJson: false)` + `fromJson`. No Freezed — DTOs are short-lived (parsed then mapped to entity) and never need `copyWith` or value equality.
- Every field that can be missing or null in the API response **must** have `@JsonKey(defaultValue: ...)`.
- Add a `toEntity()` extension method — this is the only place JSON → domain conversion happens.
- No business logic inside models.

```dart
@JsonSerializable(createToJson: false)
class OrderInfoModel {
  const OrderInfoModel({required this.orderId, required this.status});

  @JsonKey(name: 'order_id', defaultValue: 0) final int orderId;
  @JsonKey(name: 'status',   defaultValue: '') final String status;

  factory OrderInfoModel.fromJson(Map<String, dynamic> json) =>
      _$OrderInfoModelFromJson(json);
}

extension OrderInfoModelX on OrderInfoModel {
  OrderInfoEntity toEntity() => OrderInfoEntity(orderId: orderId, status: status);
}
```

### Retrofit API Client

- `@RestApi()` + `@lazySingleton` + `@factoryMethod` — always all three.
- Path from `ApiConstants` — never a raw string.
- Return type is always a typed model class — never `dynamic` or `Map`.
- Every method has `@CancelRequest() CancelToken? cancelToken`.

```dart
@RestApi()
@lazySingleton
abstract class OrdersApi {
  @factoryMethod
  factory OrdersApi(Dio dio) = _OrdersApi;

  @GET(ApiConstants.ordersListing)
  Future<OrdersPageResponseModel> getOrders({
    @Query('pageNo')   required int pageNo,
    @Query('pageSize') required int pageSize,
    @CancelRequest()   CancelToken? cancelToken,
  });
}
```

### Repository Implementation

- Annotate `@LazySingleton(as: FeatureRepository)` — registers as the interface.
- Mix in `SafeApiCall` — this is the **only** error boundary. No try/catch.
- Call `safeApiCall(networkInfo, () async { ... })` wrapping every API call.
- Call `response.toEntity()` inside `safeApiCall` — never outside.

```dart
@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl with SafeApiCall implements OrdersRepository {
  OrdersRepositoryImpl(this._api, this._networkInfo);
  final OrdersApi _api;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, OrdersPageEntity>> getOrders({
    required int pageNo,
    required int pageSize,
    CancelToken? cancelToken,
  }) =>
      safeApiCall(_networkInfo, () async {
        final response = await _api.getOrders(
          pageNo: pageNo,
          pageSize: pageSize,
          cancelToken: cancelToken,
        );
        return response.toEntity();
      });
}
```

---

## 4. Presentation Layer

### Bloc Events

- `@freezed sealed class` — sealed enables exhaustiveness checking.
- Imperative names: `LoadOrders`, `RefreshOrders`, `LoadNextOrdersPage`.
- No past-tense names unless triggered by an external system callback.
- **Soft limit: max 7 events per Bloc.** More than 7 events usually signals the Bloc is handling multiple responsibilities — split into focused Blocs. Exceeding is allowed when genuinely necessary, but prefer splitting.

```dart
@freezed
sealed class OrdersEvent with _$OrdersEvent {
  const factory OrdersEvent.load()         = LoadOrders;
  const factory OrdersEvent.refresh()      = RefreshOrders;
  const factory OrdersEvent.loadNextPage() = LoadNextOrdersPage;
}
```

### Bloc State

- Single `@freezed abstract class` with a status enum — never multiple subclasses.
- `@Default` on every non-required field.
- Extension methods for derived values — not in the class body.
- Never store `BuildContext`, widgets, streams, or controllers in state.

```dart
enum OrdersStatus { initial, loading, success, error }

@freezed
abstract class OrdersState with _$OrdersState {
  const factory OrdersState({
    @Default(OrdersStatus.initial) OrdersStatus status,
    OrdersPageEntity? page,
    @Default(1) int currentPage,
    String? errorMessage,
    @Default(false) bool isLoadingMore,
    String? paginationError,
  }) = _OrdersState;
}

extension OrdersStateX on OrdersState {
  List<OrderInfoEntity> get orders => page?.items ?? [];
  bool get hasReachedEnd => page?.hasReachedEnd ?? false;
}
```

### Bloc Class

- `extends BaseBloc<Event, State>` — always, for every network-backed Bloc.
- Annotate `@injectable` — never `@lazySingleton` or `@singleton`.
- Constructor-inject use cases only — never repositories, API clients, or `BuildContext`.
- Register one handler per event in the constructor: `on<Event>(_onEvent)`.

**Full reset (initial load / refresh):**

```dart
emit(const OrdersState(status: OrdersStatus.loading)); // bare constructor
final token = swapCancelToken();
final result = await _getOrdersPage(GetOrdersPageParams(pageNo: 1, cancelToken: token));
result.fold(
  (f) {
    if (f is RequestCancelledFailure) return;
    emit(OrdersState(status: OrdersStatus.error, errorMessage: f.message));
  },
  (p) => emit(OrdersState(status: OrdersStatus.success, page: p, currentPage: 1)),
);
```

**Pagination (keep existing data visible):**

```dart
final current = state;                              // snapshot BEFORE first emit
emit(current.copyWith(isLoadingMore: true));
final token = swapCancelToken();
final result = await _getOrdersPage(GetOrdersPageParams(
  pageNo: current.currentPage + 1, cancelToken: token,
));
result.fold(
  (f) {
    if (f is RequestCancelledFailure) return;
    emit(current.copyWith(isLoadingMore: false, paginationError: f.message));
  },
  (p) => emit(current.copyWith(
    isLoadingMore: false,
    page: current.page!.merge(p),
    currentPage: current.currentPage + 1,
  )),
);
```

**Rules enforced:**

- Always call `swapCancelToken()` at the top of every network handler.
- Always use plain `emit(...)` — there is no `safeEmit`.
- Always snapshot `final current = state` before any intermediate emit. **Why:** bloc's default transformer is `concurrent()` — handlers for different event types run at the same time. A pull-to-refresh firing `_onLoadOrders` while `_onLoadNextOrdersPage` awaits a network call will wipe `state.page` to `null`. Without the snapshot, `current.page!.merge(next)` crashes with a null deref. The snapshot is frozen and immune to concurrent handler mutations. Required whenever: (a) pagination — keep existing list visible while loading more; (b) optimistic update — need original state to revert on failure; (c) per-row action (delete, toggle) — need original list to restore on failure; (d) form submit — preserve form data if API errors. Skip only for bare-constructor full resets or single synchronous emits with no `await`.
- Always silently ignore `RequestCancelledFailure`.
- Never parse JSON, never call repositories, never call `sl<T>()`.

### Pages and Widgets

- Pages are pure consumers: read state, dispatch events.
- **Never** create `BlocProvider`, call `sl<T>()`, or import a Bloc constructor inside a page.
- Use the correct widget for the job:

| Need                                 | Widget                       |
| ------------------------------------ | ---------------------------- |
| Dispatch from callback / `initState` | `context.read<B>().add(...)` |
| Rebuild from whole state             | `BlocBuilder`                |
| Rebuild from one field               | `BlocSelector`               |
| Side effects (snackbar, nav, dialog) | `BlocListener`               |
| Both in same subtree                 | `BlocConsumer`               |

- Side effects go in `listener` — **never** in `builder`.
- Do not dispatch events from `build()`.

### Route File

- One `<feature>_route.dart` per feature.
- Class named `<Feature>Route` with a static `getRoute()` / `getRoutes()` / `getBranch()`.
- `BlocProvider` goes here — nowhere else.
- Fire the initial event inside `create:`.
- Set `name:` on every `GoRoute` (used by `pushNamed`).
- Set `parentNavigatorKey: rootKey` for routes that push over the shell.

```dart
class OrdersRoute {
  static GoRoute getRoute(GlobalKey<NavigatorState> rootKey) => GoRoute(
    path: RouteNames.orders,
    name: 'orders',
    parentNavigatorKey: rootKey,
    builder: (_, __) => BlocProvider(
      create: (_) => sl<OrdersBloc>()..add(const LoadOrders()),
      child: const OrdersPage(),
    ),
  );
}
```

- Wire into `app_router.dart` (one line).
- Add path constant to `route_names.dart`.
- Add navigation helper to `app_navigator.dart` using `context.pushNamed(name)`.

---

## 5. Dependency Injection

### New feature checklist

1. Retrofit API client — `@lazySingleton` + `@factoryMethod`. ✓
2. Repository impl — `@LazySingleton(as: FeatureRepository)`. ✓
3. Use case(s) — `@lazySingleton`. ✓
4. Bloc — `@injectable` (factory). ✓
5. Add manual registrations to `injection_container.dart` until codegen is active.
6. Run `dart run build_runner build --delete-conflicting-outputs`.

### Hard rules

- `sl<T>()` is **only** allowed in: route builders, `injection_container.dart`, `@module` methods.
- Never call `sl<T>()` inside a widget, Bloc, use case, or repository.
- Never register a Bloc as `@lazySingleton` or `@singleton`.
- Always inject the **interface** (`OrdersRepository`), never the implementation (`OrdersRepositoryImpl`).

---

## 6. Error Handling

- `SafeApiCall` is the one and only error boundary. Do not add try/catch in repositories.
- `Failure` is a sealed class — handle specific subtypes in Bloc fold when the UI needs to differentiate.
- Always handle both branches of `result.fold(...)` — never ignore the left branch silently.
- Log errors: `talker.handle(e, st, 'context')` — never `print(e)` or `talker.error(e.toString())`.
- `RequestCancelledFailure` must be silently swallowed in all Bloc handlers — it is not a user-facing error.

---

## 7. Navigation

- All navigation calls go through `AppNavigator.goToX(context)` — never raw `context.go()` or `context.pushNamed()` at call sites.
- Navigation is always triggered from `BlocListener` — never from a Bloc handler.
- Auth guards live in `GoRouter.redirect` — never in `initState` or Bloc.
- Pass existing Blocs via `BlocProvider.value` + `extra: <String, dynamic>{'bloc': ...}` — never `BlocProvider(create:)` for an already-created instance.
- Use `StatefulShellRoute.indexedStack` for bottom nav — never `ShellRoute`.

---

## 8. Logging

- Inject `Talker` via constructor (`sl<Talker>()` in route/DI boundaries only).
- Use `talker.handle(e, st, 'description')` in all catch blocks.
- Use the correct level: `info` for lifecycle, `warning` for recoverable anomalies, `error`/`critical` for failures.
- Never log PII (emails, phone numbers, addresses) — log IDs only.
- Never call `print()` or `debugPrint()` in feature code.
- `FirebaseCrashlytics.instance.recordError(...)` must never appear in feature code — the `CrashlyticsTalkerObserver` handles this automatically.

---

## 9. Code Generation

After any change to a file annotated with `@freezed`, `@JsonSerializable`, `@RestApi`, or `@injectable`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Never manually edit `.freezed.dart`, `.g.dart`, or `injection.config.dart` files.

---

## 10. What Never Goes Where

| Item                                            | Forbidden in                                          |
| ----------------------------------------------- | ----------------------------------------------------- |
| `fromJson` / `toJson`                           | Domain entities                                       |
| `sl<T>()`                                       | Widgets, Blocs, use cases, repositories               |
| `DioException`, `ApiClient`, `Retrofit` imports | Domain layer                                          |
| `BuildContext`                                  | Bloc state, use cases, repositories                   |
| `print()` / `debugPrint()`                      | Anywhere — use `talker`                               |
| Side effects (snackbar, nav)                    | `BlocBuilder.builder`                                 |
| `BlocProvider`                                  | Inside page `build()` methods                         |
| JSON parsing                                    | Blocs, use cases, entities                            |
| Business logic                                  | Models, repositories                                  |
| `CancelToken` in `Equatable.props`              | Params classes                                        |
| `@lazySingleton`                                | Blocs                                                 |
| Hardcoded path strings                          | `@GET`/`@POST` annotations, `context.go()` call sites |

---

## 11. File Size Guidelines

These are **soft limits** — they can be exceeded when genuinely necessary, but treat approaching them as a signal to consider splitting.

| File type                   | Soft limit |
| --------------------------- | ---------- |
| Page / widget file          | 700 lines  |
| Bloc class (`_bloc.dart`)   | 700 lines  |
| Bloc events (`_event.dart`) | 7 events   |
| Repository implementation   | 700 lines  |
| Retrofit API client         | 700 lines  |
| Any other Dart file         | 700 lines  |

**When a file approaches the limit:**

- Widget files: extract sub-widgets or reusable components into separate files under `widgets/`.
- Bloc files: split by responsibility into two focused Blocs, each with its own event/state files.
- Repository impl: split into multiple repositories by sub-domain.
- API client: split into multiple `@RestApi` clients by endpoint group.

---

## 12. Completion Checklist

Before marking any task done, verify:

- [ ] All four layers exist and have no cross-layer import violations
- [ ] `dart analyze` passes with zero errors
- [ ] `build_runner` has been run; generated files are up to date
- [ ] Every network handler calls `swapCancelToken()` first
- [ ] Every network handler silently ignores `RequestCancelledFailure`
- [ ] `final current = state` snapshot exists before any intermediate emit
- [ ] Bloc is `@injectable`, use cases and repos are `@lazySingleton`
- [ ] Repository impl has `@LazySingleton(as: Interface)`
- [ ] Route file exists; wired into `app_router.dart`; nav helper in `app_navigator.dart`
- [ ] `BlocProvider` only in route builder — not in page
- [ ] Side effects only in `BlocListener` — not in `builder`
- [ ] No `print()`, no `sl<T>()` in feature widgets, no `try/catch` in repositories
- [ ] Manual DI registration added to `injection_container.dart`
- [ ] No file exceeds 700 lines (soft limit — flag if approaching, split if exceeded without strong justification)
- [ ] Bloc has ≤ 7 events (soft limit — split by responsibility if exceeded)
