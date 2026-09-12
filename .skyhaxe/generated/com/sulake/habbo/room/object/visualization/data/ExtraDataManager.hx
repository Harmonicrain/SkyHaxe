package com.sulake.habbo.room.object.visualization.data
;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureExternalImageVisualization;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;
    import flash.events.IOErrorEvent;

     class ExtraDataManager 
    {
        public static inline final REJECTED= "REJECTED";
        static inline final BATCH_MAX_QUERY_AMOUNT= 50;
        static var instance:ExtraDataManager;

        var inputVisualizationQueue:Vector<FurnitureExternalImageVisualization>;
        var outputVisualizationQueue:Vector<FurnitureExternalImageVisualization>;

        public function new()
        {
            this.inputVisualizationQueue = new Vector<FurnitureExternalImageVisualization>();
            this.outputVisualizationQueue = new Vector<FurnitureExternalImageVisualization>();
            this.setTimedBatchCheck();
        }

        static function getInstance():ExtraDataManager
        {
            if (instance == null)
            {
                instance = Type.createInstance(ExtraDataManager, []);
            }
            return instance;
        }

        public static function requestExtraDataUrl(k:FurnitureExternalImageVisualization)
        {
            getInstance().inputVisualizationQueue.push(k);
        }

        public static function furnitureDisposed(k:FurnitureExternalImageVisualization)
        {
            getInstance().removeFurniFromManager(k);
        }


        function setTimedBatchCheck()
        {
            ASCompat.setInterval(this.handleBatch, 200);
        }

        function removeFurniFromManager(k:FurnitureExternalImageVisualization)
        {
            if (this.inputVisualizationQueue.indexOf(k) != -1)
            {
                this.inputVisualizationQueue.splice(this.inputVisualizationQueue.indexOf(k), 1);
            }
            if (this.outputVisualizationQueue.indexOf(k) != -1)
            {
                this.outputVisualizationQueue.splice(this.outputVisualizationQueue.indexOf(k), 1);
            }
        }

        function handleBatch()
        {
            var k:String = null;
            var _local_7:FurnitureExternalImageVisualization = null;
            var _local_8:String = null;
            if (this.inputVisualizationQueue.length == 0)
            {
                return;
            }
            var _local_2:Array<ASAny> = [];
            var _local_3 = 0;
            while (_local_3 < BATCH_MAX_QUERY_AMOUNT)
            {
                if (this.inputVisualizationQueue.length > 0)
                {
                    _local_7 = this.inputVisualizationQueue[0];
                    _local_8 = _local_7.getExternalImageUUID();
                    _local_2.push(_local_8);
                    k = _local_7.getExtraDataUrl();
                    this.outputVisualizationQueue.push(_local_7);
                    this.inputVisualizationQueue.splice(0, 1);
                }
                _local_3++;
            }
            if (_local_2.length == 0)
            {
                return;
            }
            var _local_4= new URLRequest();
            _local_4.method = URLRequestMethod.POST;
            _local_4.contentType = "application/json";
            var _local_5= haxe.Json.stringify(_local_2);
            _local_4.data = _local_5;
            _local_4.url = k;
            var _local_6= new URLLoader(_local_4);
            _local_6.dataFormat = URLLoaderDataFormat.TEXT;
            _local_6.addEventListener(Event.COMPLETE, (this.onExtraDataLoaded : ASAny));
            _local_6.addEventListener(IOErrorEvent.IO_ERROR, (this.onExtraDataError : ASAny));
        }

        function onExtraDataLoaded(event:Event)
        {
            var result:Array<ASAny> = null;
            var obj:ASObject = null;
            var id:String = null;
            var visualization:FurnitureExternalImageVisualization = null;
            var data:String = event.currentTarget.data;
            if ((ASCompat.stringAsBool(data) && (data.length > 0)))
            {
                try
                {
                    result = ASCompat.dynamicAs(haxe.Json.parse(data) , Array);
                    if (checkNullIteratee(result)) for (_tmp_ in result)
                    {
obj  = _tmp_;
                        id = obj.id;
                        final _iter_ = this.outputVisualizationQueue; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                        {
visualization  = _tmp_;
                            if (visualization.getExternalImageUUID() == id)
                            {
                                if ((ASCompat.toBool(obj.status) && (obj.status == REJECTED)))
                                {
                                    visualization.onUrlFromExtraDataService(REJECTED);
                                }
                                else
                                {
                                    visualization.onUrlFromExtraDataService(obj.url);
                                }
                                this.removeFurniFromManager(visualization);
                            }
                        }
                    }
                }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                 {
                    Logger.log(["Failed to read JSON from ExtraData service"]);
                }
 }            }
        }

        function onExtraDataError(k:IOErrorEvent)
        {
            Logger.log([("Failed to load ExtraData batch " + k.toString())]);
        }
    }

