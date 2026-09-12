package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.filters.GlowFilter;

     class FurnitureFurniChestVisualization extends FurnitureChestVisualization
    {
        static inline final FLOATING_ICON_TAG_PREFIX= "floating_icon_";
        static inline final MAX_FLOATING_ICONS= 4;
        static inline final FLOATING_PIXELS= 2;
        static inline final FLOAT_STEP_MILLISECONDS= 300;
        static final FLOATING_ICON_GLOW_FILTER:Array<ASAny> = [new GlowFilter(0xFFFFFF, 1, 2, 2, 10, 1, false, false)];
        static final ICON_POSITIONING:Array<ASAny> = [
            ([] : Array<Dynamic>),
            ([([0, -68, 17, 17] : Array<Dynamic>)] : Array<Dynamic>),
            ([([16, -70, 4, 4] : Array<Dynamic>), ([-14, -59, 4, 4] : Array<Dynamic>)] : Array<Dynamic>),
            ([([12, -52, 2, 2] : Array<Dynamic>), ([-17, -70, 3, 2] : Array<Dynamic>), ([17, -87, 7, 2] : Array<Dynamic>)] : Array<Dynamic>),
            ([([14, -50, 2, 2] : Array<Dynamic>), ([-14, -59, 2, 2] : Array<Dynamic>), ([19, -78, 4, 2] : Array<Dynamic>), ([-20, -90, 4, 2] : Array<Dynamic>)] : Array<Dynamic>)
        ];

        var _iconAssets:Vector<IGraphicAsset>;
        var _lastAssetsString:String = "";
        var _assetNames__com_sulake_habbo_room_object_visualization_furniture_FurnitureFurniChestVisualization/*redefined private*/:Array<ASAny> = [];
        var _flippedLayout:Bool = false;
        var _iconData:Array<ASAny> = [];
        var _floatStep:Int = 0;
        var _lastFloatUpdate:Int = -1;
        var _lastUpdateTime:Int = -1000;

        override public function update(geometry:IRoomGeometry, time:Int, update:Bool, skipAnimation:Bool)
        {
            if (time < this._lastUpdateTime + 41)
            {
                return;
            }
            this._lastUpdateTime += 41;
            if (this._lastUpdateTime + 41 < time)
            {
                this._lastUpdateTime = time - 41;
            }
            super.update(geometry, time, update, skipAnimation);
        }

        override function updateModel(scale:Float):Bool
        {
            var changed= super.updateModel(scale);
            if (object == null || object.getModel() == null)
            {
                return changed;
            }

            var assetsString= object.getModel().getString(RoomObjectVariableEnum.FURNITURE_FURNI_CHEST_SHOWN_ASSET_NAMES);
            if (assetsString == null || scale != 64)
            {
                assetsString = "";
            }
            if (this._lastAssetsString != assetsString)
            {
                this._lastAssetsString = assetsString;
                this._assetNames__com_sulake_habbo_room_object_visualization_furniture_FurnitureFurniChestVisualization = assetsString.length == 0 ? [] : (cast assetsString.split(","));
                this.createIconAssets();
                changed = true;
            }
            return changed;
        }

        override function updateObject(scale:Float, cameraAngle:Float):Bool
        {
            var changed= super.updateObject(scale, cameraAngle);
            if (this._lastUpdateTime - this._lastFloatUpdate > FLOAT_STEP_MILLISECONDS)
            {
                changed = true;
                this._lastFloatUpdate = this._lastUpdateTime;
                this._floatStep++;
                if (this._floatStep >= FLOATING_PIXELS * 2)
                {
                    this._floatStep = 0;
                }
            }
            return changed;
        }

        override function getAdditionalSpriteCount():Int
        {
            return super.getAdditionalSpriteCount() + MAX_FLOATING_ICONS;
        }

        override function getSpriteAssetName(size:Int, spriteIndex:Int):String
        {
            if (!this.isFloatingIcon(spriteIndex) || size != 64)
            {
                return super.getSpriteAssetName(size, spriteIndex);
            }
            var iconIndex= spriteIndex - spriteCount + MAX_FLOATING_ICONS;
            if (iconIndex < 0 || iconIndex >= this._assetNames__com_sulake_habbo_room_object_visualization_furniture_FurnitureFurniChestVisualization.length)
            {
                return super.getSpriteAssetName(size, spriteIndex);
            }
            return this._assetNames__com_sulake_habbo_room_object_visualization_furniture_FurnitureFurniChestVisualization[iconIndex];
        }

        function isFloatingIcon(spriteIndex:Int):Bool
        {
            var iconIndex= spriteIndex - spriteCount + MAX_FLOATING_ICONS;
            return iconIndex >= 0 && iconIndex < this._iconData.length;
        }

        override function reset()
        {
            super.reset();
            this.clearIconAssets();
            this._iconData = [];
            this._assetNames__com_sulake_habbo_room_object_visualization_furniture_FurnitureFurniChestVisualization = [];
            this._lastAssetsString = "";
        }

        function clearIconAssets()
        {
            this._iconAssets = null;
        }

        function createIconAssets()
        {
var iconIndex = 0, assetName:String  = null, asset:IGraphicAsset  = null, positioning:Array<ASAny>  = null, x = 0, y = 0, flip = false, width = 0, height = 0, alpha = Math.NaN, z = Math.NaN;            this._iconAssets = new Vector<IGraphicAsset>();
            this._iconData = [];
            this._flippedLayout = Math.random() < 0.5;
            this._floatStep = 0;
            this._lastFloatUpdate = this._lastUpdateTime;

            var iconCount= Std.int(Math.min(MAX_FLOATING_ICONS, this._assetNames__com_sulake_habbo_room_object_visualization_furniture_FurnitureFurniChestVisualization.length));
            for (_tmp_ in 0...iconCount)
            {
iconIndex= _tmp_;
assetName= this._assetNames__com_sulake_habbo_room_object_visualization_furniture_FurnitureFurniChestVisualization[iconIndex];
asset= assetCollection == null || assetName == null || assetName == "" ? null : assetCollection.getAsset(assetName);
                this._iconAssets.push(asset);
positioning= ICON_POSITIONING[iconCount][iconIndex];
x= ASCompat.toInt(ASCompat.toNumber(positioning[0] + Math.random() * ASCompat.toNumber(positioning[2] + 1)) - ASCompat.toNumber(positioning[2]) / 2);
y= ASCompat.toInt(ASCompat.toNumber(positioning[1] + Math.random() * ASCompat.toNumber(positioning[3] + 1)) - ASCompat.toNumber(positioning[3]) / 2);
flip= Math.random() < 0.5;
width= asset == null ? 0 : asset.width;
height= asset == null ? 0 : asset.height;
alpha= this.calculateAlphaForYOffset(y);
z= 0.001 + y / 10000;
                this._iconData.push(([x, y, flip, width, height, alpha, z, 0] : Array<Dynamic>));
            }
        }

        function calculateAlphaForYOffset(y:Int):Float
        {
            var progress= (y - -40) / (-100 - -40);
            var alpha= 0.9 + (0.4 - 0.9) * progress;
            return Math.min(Math.max(alpha, 0.4), 0.9);
        }

        override function getAsset(name:String, spriteIndex:Int=-1):IGraphicAsset
        {
var iconIndex = 0;            if (this.isFloatingIcon(spriteIndex))
            {
iconIndex= spriteIndex - spriteCount + MAX_FLOATING_ICONS;
                if (this._iconAssets == null)
                {
                    this.createIconAssets();
                }
                if (iconIndex < this._iconAssets.length && this._iconAssets[iconIndex] != null)
                {
                    return this._iconAssets[iconIndex];
                }
            }
            return super.getAsset(name, spriteIndex);
        }

        override function getSpriteTag(size:Int, direction:Int, spriteIndex:Int):String
        {
            if (this.isFloatingIcon(spriteIndex))
            {
                return FLOATING_ICON_TAG_PREFIX + Std.string(spriteIndex - spriteCount + MAX_FLOATING_ICONS);
            }
            return super.getSpriteTag(size, direction, spriteIndex);
        }

        override function getSpriteAlpha(size:Int, direction:Int, spriteIndex:Int):Int
        {
            var alpha= super.getSpriteAlpha(size, direction, spriteIndex);
            if (this.isFloatingIcon(spriteIndex))
            {
                return Std.int(ASCompat.toNumber(this._iconData[spriteIndex - spriteCount + MAX_FLOATING_ICONS][5]) * alpha);
            }
            return alpha;
        }

        override function getSpriteMouseCapture(size:Int, direction:Int, spriteIndex:Int):Bool
        {
            return this.isFloatingIcon(spriteIndex) ? false : super.getSpriteMouseCapture(size, direction, spriteIndex);
        }

        override function getSpriteXOffset(size:Int, direction:Int, spriteIndex:Int):Int
        {
var iconIndex = 0, directionFlipped = false, x = 0, width = 0;            if (this.isFloatingIcon(spriteIndex))
            {
iconIndex= spriteIndex - spriteCount + MAX_FLOATING_ICONS;
directionFlipped= direction / 2 % 2 == 1;
x= ASCompat.toInt(this._iconData[iconIndex][0]);
width= ASCompat.toInt(this._iconData[iconIndex][3]);
                if (this._flippedLayout != directionFlipped)
                {
                    x = -x;
                }
                return Std.int(x - width / 2);
            }
            return super.getSpriteXOffset(size, direction, spriteIndex);
        }

        override function getSpriteYOffset(size:Int, direction:Int, spriteIndex:Int):Int
        {
var iconIndex = 0, y = 0, height = 0, phase = 0, bob = 0;            if (this.isFloatingIcon(spriteIndex))
            {
iconIndex= spriteIndex - spriteCount + MAX_FLOATING_ICONS;
y= ASCompat.toInt(this._iconData[iconIndex][1]);
height= ASCompat.toInt(this._iconData[iconIndex][4]);
phase= ASCompat.toInt(this._iconData[iconIndex][7]);
bob= (this._floatStep + phase) % (FLOATING_PIXELS * 2);
                if (bob > FLOATING_PIXELS)
                {
                    bob = FLOATING_PIXELS - (bob - FLOATING_PIXELS);
                }
                return Std.int(y + height / 2 - bob);
            }
            return super.getSpriteYOffset(size, direction, spriteIndex);
        }

        override function getSpriteZOffset(size:Int, direction:Int, spriteIndex:Int):Float
        {
            if (this.isFloatingIcon(spriteIndex))
            {
                return ASCompat.toNumber(this._iconData[spriteIndex - spriteCount + MAX_FLOATING_ICONS][6]);
            }
            return super.getSpriteZOffset(size, direction, spriteIndex);
        }

        override function getSpriteInk(size:Int, direction:Int, spriteIndex:Int):Int
        {
            return this.isFloatingIcon(spriteIndex) ? 0 : super.getSpriteInk(size, direction, spriteIndex);
        }

        override function getSpriteFilters(size:Int, direction:Int, spriteIndex:Int):Array<ASAny>
        {
            return this.isFloatingIcon(spriteIndex) ? FLOATING_ICON_GLOW_FILTER : super.getSpriteFilters(size, direction, spriteIndex);
        }

        override function getSpriteFlipH(size:Int, direction:Int, spriteIndex:Int):Bool
        {
var iconIndex = 0, directionFlipped = false, iconFlip = false;            if (this.isFloatingIcon(spriteIndex))
            {
iconIndex= spriteIndex - spriteCount + MAX_FLOATING_ICONS;
directionFlipped= direction / 2 % 2 == 1;
iconFlip= ASCompat.toBool(this._iconData[iconIndex][2]);
                return (this._flippedLayout != directionFlipped) != iconFlip;
            }
            return super.getSpriteFlipH(size, direction, spriteIndex);
        }

	public function new() { super(); }
    }

