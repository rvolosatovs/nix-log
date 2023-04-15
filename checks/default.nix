{
  self,
  nixlib,
  nix-flake-tests,
  ...
}: pkgs:
with nixlib.lib;
with builtins;
with self.lib; let
  traceLog = mkLog {
    level = logLevel.TRACE;

    trace = msg: assert msg == "trace-level-trace"; x: x;
    debug = msg: assert msg == "trace-level-debug"; x: x;
    info = msg: assert msg == "trace-level-info"; x: x;
    warn = msg: assert msg == "trace-level-warn"; x: x;
  };

  warnLog = mkLog {
    level = logLevel.WARN;

    trace = msg: throw "must not be called";
    debug = msg: throw "must not be called";
    info = msg: throw "must not be called";
    warn = msg: assert msg == "warn-level-warn"; x: x;
  };

  mkMsgTest = f: msg: {
    expected = "test";
    expr = f msg "test";
  };

  mkAttrTest = f: msg: {
    expected = "test";
    expr = f msg {
      foo = "foo";
      foobar.foo = "foo";

      func = {}: "foo";
      opt = mkOption {
        type = types.enum ["foo" "bar"];
        default = "foo";
      };
      drv = derivation {
        inherit (pkgs.buildPlatform) system;

        name = "foo";
        builder = pkgs.writeShellScriptBin "foo" ''
          echo foo
        '';
      };
    } "test";
  };
in {
  lib = nix-flake-tests.lib.check {
    inherit pkgs;

    tests.testDefaultTrace = mkMsgTest trace "default-trace";
    tests.testDefaultDebug = mkMsgTest debug "default-debug";
    tests.testDefaultInfo = mkMsgTest info "default-info";
    tests.testDefaultWarn = mkMsgTest warn "default-warn";

    tests.testDefaultTrace' = mkAttrTest trace' "default-trace'";
    tests.testDefaultDebug' = mkAttrTest debug' "default-debug'";
    tests.testDefaultInfo' = mkAttrTest info' "default-info'";
    tests.testDefaultWarn' = mkAttrTest warn' "default-warn'";

    tests.testTraceLevelTrace = mkMsgTest traceLog.trace "trace-level-trace";
    tests.testTraceLevelDebug = mkMsgTest traceLog.debug "trace-level-debug";
    tests.testTraceLevelInfo = mkMsgTest traceLog.info "trace-level-info";
    tests.testTraceLevelWarn = mkMsgTest traceLog.warn "trace-level-warn";

    tests.testWarnLevelTrace = mkMsgTest warnLog.trace "warn-level-trace";
    tests.testWarnLevelDebug = mkMsgTest warnLog.debug "warn-level-debug";
    tests.testWarnLevelInfo = mkMsgTest warnLog.info "warn-level-info";
    tests.testWarnLevelWarn = mkMsgTest warnLog.warn "warn-level-warn";
  };
}
