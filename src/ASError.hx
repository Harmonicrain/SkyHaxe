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
        return CallStack.toString(creationStack);
    }

    public function toString():String {
        return message.length == 0 ? name : name + ": " + message;
    }
}
