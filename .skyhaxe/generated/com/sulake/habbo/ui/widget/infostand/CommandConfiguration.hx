package com.sulake.habbo.ui.widget.infostand
;

     class CommandConfiguration 
    {
        var _allCommandIds:Array<ASAny>;
        var _enabledCommands:ASDictionary<ASAny,ASAny>;

        public function new(k:Array<ASAny>, _arg_2:Array<ASAny>)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            this._enabledCommands = new ASDictionary<ASAny,ASAny>();
            this._allCommandIds = k;
            while (_local_3 < _arg_2.length)
            {
                _local_4 = ASCompat.toInt(_arg_2[_local_3]);
                this._enabledCommands[_local_4] = true;
                _local_3++;
            }
        }

        public var allCommandIds(get,never):Array<ASAny>;
public function  get_allCommandIds():Array<ASAny>
        {
            return this._allCommandIds;
        }

        public function isEnabled(k:Int):Bool
        {
            return !(this._enabledCommands[k] == null);
        }
    }

