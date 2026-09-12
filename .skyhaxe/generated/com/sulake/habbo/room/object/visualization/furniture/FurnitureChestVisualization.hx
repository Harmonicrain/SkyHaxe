package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureChestVisualization extends FurnitureAnimatedVisualization
    {
        static inline final WIRED_EMBLEM_SPRITE_TAG= "wired_emblem";

        var _isWiredEnabled:Bool = false;

        override function updateModel(scale:Float):Bool
        {
            var changed= super.updateModel(scale);
            if (object == null || object.getModel() == null)
            {
                return changed;
            }

            var isWiredEnabled= object.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_CHEST_IS_WIRED_ENABLED) == 1;
            if (isWiredEnabled != this._isWiredEnabled)
            {
                this._isWiredEnabled = isWiredEnabled;
                changed = true;
            }
            return changed;
        }

        override function getSpriteAlpha(size:Int, direction:Int, spriteIndex:Int):Int
        {
            if (!this._isWiredEnabled && getSpriteTag(size, direction, spriteIndex) == WIRED_EMBLEM_SPRITE_TAG)
            {
                return 0;
            }
            return super.getSpriteAlpha(size, direction, spriteIndex);
        }

	public function new() { super(); }
    }

