# Architecture

- **Phase vs Flow**: `AppPhase = launching | running(flow)`; `AppFlow = preIntro | intro | signIn | home`.
- **Router** computes initial flow at startup and owns transitions.
- **Per-Flow NavigationStack**: each flow owns its own `NavigationPath`. When switching flows, reset the previous path to guarantee no back-navigation across flows.
- **DI via Environment**: `AuthClient` is injected via `EnvironmentValues`. Live impl wraps `KeychainClient`.

## Key transitions

- Launching → Running(Home) if `auth.hasValidToken()` true
- Otherwise: PreIntro (once) → Intro (once) → SignIn
- SignIn → Home on OTP verify or Google callback success
- Home → SignIn on sign out or token expiry
