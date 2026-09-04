package com.sulake.habbo.communication.messages.incoming.room.camera
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.camera.CameraSnapshotMessageParser;

     class CameraSnapshotMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CameraSnapshotMessageParser);
        }

        public function getParser():CameraSnapshotMessageParser
        {
            return Std.downcast(_parser , CameraSnapshotMessageParser);
        }
    }

