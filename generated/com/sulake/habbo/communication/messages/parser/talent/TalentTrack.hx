package com.sulake.habbo.communication.messages.parser.talent
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.utils._Str_988;

     class TalentTrack 
    {
        public static inline final STATE_LOCKED= 0;
        public static inline final STATE_ONGOING= 1;
        public static inline final STATE_ACHIEVED= 2;

        var _name:String;
        var _currentLevelIndex:Int = 0;
        var _levels:Vector<TalentTrackLevel>;


        public function parse(k:IMessageDataWrapper)
        {
            var _local_4:TalentTrackLevel;
            this._name = k.readString();
            this._levels = new Vector<TalentTrackLevel>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new TalentTrackLevel();
                _local_4.parse(k);
                if (_local_4.state == STATE_ONGOING)
                {
                    this._currentLevelIndex = _local_3;
                }
                this._levels.push(_local_4);
                _local_3++;
            }
        }

        public function _Str_17590(k:Int):TalentTrackTask
        {
            var _local_3:TalentTrackLevel;
            var _local_4:TalentTrackTask;
            var _local_2:TalentTrackTask = null;
            for (_tmp_ in this._levels)
            {
_local_3  = _tmp_;
                if (_local_3.state != TalentTrack.STATE_LOCKED)
                {
                    _local_4 = _local_3._Str_17590(k);
                    if (_local_4 != null)
                    {
                        _local_2 = _local_4;
                    }
                }
            }
            return _local_2;
        }

        public var name(get,never):String;
function  get_name():String
        {
            return this._name;
        }

        public var levels(get,never):Vector<TalentTrackLevel>;
function  get_levels():Vector<TalentTrackLevel>
        {
            return this._levels;
        }

        public var progressPerLevel(get,never):Float;
function  get_progressPerLevel():Float
        {
            if (this._levels.length > 0)
            {
                return 1 / this._levels.length;
            }
            return 0;
        }

        public var _Str_18600(get,never):Float;
function  get__Str_18600():Float
        {
            var k:Float;
            if (this._levels.length > 0)
            {
                k = this._levels[this._currentLevelIndex].levelProgress;
                return _Str_988._Str_2040(((this._currentLevelIndex * this.progressPerLevel) + (k * this.progressPerLevel)));
            }
            return 0;
        }

        public var progressForCurrentLevel(get,never):Float;
function  get_progressForCurrentLevel():Float
        {
            if (this._levels.length > 0)
            {
                return this._currentLevelIndex * this.progressPerLevel;
            }
            return 0;
        }

        public function removeFirstLevel()
        {
            this._levels.shift();
            this._currentLevelIndex = Std.int(Math.max(0, (this._currentLevelIndex - 1)));
        }
public function new(){}
    }

