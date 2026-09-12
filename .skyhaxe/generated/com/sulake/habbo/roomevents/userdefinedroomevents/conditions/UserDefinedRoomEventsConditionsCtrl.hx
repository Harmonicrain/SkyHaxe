package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.IUserDefinedRoomEventsCtrl;
    import com.sulake.habbo.roomevents.userdefinedroomevents.WiredFurniture;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.ConditionDefinition;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ActorHasHandItem;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ActorIsInGroup;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ActorIsInTeam;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ActorIsWearingEffect;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ActorOnFurni;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ActorWearsBadge;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.DateRangeActive;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.DontHaveStackedFurnis;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.FurniHaveHabbo;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.FurniIsOfType;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.HasStackedFurnis;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.MatchSnapshot;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.StuffsInFormation;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.TimeElapsedLess;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.TimeElapsedMore;
	import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.UserCountIn;

     class UserDefinedRoomEventsConditionsCtrl implements IUserDefinedRoomEventsCtrl 
    {
        var _Str_2148:Array<ASAny>;

        public function new()
        {
            this._Str_2148 = new Array<ASAny>();
            this._Str_2148.push(new ActorOnFurni());
            this._Str_2148.push(new FurniHaveHabbo());
            this._Str_2148.push(new MatchSnapshot());
            this._Str_2148.push(new TimeElapsedMore());
            this._Str_2148.push(new TimeElapsedLess());
            this._Str_2148.push(new UserCountIn());
            this._Str_2148.push(new ActorIsInTeam());
            this._Str_2148.push(new HasStackedFurnis());
            this._Str_2148.push(new FurniIsOfType());
            this._Str_2148.push(new StuffsInFormation());
            this._Str_2148.push(new ActorIsInGroup());
            this._Str_2148.push(new ActorWearsBadge());
            this._Str_2148.push(new ActorIsWearingEffect());
            this._Str_2148.push(new DontHaveStackedFurnis());
            this._Str_2148.push(new DateRangeActive());
            this._Str_2148.push(new ActorHasHandItem());
        }

        public var _Str_24294(get,never):Array<ASAny>;
public function  get__Str_24294():Array<ASAny>
        {
            return this._Str_2148;
        }

        public function _Str_9781(k:Int):WiredCondition
        {
            var _local_2:WiredCondition = null;
            final _iter_ = this._Str_2148; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.code == k)
                {
                    return _local_2;
                }
                if (_local_2.negativeCode == k)
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
            return !(Std.downcast(k , ConditionDefinition) == null);
        }

        public function _Str_1196():String
        {
            return "condition";
        }
    }

