package com.sulake.habbo.inventory.effects
;
    import com.sulake.habbo.ui.widget.memenu.IWidgetAvatarEffect;
    import com.sulake.habbo.inventory.IThumbListDrawableItem;
    import com.sulake.habbo.avatar.IHabboAvatarEditorAvatarEffect;
    import com.sulake.habbo.inventory.IAvatarEffect;
    import flash.display.BitmapData;

     class Effect implements IWidgetAvatarEffect implements  IThumbListDrawableItem implements  IHabboAvatarEditorAvatarEffect implements  IAvatarEffect 
    {
        var _type:Int = 0;
        var _subType:Int = 0;
        var _duration:Int = 0;
        var _effectsInInventory:Int = 1;
        var _secondsLeftStamped:Int = 0;
        var _permanent:Bool = false;
        var _isActive:Bool = false;
        var _isSelected:Bool = false;
        var _isInUse:Bool = false;
        var _iconImage:BitmapData;
        var _activatedTimeStamp:Date;


        
        public var type(get,set):Int;
public function  get_type():Int
        {
            return this._type;
        }

        
        public var subType(get,set):Int;
public function  get_subType():Int
        {
            return this._subType;
        }

        
        public var duration(get,set):Int;
public function  get_duration():Int
        {
            return this._duration;
        }

        
        public var amount(get,set):Int;
public function  get_amount():Int
        {
            return this._effectsInInventory;
        }

        
        public var isPermanent(get,set):Bool;
public function  get_isPermanent():Bool
        {
            return this._permanent;
        }

        
        public var isActive(get,set):Bool;
public function  get_isActive():Bool
        {
            return this._isActive;
        }

        
        public var isInUse(get,set):Bool;
public function  get_isInUse():Bool
        {
            return this._isInUse;
        }

        
        public var Selected(get,set):Bool;
public function  get_Selected():Bool
        {
            return this._isSelected;
        }

        
        public var icon(get,set):BitmapData;
public function  get_icon():BitmapData
        {
            return this._iconImage;
        }

        
        public var secondsRemaining(get,set):Int;
public function  get_secondsRemaining():Int
        {
            var k = 0;
            if (this._isActive)
            {
                k = Std.int(this._secondsLeftStamped - ((Date.now().getTime() - this._activatedTimeStamp.getTime()) / 1000));
                k = Std.int(Math.ffloor(k));
                if (k < 0)
                {
                    k = 0;
                }
                return k;
            }
            return this._secondsLeftStamped;
        }
public function  set_type(k:Int):Int        {
            return this._type = k;
        }
public function  set_subType(k:Int):Int        {
            return this._subType = k;
        }
public function  set_duration(k:Int):Int        {
            return this._duration = k;
        }
public function  set_secondsRemaining(k:Int):Int        {
            return this._secondsLeftStamped = k;
        }
public function  set_isPermanent(k:Bool):Bool        {
            return this._permanent = k;
        }
public function  set_Selected(k:Bool):Bool        {
            return this._isSelected = k;
        }
public function  set_isInUse(k:Bool):Bool        {
            return this._isInUse = k;
        }
public function  set_icon(k:BitmapData):BitmapData        {
            return this._iconImage = k;
        }
public function  set_amount(k:Int):Int        {
            return this._effectsInInventory = k;
        }
public function  set_isActive(k:Bool):Bool        {
            if ((k && (!this._isActive)))
            {
                this._activatedTimeStamp = Date.now();
            }
            return this._isActive = k;
        }

        public function _Str_24370()
        {
            this._effectsInInventory--;
            if (this._effectsInInventory < 0)
            {
                this._effectsInInventory = 0;
            }
            this._secondsLeftStamped = this._duration;
            this._isActive = false;
            this._isInUse = false;
        }
public function new(){}
    }

