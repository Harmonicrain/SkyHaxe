package com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.IUserDefinedRoomEventsCtrl;
    import com.sulake.habbo.roomevents.userdefinedroomevents.WiredFurniture;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.TriggerDefinition;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;

     class UserDefinedRoomEventsTriggersCtrl implements IUserDefinedRoomEventsCtrl 
    {
        var _Str_3624:Array<ASAny>;

        public function new()
        {
            this._Str_3624 = new Array<ASAny>();
            this._Str_3624.push(new AvatarSaysSomething());
            this._Str_3624.push(new AvatarWalksOnFurni());
            this._Str_3624.push(new AvatarWalksOffFurni());
            this._Str_3624.push(new TriggerOnce());
            this._Str_3624.push(new ToggleFurni());
            this._Str_3624.push(new TriggerPeriodically());
            this._Str_3624.push(new AvatarEnterRoom());
            this._Str_3624.push(new GameStarts());
            this._Str_3624.push(new GameEnds());
            this._Str_3624.push(new ScoreAchieved());
            this._Str_3624.push(new Collision());
            this._Str_3624.push(new TriggerPeriodicallyLong());
            this._Str_3624.push(new BotReachedStuff());
            this._Str_3624.push(new BotReachedAvatar());
        }

        public var _Str_26037(get,never):Array<ASAny>;
public function  get__Str_26037():Array<ASAny>
        {
            return this._Str_3624;
        }

        public function _Str_9781(k:Int):WiredTrigger
        {
            var _local_2:WiredTrigger = null;
            final _iter_ = this._Str_3624; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.code == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_15652(k:Int):WiredFurniture
        {
            return this._Str_9781(k);
        }

        public function _Str_14545(k:Triggerable):Bool
        {
            return !(Std.downcast(k , TriggerDefinition) == null);
        }

        public function _Str_1196():String
        {
            return "trigger";
        }
    }

