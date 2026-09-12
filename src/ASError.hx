import haxe.CallStack;
import haxe.CallStack.StackItem;

/**
 * Isolated ActionScript Error compatibility boundary for generated code.
 *
 * This deliberately does not use the global name `Error`, which shadows Haxe/OpenFL internals.
 * It is also deliberately a plain class: the clean client's Exception declares toString without
 * AS3's `override`, so inheriting Haxe's toString would make faithful generated code illegal.
 */
class ASError {
    /** Root AS3 Error catches VM errors, but not arbitrary values thrown by application code. */
    public static function caught(value:Dynamic):ASError {
        if (Std.isOfType(value, ASError)) return value;
        var nativeError = false;
        #if openfl
        nativeError = Std.isOfType(value, openfl.errors.Error);
        #end
        #if js
        nativeError = nativeError || Std.isOfType(value, js.lib.Error);
        #end
        if (nativeError || Std.isOfType(value, haxe.Exception)) {
            var result = new ASError(Std.string(value.message));
            if (Reflect.field(value, "name") != null) result.name = value.name;
            result.nativeStack = Reflect.field(value, "stack");
            return result;
        }
        throw value;
    }
    var nativeStack:Null<String>;
    public var message(default, null):String;
    public var name:String;
    public var errorID(default, null):Int;

    final creationStack:Array<StackItem>;

    public function new(message:String = "", id:Int = 0) {
        this.message = message == null ? "" : message;
        this.name = "Error";
        this.errorID = id;
        this.creationStack = CallStack.callStack();
    }

    public function getStackTrace():String {
        if (nativeStack != null) return nativeStack;
        return CallStack.toString(creationStack);
    }

    public function toString():String {
        return message.length == 0 ? name : name + ": " + message;
    }
}
