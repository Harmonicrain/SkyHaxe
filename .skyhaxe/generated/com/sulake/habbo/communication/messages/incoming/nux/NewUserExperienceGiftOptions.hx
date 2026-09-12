package com.sulake.habbo.communication.messages.incoming.nux
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NewUserExperienceGiftOptions 
    {
        var _dayIndex:Int = 0;
        var _stepIndex:Int = 0;
        var _options:Vector<NewUserExperienceGift>;

        public function new(k:IMessageDataWrapper)
        {
            this._dayIndex = k.readInteger();
            this._stepIndex = k.readInteger();
            this._options = new Vector<NewUserExperienceGift>(0);
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._options.push(new NewUserExperienceGift(k));
                _local_3++;
            }
        }

        public var dayIndex(get,never):Int;
public function  get_dayIndex():Int
        {
            return this._dayIndex;
        }

        public var stepIndex(get,never):Int;
public function  get_stepIndex():Int
        {
            return this._stepIndex;
        }

        public var options(get,never):Vector<NewUserExperienceGift>;
public function  get_options():Vector<NewUserExperienceGift>
        {
            return this._options;
        }
    }

