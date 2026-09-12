package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /** Shared fail-fast bounds for unframed Wired 2.0 packet collections. */
     class WiredMessageDataValidator
    {
        public static function requireBytes(k:IMessageDataWrapper, amount:UInt, label:String)
        {
            if (k.bytesAvailable < amount)
            {
                throw new ASError(label + ": needs at least " + Std.string(amount) + " bytes, has " + Std.string(k.bytesAvailable));
            }
        }

        public static function readCount(k:IMessageDataWrapper, minimumEntryBytes:UInt,
                                         hardLimit:Int, label:String):Int
        {
            requireBytes(k, 4, label + " count");
            var count= k.readInteger();
            if (count < 0)
            {
                throw new ASError(label + ": negative count " + Std.string(count));
            }
            if (count > hardLimit)
            {
                throw new ASError(label + ": count " + Std.string(count) + " exceeds hard limit " + Std.string(hardLimit));
            }
            if (minimumEntryBytes > 0 && count > Std.int(k.bytesAvailable / minimumEntryBytes))
            {
                throw new ASError(label + ": count " + Std.string(count) + " exceeds remaining packet bytes");
            }
            return count;
        }

	public function new() {}
    }

