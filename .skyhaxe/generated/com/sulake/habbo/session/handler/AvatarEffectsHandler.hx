package com.sulake.habbo.session.handler
;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.session.IRoomHandlerListener;
    import com.sulake.habbo.communication.messages.incoming.inventory.avatareffect.AvatarEffectsMessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;

     class AvatarEffectsHandler extends BaseHandler 
    {
        public function new(k:IConnection, _arg_2:IRoomHandlerListener)
        {
            super(k, _arg_2);
            if (k == null)
            {
                return;
            }
        }

        function onAvatarEffects(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , AvatarEffectsMessageEvent);
            var _local_3= _local_2.getParser() ;
            Logger.log([("Received active avatar effects: " + ASCompat.toString(_local_3.effects))]);
            if (((listener != null) && (listener.events != null)))
            {
            }
        }
    }

