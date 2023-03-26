# Description

Nix expressions usually work as you expect them to, but sometimes they do not. `nix-log` provides logging functionality you wish you had in the latter case without cluttering the former one.

`nix-log` wraps logging functionality already existing within [`nix`](https://nixos.org/manual/nix/stable/language/builtins.html#built-in-functions) and [`nixpkgs`](https://github.com/NixOS/nixpkgs/blob/master/lib/trivial.nix)

By default, the logger will only print `WARN` level logs, unless a different log level value is set in `NIX_LOG` environment variable.

## API

- `trace` - [`builtins.trace`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-trace) counterpart, which will only result in a log statement being printed in `TRACE` log level. Available as global `lib.trace` and as a `trace` "method" on a logger instance constructed via `mkLog`.
- `trace'` - [`builtins.trace`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-trace) counterpart, which will only result in a log statement being printed in `TRACE` log level. This variation takes an extra attribute-set parameter, which will be formatted using configured `formatAttrs` ([`builtins.toJSON`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-toJSON) by default) and appended to the log message. Available as global `lib.trace'` and as a `trace'` "method" on a logger instance constructed via `mkLog`.
- `debug` - prints a log statement in `DEBUG` log level or above. Available as global `lib.debug` and as a `debug` "method" on a logger instance constructed via `mkLog`.
- `debug'` - prints a log statement in `DEBUG` log level or above. This variation takes an extra attribute-set parameter, which will be formatted using configured `formatAttrs` ([`builtins.toJSON`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-toJSON) by default) and appended to the log message. Available as global `lib.debug'` and as a `debug'` "method" on a logger instance constructed via `mkLog`.
- `info` - [`nixpkgs.lib.info`](https://github.com/NixOS/nixpkgs/blob/b0fd7a3179772d1a640dfc9f00b3df8cc50873ec/lib/trivial.nix#L412) counterpart, which will only result in a log statement being printed in `INFO` log level. Available as global `lib.info` and as a `info` "method" on a logger instance constructed via `mkLog`.
- `info'` - [`nixpkgs.lib.info`](https://github.com/NixOS/nixpkgs/blob/b0fd7a3179772d1a640dfc9f00b3df8cc50873ec/lib/trivial.nix#L412) counterpart, which will only result in a log statement being printed in `INFO` log level. This variation takes an extra attribute-set parameter, which will be formatted using configured `formatAttrs` ([`builtins.toJSON`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-toJSON) by default) and appended to the log message. Available as global `lib.info'` and as a `info'` "method" on a logger instance constructed via `mkLog`.
- `warn` - [`nixpkgs.lib.warn`](https://github.com/NixOS/nixpkgs/blob/b0fd7a3179772d1a640dfc9f00b3df8cc50873ec/lib/trivial.nix#L347-L350) counterpart, which will only result in a log statement being printed in `WARN` log level. Available as global `lib.warn` and as a `warn` "method" on a logger instance constructed via `mkLog`.
- `warn'` - [`nixpkgs.lib.warn`](https://github.com/NixOS/nixpkgs/blob/b0fd7a3179772d1a640dfc9f00b3df8cc50873ec/lib/trivial.nix#L347-L350) counterpart, which will only result in a log statement being printed in `WARN` log level. This variation takes an extra attribute-set parameter, which will be formatted using configured `formatAttrs` ([`builtins.toJSON`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-toJSON) by default) and appended to the log message. Available as global `lib.warn'` and as a `warn'` "method" on a logger instance constructed via `mkLog`.
- `warnIf` - [`nixpkgs.lib.warnIf`](https://github.com/NixOS/nixpkgs/blob/b0fd7a3179772d1a640dfc9f00b3df8cc50873ec/lib/trivial.nix#L357) counterpart, which will only result in a log statement being printed in `WARN` log level. Available as global `lib.warnIf` and as a `warnIf` "method" on a logger instance constructed via `mkLog`.

- `mkLog` - constructs a new logger
- `logLevel` - an attribute-set of supported log level "enums"
