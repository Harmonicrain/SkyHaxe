package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CommunityGoalHallOfFameData implements IDisposable 
    {
        var _goalCode:String;
        var _hof:Array<ASAny>;

        public function new(k:IMessageDataWrapper)        {
            this._hof = [];
            this._goalCode = k.readString();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._hof.push(new HallOfFameEntryData(k));
                _local_3++;
            }
        }

        public function dispose()
        {
            this._hof = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._hof == null;
        }

        public var hof(get,never):Array<ASAny>;
public function  get_hof():Array<ASAny>
        {
            return this._hof;
        }

        public var goalCode(get,never):String;
public function  get_goalCode():String
        {
            return this._goalCode;
        }
    }

