package com.sulake.habbo.room.utils
;
    import com.sulake.habbo.room.IRoomAreaSelectionManager;
    import com.sulake.habbo.room.RoomEngine;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.room.events.RoomObjectTileMouseEvent;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualization;
    import com.sulake.habbo.room.object.visualization.room.RoomVisualization;
    import com.sulake.room.events.RoomObjectMouseEvent;
    import com.sulake.room.object.IRoomObject;
    import flash.filters.ColorMatrixFilter;

    /**
     * Wired 2.0 area selection (May RoomAreaSelectionManager): drives the
     * Select Area drag flow for area-based wired selectors. While active, furni
     * render look-through; during selection the room floor highlights the
     * dragged tile rectangle and the result is delivered via callback (x,y,w,h).
     */
     class RoomAreaSelectionManager implements IRoomAreaSelectionManager
    {
        public static var NOT_ACTIVE:Int = 0;
        public static var NOT_SELECTING_AREA:Int = 1;
        public static var AWAITING_MOUSE_DOWN:Int = 2;
        public static var SELECTING:Int = 3;

        static final HIGHLIGHT_FILTERS:ASObject = createHighlightFilters();

        var _roomEngine:RoomEngine;
        var _state:Int = NOT_ACTIVE;
        var _rootX:Int = 0;
        var _rootY:Int = 0;
        var _lastX:Int = 0;
        var _lastY:Int = 0;
        var _highlightRootX:Int = 0;
        var _highlightRootY:Int = 0;
        var _highlightWidth:Int = 0;
        var _highlightHeight:Int = 0;
        var _callback:ASFunction;
        var _highlightType:String = "highlight_brighten";

        public function new(k:RoomEngine)
        {
            this._roomEngine = k;
            this._roomEngine.events.addEventListener(RoomEngineObjectEvent.ADDED, this.onRoomObjectAdded);
        }

        static function createHighlightFilters():ASObject
        {
            var _local_1:ASObject = {};
            var _local_2:Array<ASAny> = [1.5, 0, 0, 0, 0, 0, 1.5, 0, 0, 20, 0, 0, 1.5, 0, 20, 0, 0, 0, 1, 0];
            var _local_3:Array<ASAny> = [1.05, 0, 0, 0, 0, 0, 1.3, 0, 0, 8, 0, 0, 1.8, 0, 20, 0, 0, 0, 1, 0];
            var _local_4:Array<ASAny> = [0.55, 0, 0, 0, -10, 0, 0.55, 0, 0, -10, 0, 0, 0.55, 0, -10, 0, 0, 0, 1, 0];
            _local_1["highlight_brighten"] = [new ColorMatrixFilter((cast _local_2))];
            _local_1["highlight_blue"] = [new ColorMatrixFilter((cast _local_3))];
            _local_1["highlight_darken"] = [new ColorMatrixFilter((cast _local_4))];
            return _local_1;
        }

        function getAllFurnis():Array<ASAny>
        {
            return this._roomEngine.getObjectsByCategory(RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM).concat(this._roomEngine.getObjectsByCategory(RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE));
        }

        public function startSelecting()
        {
            if (this._state == NOT_SELECTING_AREA)
            {
                this.clearHighlightSilent();
                this._state = AWAITING_MOUSE_DOWN;
                this._roomEngine.setMoveBlocked(true);
            }
        }

        public function handleTileMouseEvent(k:RoomObjectTileMouseEvent)
        {
            var _local_2:Int;
            var _local_3:Int;
            var _local_4:Int;
            var _local_5:Int;
            var _local_6= ((this._state == AWAITING_MOUSE_DOWN) && (k.type == RoomObjectMouseEvent.ROE_MOUSE_DOWN));
            if ((k.shiftKey && (this._state == NOT_SELECTING_AREA)) && (k.type == RoomObjectMouseEvent.ROE_MOUSE_DOWN))
            {
                this.startSelecting();
                _local_6 = true;
            }
            if (_local_6)
            {
                this._state = SELECTING;
                this._rootX = k.tileXAsInt;
                this._rootY = k.tileYAsInt;
                this._lastX = k.tileXAsInt;
                this._lastY = k.tileYAsInt;
                this.setHighlight(this._rootX, this._rootY, 1, 1);
            }
            else
            {
                if ((this._state == SELECTING) && (k.type == RoomObjectMouseEvent.ROE_MOUSE_MOVE))
                {
                    if ((!(k.tileXAsInt == this._lastX)) || (!(k.tileYAsInt == this._lastY)))
                    {
                        this._lastX = k.tileXAsInt;
                        this._lastY = k.tileYAsInt;
                        if (this._lastX > this._rootX)
                        {
                            _local_2 = this._rootX;
                            _local_4 = ((this._lastX - this._rootX) + 1);
                        }
                        else
                        {
                            _local_2 = this._lastX;
                            _local_4 = ((this._rootX - this._lastX) + 1);
                        }
                        if (this._lastY > this._rootY)
                        {
                            _local_3 = this._rootY;
                            _local_5 = ((this._lastY - this._rootY) + 1);
                        }
                        else
                        {
                            _local_3 = this._lastY;
                            _local_5 = ((this._rootY - this._lastY) + 1);
                        }
                        this.setHighlight(_local_2, _local_3, _local_4, _local_5);
                    }
                }
            }
        }

        public function finishSelecting():Bool
        {
            if (this._state == SELECTING)
            {
                this._state = NOT_SELECTING_AREA;
                this._roomEngine.setMoveBlocked(false);
                if (this._callback != null)
                {
                    this._callback(this._highlightRootX, this._highlightRootY, this._highlightWidth, this._highlightHeight);
                }
                return true;
            }
            return false;
        }

        function clearHighlightSilent()
        {
            var _local_1:RoomVisualization;
            var _local_2= this._roomEngine.getRoomObject(this._roomEngine.activeRoomId, -1, RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM);
            if (_local_2 != null)
            {
                _local_1 = Std.downcast(_local_2.getVisualization() , RoomVisualization);
                if (_local_1 != null)
                {
                    _local_1.clearHighlightArea();
                }
            }
        }

        public function clearHighlight()
        {
            if (this._state == NOT_ACTIVE)
            {
                return;
            }
            this.clearHighlightSilent();
            this._state = NOT_SELECTING_AREA;
            this._roomEngine.setMoveBlocked(false);
            if (this._callback != null)
            {
                this._callback(0, 0, 0, 0);
            }
        }

        public function setHighlight(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            var _local_5:RoomVisualization;
            if (this._state == NOT_ACTIVE)
            {
                return;
            }
            this._highlightRootX = k;
            this._highlightRootY = _arg_2;
            this._highlightWidth = _arg_3;
            this._highlightHeight = _arg_4;
            var _local_6= this._roomEngine.getRoomObject(this._roomEngine.activeRoomId, -1, RoomObjectCategoryEnum.OBJECT_CATEGORY_ROOM);
            if (_local_6 != null)
            {
                _local_5 = Std.downcast(_local_6.getVisualization() , RoomVisualization);
                if (_local_5 != null)
                {
                    _local_5.initializeHighlightArea(k, _arg_2, _arg_3, _arg_4, HIGHLIGHT_FILTERS[this._highlightType]);
                }
            }
        }

        public function activate(k:ASFunction, _arg_2:String):Bool
        {
            var _local_3:FurnitureVisualization;
            if (this._state != NOT_ACTIVE)
            {
                return false;
            }
            this._callback = k;
            this._highlightType = _arg_2;
            for (_tmp_ in this.getAllFurnis())
            {
var _local_4:IRoomObject  = _tmp_;
                _local_3 = Std.downcast(_local_4.getVisualization() , FurnitureVisualization);
                if (_local_3 != null)
                {
                    _local_3.lookThrough = true;
                }
            }
            this._state = NOT_SELECTING_AREA;
            return true;
        }

        public function deactivate()
        {
            var _local_1:FurnitureVisualization;
            if (this._state == NOT_ACTIVE)
            {
                return;
            }
            this._callback = null;
            for (_tmp_ in this.getAllFurnis())
            {
var _local_2:IRoomObject  = _tmp_;
                _local_1 = Std.downcast(_local_2.getVisualization() , FurnitureVisualization);
                if (_local_1 != null)
                {
                    _local_1.lookThrough = false;
                }
            }
            this.clearHighlight();
            this._state = NOT_ACTIVE;
        }

        function onRoomObjectAdded(k:RoomEngineObjectEvent)
        {
            var _local_2:FurnitureVisualization;
            if (this._state == NOT_ACTIVE)
            {
                return;
            }
            if (k.type != RoomEngineObjectEvent.ADDED)
            {
                return;
            }
            if (k.roomId != this._roomEngine.activeRoomId)
            {
                return;
            }
            if ((!(k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)) && (!(k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)))
            {
                return;
            }
            var _local_3= this._roomEngine.getRoomObject(k.roomId, k.objectId, k.category);
            if (_local_3 != null)
            {
                _local_2 = Std.downcast(_local_3.getVisualization() , FurnitureVisualization);
                if (_local_2 != null)
                {
                    _local_2.lookThrough = true;
                }
            }
        }

        public var areaSelectionState(get,never):Int;
function  get_areaSelectionState():Int
        {
            return this._state;
        }

        public function dispose()
        {
            this.deactivate();
            this._roomEngine.events.removeEventListener(RoomEngineObjectEvent.ADDED, this.onRoomObjectAdded);
        }
    }

