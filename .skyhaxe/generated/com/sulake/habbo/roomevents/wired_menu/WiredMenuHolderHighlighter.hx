package com.sulake.habbo.roomevents.wired_menu
;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualization;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectController;
    import flash.filters.ColorMatrixFilter;
    import flash.filters.GlowFilter;

    /** Room-object highlighting used by July's variable overview. */
     final class WiredMenuHolderHighlighter
    {
        var _roomEvents:HabboUserDefinedRoomEvents;
        var _filters:Array<ASAny>;
        var _furniIds:Array<ASAny> = [];
        var _userIds:Array<ASAny> = [];

        public function new(
            roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._filters = [
                new ColorMatrixFilter([
                    0.9, 0, 0, 0, 0,
                    0, 1, 0, 0, 40,
                    0, 0, 1, 0, 80,
                    0, 0, 0, 0.85, 0
                ]),
                new GlowFilter(12318714, 1, 4, 4, 4, 1, true, false)
            ];
        }

        public function show(target:Int, holderIds:Array<ASAny>)
        {
var holderId = 0;            this.clear();
            if (holderIds == null || holderIds.length > 200)
            {
                return;
            }
            if (checkNullIteratee(holderIds)) for (_tmp_ in holderIds)
            {
holderId = ASCompat.toInt(_tmp_);
                if (target == 0)
                {
                    this.highlightFurni(holderId);
                }
                else if (target == 1)
                {
                    this.highlightUser(holderId);
                }
            }
        }

        function highlightFurni(id:Int)
        {
var filter:ASObject  = null;            var category= id < 0 ? 20 : 10;
            var objectId= id < 0 ? -id : id;
            var object= this._roomEvents.roomEngine.getRoomObject(
                this._roomEvents.roomId, objectId, category);
            var visualization:FurnitureVisualization = object == null ? null :
                Std.downcast(object.getVisualization() , FurnitureVisualization);
            if (visualization == null)
            {
                return;
            }
            var filters=
                visualization.filters == null ? [] :
                visualization.filters.slice(0);
            final _iter_ = this._filters; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
filter = _tmp_;
                if (filters.indexOf(filter) < 0)
                {
                    filters.push(filter);
                }
            }
            visualization.filters = filters;
            this._furniIds.push(id);
        }

        function highlightUser(id:Int)
        {
            var object= this._roomEvents.roomEngine.getRoomObject(
                this._roomEvents.roomId, id, 100);
            if (object == null)
            {
                return;
            }
            Std.downcast(object , IRoomObjectController).getModelController().setNumber(
                "figure_highlight_variable_holder", 1);
            this._userIds.push(id);
        }

        public function clear()
        {
var id = 0, category = 0, objectId = 0, object:IRoomObject  = null, visualization:FurnitureVisualization  = null, filters:Array<ASAny>  = null, filter:ASObject  = null, index = 0;            final _iter_ = this._furniIds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
id = ASCompat.toInt(_tmp_);
category= id < 0 ? 20 : 10;
objectId= id < 0 ? -id : id;
object=
                    this._roomEvents.roomEngine.getRoomObject(
                        this._roomEvents.roomId, objectId, category);
visualization=
                    object == null ? null :
                    Std.downcast(object.getVisualization() , FurnitureVisualization);
                if (visualization != null && visualization.filters != null)
                {
filters= visualization.filters.slice(0);
                    final _iter_ = this._filters; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
filter = _tmp_;
index= filters.indexOf(filter);
                        if (index >= 0)
                        {
                            filters.splice(index, 1);
                        }
                    }
                    visualization.filters = filters;
                }
            }
            final _iter_ = this._userIds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
id  = ASCompat.toInt(_tmp_);
                object = this._roomEvents.roomEngine.getRoomObject(
                    this._roomEvents.roomId, id, 100);
                if (object != null)
                {
                    Std.downcast(object , IRoomObjectController).getModelController()
                        .setNumber("figure_highlight_variable_holder", 0);
                }
            }
            this._furniIds = [];
            this._userIds = [];
        }

        public function dispose()
        {
            this.clear();
            this._roomEvents = null;
            this._filters = null;
        }
    }

