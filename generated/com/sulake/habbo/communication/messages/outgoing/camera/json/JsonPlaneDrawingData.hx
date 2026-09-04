package com.sulake.habbo.communication.messages.outgoing.camera.json
;

     class JsonPlaneDrawingData 
    {
        var _z:Float = Math.NaN;
        var _points:Vector<JsonPoint>;
        var _color:UInt = 0;
        var _masks:Array<ASAny>;
        var _isBottomAligned:Bool = false;
        var _texCols:Array<ASAny>;

        public function new()
        {
            this._points = new Vector<JsonPoint>();
            this._masks = [];
            this._texCols = [];
        }

        
        public var z(get,set):Float;
function  get_z():Float
        {
            return this._z;
        }
function  set_z(k:Float):Float        {
            return this._z = k;
        }

        public var cornerPoints(get,never):Vector<JsonPoint>;
function  get_cornerPoints():Vector<JsonPoint>
        {
            return this._points;
        }

        public function addCornerPoint(k:Int, _arg_2:Int)
        {
            this._points.push(new JsonPoint(k, _arg_2));
        }

        public var masks(get,never):Array<ASAny>;
function  get_masks():Array<ASAny>
        {
            return this._masks;
        }

        public function addMask(k:JsonMaskDrawingData)
        {
            this._masks.push(k);
        }

        
        public var color(get,set):UInt;
function  get_color():UInt
        {
            return this._color;
        }
function  set_color(k:UInt):UInt        {
            return this._color = k;
        }

        public var bottomAligned(get,never):Bool;
function  get_bottomAligned():Bool
        {
            return this._isBottomAligned;
        }

        public function setBottomAligned(k:Bool)
        {
            this._isBottomAligned = k;
        }

        public var texCols(get,never):Array<ASAny>;
function  get_texCols():Array<ASAny>
        {
            return this._texCols;
        }

        public function addTexCol(k:JsonTextureColumnData)
        {
            this._texCols.push(k);
        }
    }

