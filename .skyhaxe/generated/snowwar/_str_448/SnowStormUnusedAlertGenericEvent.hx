package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormUnusedAlertGenericParser;

     class SnowStormUnusedAlertGenericEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormUnusedAlertGenericParser);
        }

        public function getParser():SnowStormUnusedAlertGenericParser
        {
            return Std.downcast(this._parser , SnowStormUnusedAlertGenericParser);
        }
    }

