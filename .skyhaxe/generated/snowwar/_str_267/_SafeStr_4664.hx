package snowwar._str_267
;
    import com.sulake.habbo.communication.messages.parser.game.score.LeaderboardEntry;
    import snowwar.SnowWarEngine;
    import snowwar._str_477._SafeStr_3776;
    import com.sulake.core.communication.messages.IMessageComposer;

     class _SafeStr_4664 extends LeaderboardTable 
    {
        var _SafeStr_22055:LeaderboardEntry;

        public function new(k:SnowWarEngine)
        {
            super(k);
            _SafeStr_22049 = (_SafeStr_22049 - 1);
        }

        override public function dispose()
        {
            super.dispose();
            this._SafeStr_22055 = null;
        }

        override public function addEntries(k:Array<ASAny>, _arg_2:Int)
        {
            this._SafeStr_22055 = k.pop();
            super.addEntries(k, _arg_2);
        }

        override function getMessageComposer(k:Int, _arg_2:Int, _arg_3:Int):IMessageComposer
        {
            return new _SafeStr_3776(k, _arg_2, _arg_3, _SafeStr_22049, _SafeStr_22050);
        }

        override public function getVisibleEntries():Array<ASAny>
        {
            var k= super.getVisibleEntries();
            if (this._SafeStr_22055 != null)
            {
                k.push(this._SafeStr_22055);
            }
            return k;
        }

        override function initializeList()
        {
            _SafeStr_22048 = 0;
        }
    }

