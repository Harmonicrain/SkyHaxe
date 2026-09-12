package com.sulake.habbo.snowstorm
;
    /** Stable behavior boundary shared by the small screen renderers. */
     final class SnowStormViewServices
    {
        public var emit:ASFunction;
        public var text:ASFunction;
        public var mapName:ASFunction;
        public var localUserId:ASFunction;
        public var redraw:ASFunction;
        public var openTickets:ASFunction;

        public function assertWired()
        {
            var missing= "";
            if (this.emit == null) missing += "emit ";
            if (this.text == null) missing += "text ";
            if (this.mapName == null) missing += "mapName ";
            if (this.localUserId == null) missing += "localUserId ";
            if (this.redraw == null) missing += "redraw ";
            if (this.openTickets == null) missing += "openTickets ";
            if (missing != "") throw new ASError("SnowStormViewServices is not fully wired: " + missing);
        }
public function new(){}
    }

