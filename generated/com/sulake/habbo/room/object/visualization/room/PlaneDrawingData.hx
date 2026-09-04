package com.sulake.habbo.room.object.visualization.room
;
    import com.sulake.room.object.visualization.IPlaneDrawingData;
    import flash.geom.Point;

     class PlaneDrawingData implements IPlaneDrawingData 
    {
        var _z:Float = Math.NaN;
        var _points:Vector<Point>;
        var _color:UInt = 0;
        var _maskAssetNames:Array<ASAny>;
        var _maskAssetLocations:Array<ASAny>;
        var _maskAssetFlipHs:Array<ASAny>;
        var _maskAssetFlipVs:Array<ASAny>;
        var _alignBottom:Bool = false;
        var _assetNames:Array<ASAny>;

        public function new(k:PlaneDrawingData=null, _arg_2:UInt=0, _arg_3:Bool=false)
        {
            this._assetNames = [];
            this._maskAssetNames = [];
            this._maskAssetLocations = [];
            this._maskAssetFlipHs = [];
            this._maskAssetFlipVs = [];
            if (k != null)
            {
                this._maskAssetNames = k._maskAssetNames;
                this._maskAssetLocations = k._maskAssetLocations;
                this._maskAssetFlipHs = k._maskAssetFlipHs;
                this._maskAssetFlipVs = k._maskAssetFlipVs;
            }
            this._color = _arg_2;
            this._alignBottom = _arg_3;
        }

        public function addMask(k:String, _arg_2:Point, _arg_3:Bool, _arg_4:Bool)
        {
            this._maskAssetNames.push(k);
            this._maskAssetLocations.push(_arg_2);
            this._maskAssetFlipHs.push(_arg_3);
            this._maskAssetFlipVs.push(_arg_4);
        }

        public function _Str_22862(k:Array<ASAny>)
        {
            this._assetNames.push(k);
        }

        
        public var z(get,set):Float;
function  set_z(k:Float):Float        {
            return this._z = k;
        }
function  get_z():Float
        {
            return this._z;
        }

        
        public var cornerPoints(get,set):Vector<Point>;
function  set_cornerPoints(k:Vector<Point>):Vector<Point>        {
            return this._points = k;
        }
function  get_cornerPoints():Vector<Point>
        {
            return this._points;
        }

        public var color(get,never):UInt;
function  get_color():UInt
        {
            return this._color;
        }

        public var maskAssetNames(get,never):Array<ASAny>;
function  get_maskAssetNames():Array<ASAny>
        {
            return this._maskAssetNames;
        }

        public var maskAssetLocations(get,never):Array<ASAny>;
function  get_maskAssetLocations():Array<ASAny>
        {
            return this._maskAssetLocations;
        }

        public var maskAssetFlipHs(get,never):Array<ASAny>;
function  get_maskAssetFlipHs():Array<ASAny>
        {
            return this._maskAssetFlipHs;
        }

        public var maskAssetFlipVs(get,never):Array<ASAny>;
function  get_maskAssetFlipVs():Array<ASAny>
        {
            return this._maskAssetFlipVs;
        }

        public function isBottomAligned():Bool
        {
            return this._alignBottom;
        }

        public var assetNameColumns(get,never):Array<ASAny>;
function  get_assetNameColumns():Array<ASAny>
        {
            return this._assetNames;
        }
    }

