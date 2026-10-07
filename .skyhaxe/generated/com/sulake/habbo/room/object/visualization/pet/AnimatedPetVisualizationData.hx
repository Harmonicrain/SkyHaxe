package com.sulake.habbo.room.object.visualization.pet
;
    import com.sulake.habbo.room.object.visualization.furniture.AnimatedFurnitureVisualizationData;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.room.object.visualization.data.SizeData;
    import com.sulake.habbo.room.object.visualization.data.AnimationSizeData;

     class AnimatedPetVisualizationData extends AnimatedFurnitureVisualizationData 
    {
        var _commonAssets:IAssetLibrary = null;
        var _isAllowedToTurnHead:Bool = true;


        
        public var _Str_14822(get,set):IAssetLibrary;
public function  set__Str_14822(k:IAssetLibrary):IAssetLibrary        {
            return this._commonAssets = k;
        }
public function  get__Str_14822():IAssetLibrary
        {
            return this._commonAssets;
        }

        override function defineVisualizations(k:com.sulake.core.utils.xml.XML):Bool
        {
            this._isAllowedToTurnHead = (k.child("graphics").hasOwnProperty("@disableheadturn") ? (!com.sulake.core.utils.xml.XML.equalsStringOperands(k.child("graphics").attribute("disableheadturn") , "1")) : true);
            return super.defineVisualizations(k);
        }

        override function createSizeData(k:Int, _arg_2:Int, _arg_3:Int):SizeData
        {
            var _local_4:SizeData = null;
            if (k > 1)
            {
                _local_4 = new PetAnimationSizeData(_arg_2, _arg_3);
            }
            else
            {
                _local_4 = new AnimationSizeData(_arg_2, _arg_3);
            }
            return _local_4;
        }

        override function processVisualizationElement(k:SizeData, _arg_2:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_3:PetAnimationSizeData = null;
            if (((k == null) || (_arg_2 == null)))
            {
                return false;
            }
            switch (ASCompat.toString(_arg_2.name()))
            {
                case "postures":
                    _local_3 = Std.downcast(k , PetAnimationSizeData);
                    if (_local_3 != null)
                    {
                        if (!_local_3.definePostures(_arg_2))
                        {
                            return false;
                        }
                    }
                    
                case "gestures":
                    _local_3 = Std.downcast(k , PetAnimationSizeData);
                    if (_local_3 != null)
                    {
                        if (!_local_3.defineGestures(_arg_2))
                        {
                            return false;
                        }
                    }
                    
                default:
                    if (!super.processVisualizationElement(k, _arg_2))
                    {
                        return false;
                    }
            }
            return true;
        }

        public function _Str_17648(k:Int, _arg_2:String):Int
        {
            var _local_3= Std.downcast(getSizeData(k) , PetAnimationSizeData);
            if (_local_3 != null)
            {
                return _local_3._Str_17648(_arg_2);
            }
            return PetAnimationSizeData.ANIMATION_NOT_DEFINED_ID;
        }

        public function _Str_18284(k:Int, _arg_2:String):Bool
        {
            var _local_3= Std.downcast(getSizeData(k) , PetAnimationSizeData);
            if (_local_3 != null)
            {
                return _local_3._Str_18284(_arg_2);
            }
            return false;
        }

        public function _Str_18268(k:Int, _arg_2:String):Int
        {
            var _local_3= Std.downcast(getSizeData(k) , PetAnimationSizeData);
            if (_local_3 != null)
            {
                return _local_3._Str_18268(_arg_2);
            }
            return PetAnimationSizeData.ANIMATION_NOT_DEFINED_ID;
        }

        public function _Str_14207(k:Int, _arg_2:Int, _arg_3:Bool):String
        {
            var _local_4= Std.downcast(getSizeData(k) , PetAnimationSizeData);
            if (_local_4 != null)
            {
                return _local_4._Str_14207(_arg_2, _arg_3);
            }
            return null;
        }

        public function _Str_17844(k:Int, _arg_2:Int):String
        {
            var _local_3= Std.downcast(getSizeData(k) , PetAnimationSizeData);
            if (_local_3 != null)
            {
                return _local_3._Str_17844(_arg_2);
            }
            return null;
        }

        public function _Str_17976(k:Int, _arg_2:Int):String
        {
            var _local_3= Std.downcast(getSizeData(k) , PetAnimationSizeData);
            return (_local_3 == null) ? null : _local_3._Str_17976(_arg_2);
        }

        public function _Str_17398(k:Int):Int
        {
            var _local_2= Std.downcast(getSizeData(k) , PetAnimationSizeData);
            if (_local_2 != null)
            {
                return _local_2._Str_17398();
            }
            return 0;
        }

        public function _Str_16869(k:Int):Int
        {
            var _local_2= Std.downcast(getSizeData(k) , PetAnimationSizeData);
            if (_local_2 != null)
            {
                return _local_2._Str_16869();
            }
            return 0;
        }

        public var isAllowedToTurnHead(get,never):Bool;
public function  get_isAllowedToTurnHead():Bool
        {
            return this._isAllowedToTurnHead;
        }

	public function new() { super(); }
    }

