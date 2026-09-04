package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.RoomVisualizationSettingsParser;

     class RoomVisualizationSettingsEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomVisualizationSettingsParser);
        }

        public function getParser():RoomVisualizationSettingsParser
        {
            return Std.downcast(_parser , RoomVisualizationSettingsParser);
        }
    }

