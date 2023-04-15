{nixlib, ...}:
with nixlib.lib;
with builtins; let
  logLevel.TRACE = "trace";
  logLevel.DEBUG = "debug";
  logLevel.INFO = "info";
  logLevel.WARN = "warn";
  logLevel.ERROR = "error";

  logLevel.default = logLevel.WARN;

  formatAttrsPretty' = prefix: attrs: let
    toPretty = v:
      if isFunction v
      then "'<function>'"
      else toJSON v;
    pairs =
      mapAttrsToList (
        k: v:
          if isOptionType v
          then formatAttrsPretty' "${prefix}${k}." (filterAttrs (k: _: k != "functor") v)
          else if isDerivation v || !isAttrs v
          then "\n${prefix}${k}=${toPretty v}"
          else formatAttrsPretty' "${prefix}${k}." v
      )
      attrs;
  in
    concatStrings pairs;

  formatAttrs.default = formatAttrs.pretty;
  formatAttrs.pretty = formatAttrsPretty' "";
  formatAttrs.toJSON = toJSON;
  formatAttrs.toString = toString;

  defaultEnv = "NIX_LOG";
  defaultFormatAttrs = formatAttrs.default;

  levelFromEnv = {
    env ? defaultEnv,
    default ? logLevel.default,
  }: let
    level = getEnv env;
  in
    if level == ""
    then default
    else level;

  mkLog = {
    level ? (levelFromEnv {}),
    formatAttrs ? defaultFormatAttrs,
    trace ? (msg: builtins.trace "TRACE: ${msg}"),
    debug ? (msg: builtins.trace "DEBUG: ${msg}"),
    info ? nixlib.lib.info,
    warn ? nixlib.lib.warn,
  }:
    assert (elem level (attrValues logLevel)); let
      isError = level == logLevel.ERROR;
      isWarn = level == logLevel.WARN;
      isInfo = level == logLevel.INFO;
      isDebug = level == logLevel.DEBUG;
      isTrace = level == logLevel.TRACE;

      log.trace = msg:
        if isTrace
        then trace msg
        else x: x;

      log.debug = msg:
        if isDebug || isTrace
        then debug msg
        else x: x;

      log.info = msg:
        if isInfo || isDebug || isTrace
        # info already adds a prefix
        then info msg
        else x: x;

      log.warn = msg:
        if isWarn || isInfo || isDebug || isTrace
        # warn already adds a prefix and has additional functionality built-in
        then warn msg
        else x: x;

      mkAttrLog = log: msg: attrs:
        log "${msg} ${(formatAttrs attrs)}";
    in {
      inherit
        (log)
        trace
        debug
        info
        warn
        ;

      warnIf = cond: msg:
        if cond
        then warn msg
        else x: x;

      trace' = mkAttrLog log.trace;
      debug' = mkAttrLog log.debug;
      info' = mkAttrLog log.info;
      warn' = mkAttrLog log.warn;
    };
in {
  inherit
    defaultEnv
    formatAttrs
    logLevel
    mkLog
    ;

  inherit
    (mkLog {})
    debug
    debug'
    info
    info'
    trace
    trace'
    warn
    warn'
    warnIf
    ;
}
