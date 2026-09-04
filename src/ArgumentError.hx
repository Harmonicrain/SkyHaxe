/**
 * ActionScript's ArgumentError, for generated `catch (e:ArgumentError)` clauses.
 *
 * Sits alongside ASError for the same reason: the global name `Error` shadows Haxe/OpenFL
 * internals, so the AS3 error hierarchy is mirrored here rather than mapped onto Haxe's.
 * OpenFL does not raise this type, so these handlers are unreachable in practice -- but the
 * clean client declares them, and generated code has to compile against the shape it was written
 * for rather than a rewritten one.
 */
class ArgumentError extends ASError {
    public function new(message:String = "", id:Int = 0) {
        super(message, id);
        this.name = "ArgumentError";
    }
}
