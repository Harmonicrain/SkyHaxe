/** AS3's global RangeError, retained as a narrow VM compatibility type. */
class RangeError extends ASError {
    public function new(message:String = "", id:Int = 0) {
        super(message, id);
    }
}
