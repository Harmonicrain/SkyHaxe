package com.sulake.habbo.roomevents.userdefinedroomevents
;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualization;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.userdefinedroomevents.binaryData.SelectionShader;
    import com.sulake.room.object.IRoomObject;
    import flash.display.Shader;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.GlowFilter;
    import flash.filters.ShaderFilter;

     class UserDefinedRoomEventsVisualizer
    {
        var _userDefinedRoomEvents:HabboUserDefinedRoomEvents;
        var _filterBW:Array<ASAny>;
        var _filterBWWall:Array<ASAny>;
        var _activeWiredFilter:Array<ASAny>;
        var _dualPicking1Filter:Array<ASAny>;
        var _dualPicking2Filter:Array<ASAny>;

        public function new(k:HabboUserDefinedRoomEvents)
        {
            var shaderClass:Class<Dynamic> = null;
            var shader:Shader = null;
            var shaderFilter:ShaderFilter = null;
            var tint:Float = 154;
            var strength= 0.75;
            var greenOffset= 25.5;
            var blueOffset= 25.5;
            var bwMatrix:Array<ASAny> = [
                1 - strength, 0, 0, 0, strength * tint,
                0, 1 - strength, 0, 0, strength * tint + greenOffset,
                0, 0, 1 - strength, 0, strength * tint + blueOffset,
                0, 0, 0, 1, 0
            ];
            var activeMatrix:Array<ASAny> = [
                0.9, 0, 0, 0, 0,
                0, 1, 0, 0, 40,
                0, 0, 1, 0, 80,
                0, 0, 0, 0.8, 0
            ];
            var dual1Matrix:Array<ASAny> = [
                1.13, 0, 0, 0, 35,
                0, 1.13, 0, 0, 35,
                0, 0, 1, 0, 0,
                0, 0, 0, 1, 0
            ];
            var dual2Matrix:Array<ASAny> = [
                1, 0, 0, 0, 0,
                0, 1, 0, 0, 0,
                0, 0, 1.15, 0, 40,
                0, 0, 0, 1, 0
            ];

            this._userDefinedRoomEvents = k;
            shaderClass = SelectionShader;
            shader = new Shader(ASCompat.asByteArray(Type.createInstance(shaderClass, []) ));
            shaderFilter = new ShaderFilter(shader);
            this._filterBW = [new ColorMatrixFilter((cast bwMatrix)), shaderFilter];
            this._filterBWWall = [new ColorMatrixFilter((cast bwMatrix)), shaderFilter, new GlowFilter(0xFFFFFF, 1, 5, 5, 3, 1, true, false)];
            this._activeWiredFilter = [new ColorMatrixFilter((cast activeMatrix))];
            this._dualPicking1Filter = [new ColorMatrixFilter((cast dual1Matrix))];
            this._dualPicking2Filter = [new ColorMatrixFilter((cast dual2Matrix))];
        }

        public static function addFiltersToFurni(k:IRoomObject, filters:Array<ASAny>, prepend:Bool = false)
        {
            if ((k == null) || hasFilters(k, filters))
            {
                return;
            }
            var visualization= Std.downcast(k.getVisualization() , FurnitureVisualization);
            if (visualization == null)
            {
                return;
            }
            var current= (visualization.filters == null) ? [] : visualization.filters.slice(0);
            visualization.filters = prepend ? filters.concat(current) : current.concat(filters);
        }

        public static function removeFiltersFromFurni(k:IRoomObject, filters:Array<ASAny>)
        {
var filter:ASObject  = null;            var index = 0;
            if (k == null)
            {
                return;
            }
            var visualization= Std.downcast(k.getVisualization() , FurnitureVisualization);
            if ((visualization == null) || (visualization.filters == null))
            {
                return;
            }
            var current= visualization.filters.slice(0);
            if (checkNullIteratee(filters)) for (_tmp_ in filters)
            {
filter = _tmp_;
                index = current.indexOf(filter);
                if (index != -1)
                {
                    current.splice(index, 1);
                }
            }
            visualization.filters = (current.length == 0) ? null : current;
        }

        public static function hasFilters(k:IRoomObject, filters:Array<ASAny>):Bool
        {
var filter:ASObject  = null;            if (k == null)
            {
                return false;
            }
            var visualization= Std.downcast(k.getVisualization() , FurnitureVisualization);
            if ((visualization == null) || (visualization.filters == null))
            {
                return false;
            }
            var current= visualization.filters;
            if (checkNullIteratee(filters)) for (_tmp_ in filters)
            {
filter = _tmp_;
                if (current.indexOf(filter) != -1)
                {
                    return true;
                }
            }
            return false;
        }

        public function hide(k:Int, dual:Bool = false, pickSet:Int = 0)
        {
            this.inactivateFurni(this.getFurni(k), k < 0, dual, pickSet);
        }

        public function _Str_21701(k:ASDictionary<ASAny,ASAny>, dual:Bool = false, pickSet:Int = 0)
        {
            this.hideAll(k, dual, pickSet);
        }

        public function hideAll(k:ASDictionary<ASAny,ASAny>, dual:Bool, pickSet:Int)
        {
var key:String  = null;            var id = 0;
            if (checkNullIteratee(k)) for (_tmp_ in k.keys())
            {
key = _tmp_;
                id = ASCompat.parseInt(key);
                this.inactivateFurni(this.getFurni(id), id < 0, dual, pickSet);
            }
        }

        public function show(k:Int, dual:Bool = false, pickSet:Int = 0)
        {
            this.activateFurni(this.getFurni(k), k < 0, dual, pickSet);
        }

        public function _Str_25313(k:ASDictionary<ASAny,ASAny>, dual:Bool = false, pickSet:Int = 0)
        {
            this.showAll(k, dual, pickSet);
        }

        public function showAll(k:ASDictionary<ASAny,ASAny>, dual:Bool, pickSet:Int)
        {
var key:String  = null;            var id = 0;
            if (checkNullIteratee(k)) for (_tmp_ in k.keys())
            {
key = _tmp_;
                id = ASCompat.parseInt(key);
                this.activateFurni(this.getFurni(id), id < 0, dual, pickSet);
            }
        }

        public function highlightActiveWired(k:Int)
        {
            addFiltersToFurni(this.getFurni(k), this._activeWiredFilter);
        }

        public function unhighlightActiveWired(k:Int)
        {
            removeFiltersFromFurni(this.getFurni(k), this._activeWiredFilter);
        }

        function getFurni(k:Int):IRoomObject
        {
            if (k < 0)
            {
                return this._userDefinedRoomEvents.roomEngine.getRoomObject(this._userDefinedRoomEvents.roomId, -k, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            }
            return this._userDefinedRoomEvents.roomEngine.getRoomObject(this._userDefinedRoomEvents.roomId, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
        }

        function activateFurni(k:IRoomObject, isWall:Bool, dual:Bool, pickSet:Int)
        {
            addFiltersToFurni(k, isWall ? this._filterBWWall : this._filterBW, true);
            if (dual)
            {
                addFiltersToFurni(k, pickSet == 1 ? this._dualPicking1Filter : this._dualPicking2Filter);
            }
        }

        function inactivateFurni(k:IRoomObject, isWall:Bool, dual:Bool, pickSet:Int)
        {
            removeFiltersFromFurni(k, isWall ? this._filterBWWall : this._filterBW);
            if (dual)
            {
                removeFiltersFromFurni(k, pickSet == 1 ? this._dualPicking1Filter : this._dualPicking2Filter);
                if (hasFilters(k, pickSet == 1 ? this._dualPicking2Filter : this._dualPicking1Filter))
                {
                    addFiltersToFurni(k, isWall ? this._filterBWWall : this._filterBW, true);
                }
            }
        }
    }

