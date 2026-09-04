package com.sulake.habbo.habbicons.assets
;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

     class HabbiconAssetManager
    {
        static inline final ASSET_ROOT_KEY= "habbicons.asset.root";
        static inline final ASSET_HASH_KEY= "habbicons.asset.hash";
        static inline final METADATA_FILE= "habbicons.json";
        static inline final PREVIEW_SHEET_FILE= "habbicons_spritesheet.png";
        static inline final COLLECTION_SHEET_FILE= "collection_icons_spritesheet.png";
        static inline final ANIMATION_PATH= "animation/";
        static inline final DEFAULT_FRAME_SIZE= 40;
        static inline final DEFAULT_COLLECTION_ICON_SIZE= 18;
        static inline final COLLECTION_ICON_OUTLINE_SIZE= 2;
        static inline final COLLECTION_ICON_OUTLINE_COLOR:UInt = 0xFFFFFFFF;

        public static inline final ASSETS_LOADED= "habbicon_assets_loaded";

        static var _instance:HabbiconAssetManager;
        static var _configuration:IHabboConfigurationManager;
        static var _events:EventDispatcher = new EventDispatcher();

        var _loading:Bool = false;
        var _jsonLoaded:Bool = false;
        var _sheetLoaded:Bool = false;
        var _collectionSheetLoaded:Bool = false;
        var _failed:Bool = false;

        var _previewFrames:ASDictionary<ASAny,ASAny>;
        var _collectionFrames:ASDictionary<ASAny,ASAny>;
        var _previewBitmaps:ASDictionary<ASAny,ASAny>;
        var _previewBitmapsSmall:ASDictionary<ASAny,ASAny>;
        var _collectionBitmaps:ASDictionary<ASAny,ASAny>;
        var _outlinedCollectionBitmaps:ASDictionary<ASAny,ASAny>;
        var _nameKeys:ASDictionary<ASAny,ASAny>;
        var _definitions:ASDictionary<ASAny,ASAny>;
        var _fallbackRuntimeAssets:ASDictionary<ASAny,ASAny>;
        var _animatedRuntimeAssets:ASDictionary<ASAny,ASAny>;
        var _runtimeAssetLoading:ASDictionary<ASAny,ASAny>;

        var _previewSheet:BitmapData;
        var _collectionSheet:BitmapData;
        var _assetRoot:String;

        public function new()
        {
            this.resetLoadedAssets();
        }

        public static function configure(configuration:IHabboConfigurationManager)
        {
            _configuration = configuration;
            getInstance().refreshAssetRoot();
        }

        public static function preload()
        {
            getInstance().ensureLoaded();
        }

        public static function getPreviewBitmap(habbiconId:Int, small:Bool):BitmapData
        {
            return getInstance().resolvePreviewBitmap(habbiconId, small);
        }

        public static function getHabbiconNameKey(habbiconId:Int):String
        {
            return getInstance().resolveNameLocalizationKey(habbiconId);
        }

        public static function getCollectionIconBitmap(collectionId:Int):BitmapData
        {
            return getInstance().resolveCollectionIconBitmap(collectionId);
        }

        public static function getOutlinedCollectionIconBitmap(collectionId:Int):BitmapData
        {
            return getInstance().resolveOutlinedCollectionIconBitmap(collectionId);
        }

        public static function getRuntimeAsset(habbiconId:Int):ASObject
        {
            return getInstance().resolveRuntimeAsset(habbiconId);
        }

        public static function getDirection(habbiconId:Int):Int
        {
            return getInstance().resolveDirection(habbiconId);
        }

        public static function addEventListener(type:String, listener:ASFunction)
        {
            _events.addEventListener(type, listener);
        }

        public static function removeEventListener(type:String, listener:ASFunction)
        {
            _events.removeEventListener(type, listener);
        }

        static function getInstance():HabbiconAssetManager
        {
            if (_instance == null)
            {
                _instance = new HabbiconAssetManager();
            }
            return _instance;
        }

        static function resampleBitmapData(source:BitmapData, scale:Float):BitmapData
        {
            if (source == null)
            {
                return null;
            }
            var result= new BitmapData(Std.int(Math.max(1, Std.int(source.width * scale))), Std.int(Math.max(1, Std.int(source.height * scale))), true, 0);
            var matrix= new Matrix();
            matrix.scale(scale, scale);
            result.draw(source, matrix, null, null, null, true);
            return result;
        }

        static function createOutlinedBitmap(source:BitmapData, size:Int, color:UInt):BitmapData
        {
            var dx:Int;
            var dy:Int;
            var result= new BitmapData(source.width + size * 2, source.height + size * 2, true, 0);
            var mask= new BitmapData(source.width, source.height, true, color);
            var point= new Point();
            mask.copyChannel(source, source.rect, point, 8, 8);
            for (_tmp_ in -size...size + 1)
            {
dx = _tmp_;
                for (_tmp_ in -size...size + 1)
                {
dy = _tmp_;
                    if (dx != 0 || dy != 0)
                    {
                        point.x = size + dx;
                        point.y = size + dy;
                        result.copyPixels(mask, mask.rect, point, null, null, true);
                    }
                }
            }
            result.copyPixels(source, source.rect, new Point(size, size), null, null, true);
            mask.dispose();
            return result;
        }

        function refreshAssetRoot():String
        {
            var root:String;
            var hash:String;
            if (_configuration == null)
            {
                return this._assetRoot;
            }
            root = _configuration.getProperty(ASSET_ROOT_KEY);
            hash = _configuration.getProperty(ASSET_HASH_KEY);
            if (root == null || root == "")
            {
                return this._assetRoot;
            }
            root = this.stripTrailingSlash(root);
            if (hash != null && hash != "" && (root.indexOf("{hash}") > -1 || root.indexOf("%hash%") > -1))
            {
                root = root.split("{hash}").join(hash);
                root = root.split("%hash%").join(hash);
            }
            else if (hash != null && hash != "" && !this.endsWithPathSegment(root, hash))
            {
                root += "/" + hash;
            }
            root += "/";
            if (this._assetRoot != root)
            {
                this.resetLoadedAssets();
                this._assetRoot = root;
            }
            return this._assetRoot;
        }

        function resetLoadedAssets()
        {
            this._loading = false;
            this._jsonLoaded = false;
            this._sheetLoaded = false;
            this._collectionSheetLoaded = false;
            this._failed = false;
            this._previewFrames = new ASDictionary<ASAny,ASAny>();
            this._collectionFrames = new ASDictionary<ASAny,ASAny>();
            this._previewBitmaps = new ASDictionary<ASAny,ASAny>();
            this._previewBitmapsSmall = new ASDictionary<ASAny,ASAny>();
            this._collectionBitmaps = new ASDictionary<ASAny,ASAny>();
            this._outlinedCollectionBitmaps = new ASDictionary<ASAny,ASAny>();
            this._nameKeys = new ASDictionary<ASAny,ASAny>();
            this._definitions = new ASDictionary<ASAny,ASAny>();
            this._fallbackRuntimeAssets = new ASDictionary<ASAny,ASAny>();
            this._animatedRuntimeAssets = new ASDictionary<ASAny,ASAny>();
            this._runtimeAssetLoading = new ASDictionary<ASAny,ASAny>();
            this._previewSheet = null;
            this._collectionSheet = null;
        }

        function stripTrailingSlash(value:String):String
        {
            while (value.length > 0 && value.charAt(value.length - 1) == "/")
            {
                value = value.substr(0, value.length - 1);
            }
            return value;
        }

        function endsWithPathSegment(value:String, segment:String):Bool
        {
            return value == segment || value.lastIndexOf("/" + segment) == value.length - segment.length - 1;
        }

        function resolvePreviewBitmap(habbiconId:Int, small:Bool):BitmapData
        {
            var frame:ASObject;
            var bitmap:BitmapData;
            this.ensureLoaded();
            bitmap = small ? ASCompat.dynamicAs(this._previewBitmapsSmall[habbiconId] , BitmapData) : ASCompat.dynamicAs(this._previewBitmaps[habbiconId] , BitmapData);
            if (bitmap != null)
            {
                return bitmap;
            }
            if (!this._jsonLoaded || !this._sheetLoaded || this._previewSheet == null)
            {
                return null;
            }
            frame = this._previewFrames[habbiconId];
            if (frame == null)
            {
                return null;
            }
            bitmap = this.extractFrameBitmap(frame);
            if (bitmap == null)
            {
                return null;
            }
            this._previewBitmaps[habbiconId] = bitmap;
            if (small)
            {
                bitmap = resampleBitmapData(bitmap, 0.5);
                this._previewBitmapsSmall[habbiconId] = bitmap;
            }
            return bitmap;
        }

        function resolveCollectionIconBitmap(collectionId:Int):BitmapData
        {
            var frame:ASObject;
            var bitmap:BitmapData;
            this.ensureLoaded();
            bitmap = ASCompat.dynamicAs(this._collectionBitmaps[collectionId] , BitmapData);
            if (bitmap != null)
            {
                return bitmap;
            }
            if (!this._jsonLoaded || !this._collectionSheetLoaded || this._collectionSheet == null)
            {
                return null;
            }
            frame = this._collectionFrames[collectionId];
            if (frame == null)
            {
                return null;
            }
            bitmap = this.extractFrameBitmapFromSheet(this._collectionSheet, frame);
            if (bitmap != null)
            {
                this._collectionBitmaps[collectionId] = bitmap;
            }
            return bitmap;
        }

        function resolveOutlinedCollectionIconBitmap(collectionId:Int):BitmapData
        {
            var bitmap= ASCompat.dynamicAs(this._outlinedCollectionBitmaps[collectionId] , BitmapData);
            if (bitmap != null)
            {
                return bitmap;
            }
            var icon= this.resolveCollectionIconBitmap(collectionId);
            if (icon == null)
            {
                return null;
            }
            bitmap = createOutlinedBitmap(icon, COLLECTION_ICON_OUTLINE_SIZE, COLLECTION_ICON_OUTLINE_COLOR);
            this._outlinedCollectionBitmaps[collectionId] = bitmap;
            return bitmap;
        }

        function resolveNameLocalizationKey(habbiconId:Int):String
        {
            this.ensureLoaded();
            return this._nameKeys[habbiconId];
        }

        function resolveDirection(habbiconId:Int):Int
        {
            this.ensureLoaded();
            var definition= ASCompat.dynamicAs(this._definitions[habbiconId] , HabbiconDefinition);
            return definition != null ? definition.direction : 0;
        }

        function resolveRuntimeAsset(habbiconId:Int):ASObject
        {
            var definition:HabbiconDefinition;
            var asset:ASObject;
            this.ensureLoaded();
            asset = this._animatedRuntimeAssets[habbiconId];
            if (asset != null)
            {
                return asset;
            }
            definition = ASCompat.dynamicAs(this._definitions[habbiconId] , HabbiconDefinition);
            if (definition == null)
            {
                return null;
            }
            if (definition.animated)
            {
                this.loadRuntimeAsset(habbiconId, definition);
            }
            asset = this._fallbackRuntimeAssets[habbiconId];
            if (asset == null)
            {
                asset = this.buildFallbackRuntimeAsset(habbiconId, definition);
                if (asset != null)
                {
                    this._fallbackRuntimeAssets[habbiconId] = asset;
                }
            }
            return asset;
        }

        function ensureLoaded()
        {
            var root:String;
            var metadata:URLLoader;
            var preview:Loader;
            var collection:Loader;
            if (this._loading || (this._jsonLoaded && this._sheetLoaded && this._collectionSheetLoaded) || this._failed)
            {
                return;
            }
            root = this.refreshAssetRoot();
            if (root == null || root == "")
            {
                this.markLoadFailed();
                return;
            }
            this._loading = true;
            metadata = new URLLoader();
            metadata.dataFormat = "text";
            metadata.addEventListener(Event.COMPLETE, this.onMetadataLoaded);
            metadata.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
            metadata.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            metadata.load(new URLRequest(root + METADATA_FILE));

            preview = new Loader();
            preview.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onSpritesheetLoaded);
            preview.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
            preview.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            preview.load(new URLRequest(root + PREVIEW_SHEET_FILE));

            collection = new Loader();
            collection.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onCollectionSpritesheetLoaded);
            collection.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onCollectionLoadError);
            collection.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onCollectionSecurityError);
            collection.load(new URLRequest(root + COLLECTION_SHEET_FILE));
        }

        function onMetadataLoaded(event:Event)
        {
            var data:ASObject;
            var item:ASObject;
            var habbicons:Array<ASAny>;
            var collections:Array<ASAny>;
            var width:Int;
            var height:Int;
            var loader= ASCompat.dynamicAs(event.currentTarget , URLLoader);
            this.removeTextLoaderListeners(loader);
            try
            {
                data = haxe.Json.parse(ASCompat.toString(loader.data ));
                habbicons = data != null && Std.is(data.habbicons , Array) ? ASCompat.dynamicAs(data.habbicons , Array) : [];
                for (_tmp_ in habbicons)
                {
item  = _tmp_;
                    if (item != null && item.id != null)
                    {
                        width = this.normalizeDimension(item.width);
                        height = this.normalizeDimension(item.height);
                        this._previewFrames[ASCompat.toInt(item.id)] = {"x":ASCompat.toInt(item.x), "y":ASCompat.toInt(item.y), "width":width, "height":height};
                        if (item.name != null)
                        {
                            this._nameKeys[ASCompat.toInt(item.id)] = ASCompat.toString(item.name);
                        }
                        this._definitions[ASCompat.toInt(item.id)] = this.buildDefinition(item, width, height);
                    }
                }
                collections = data != null && Std.is(data.collectionIcons , Array) ? ASCompat.dynamicAs(data.collectionIcons , Array) : [];
                for (_tmp_ in collections)
                {
item  = _tmp_;
                    if (item != null && item.id != null)
                    {
                        this._collectionFrames[ASCompat.toInt(item.id)] = {"x":ASCompat.toInt(item.x), "y":ASCompat.toInt(item.y), "width":this.normalizeDimension(item.width, DEFAULT_COLLECTION_ICON_SIZE), "height":this.normalizeDimension(item.height, DEFAULT_COLLECTION_ICON_SIZE)};
                    }
                }
                this._jsonLoaded = true;
                this.checkLoadCompletion();
            }
            catch (error:ASError)
            {
                Logger.log(["[HabbiconAssetManager] Failed to parse habbicon metadata: " + error.message]);
                this.markLoadFailed();
            }
        }

        function onSpritesheetLoaded(event:Event)
        {
            var loader= ASCompat.dynamicAs(event.currentTarget.loader , Loader);
            var bitmap:Bitmap = loader != null ? Std.downcast(loader.content , Bitmap) : null;
            this.removeImageLoaderListeners(loader);
            if (bitmap == null || bitmap.bitmapData == null)
            {
                Logger.log(["[HabbiconAssetManager] Loaded habbicon spritesheet without bitmap data."]);
                this.markLoadFailed();
                return;
            }
            this._previewSheet = bitmap.bitmapData;
            this._sheetLoaded = true;
            this.checkLoadCompletion();
        }

        function onCollectionSpritesheetLoaded(event:Event)
        {
            var loader= ASCompat.dynamicAs(event.currentTarget.loader , Loader);
            var bitmap:Bitmap = loader != null ? Std.downcast(loader.content , Bitmap) : null;
            this.removeImageLoaderListeners(loader, this.onCollectionSpritesheetLoaded, this.onCollectionLoadError, this.onCollectionSecurityError);
            if (bitmap != null && bitmap.bitmapData != null)
            {
                this._collectionSheet = bitmap.bitmapData;
            }
            this._collectionSheetLoaded = true;
            this.checkLoadCompletion();
        }

        function onLoadError(event:IOErrorEvent)
        {
            Logger.log(["[HabbiconAssetManager] Failed to load habbicon asset: " + event.text]);
            this.markLoadFailed();
        }

        function onCollectionLoadError(event:IOErrorEvent)
        {
            var loader= ASCompat.dynamicAs(event.currentTarget.loader , Loader);
            this.removeImageLoaderListeners(loader, this.onCollectionSpritesheetLoaded, this.onCollectionLoadError, this.onCollectionSecurityError);
            Logger.log(["[HabbiconAssetManager] Failed to load habbicon collection icon asset: " + event.text]);
            this._collectionSheetLoaded = true;
            this.checkLoadCompletion();
        }

        function onSecurityError(event:SecurityErrorEvent)
        {
            Logger.log(["[HabbiconAssetManager] Security error while loading habbicon asset: " + event.text]);
            this.markLoadFailed();
        }

        function onCollectionSecurityError(event:SecurityErrorEvent)
        {
            var loader= ASCompat.dynamicAs(event.currentTarget.loader , Loader);
            this.removeImageLoaderListeners(loader, this.onCollectionSpritesheetLoaded, this.onCollectionLoadError, this.onCollectionSecurityError);
            Logger.log(["[HabbiconAssetManager] Security error while loading habbicon collection icon asset: " + event.text]);
            this._collectionSheetLoaded = true;
            this.checkLoadCompletion();
        }

        function markLoadFailed()
        {
            this._loading = false;
            this._failed = true;
        }

        function checkLoadCompletion()
        {
            if (this._jsonLoaded && this._sheetLoaded && this._collectionSheetLoaded)
            {
                this._loading = false;
                _events.dispatchEvent(new Event(ASSETS_LOADED));
            }
        }

        function buildDefinition(data:ASObject, width:Int, height:Int):HabbiconDefinition
        {
            var animation:ASObject = data.animation;
            var frameData= Std.is(data.frameData , Array) ? ASCompat.dynamicAs(data.frameData , Array) : [];
            var steps= animation != null && Std.is(animation.steps , Array) ? ASCompat.dynamicAs(animation.steps , Array) : [];
            var speed= animation != null && animation.playbackSpeed != null ? ASCompat.toNumber(animation.playbackSpeed) : 1;
            if (Math.isNaN(speed) || speed <= 0)
            {
                speed = 1;
            }
            var animated= ASCompat.toInt(data.frameCount) > 1 && frameData.length > 0 && steps.length > 0;
            return new HabbiconDefinition(width, height, this.normalizeDirection(data.dir), animated, data != null && data.loop, this.buildRuntimeFrameDefinitions(frameData, width, height), this.buildRuntimeAnimationSteps(steps, speed));
        }

        function buildRuntimeFrameDefinitions(frameData:Array<ASAny>, width:Int, height:Int):Array<ASAny>
        {
            var result:Array<ASAny> = [];
            var frame:ASObject;
            if (frameData == null)
            {
                return result;
            }
            for (_tmp_ in frameData)
            {
frame  = _tmp_;
                if (frame != null)
                {
                    result.push({"id":ASCompat.toInt(frame.id), "x":ASCompat.toInt(frame.x), "y":ASCompat.toInt(frame.y), "width":this.normalizeDimension(frame.width, width), "height":this.normalizeDimension(frame.height, height)});
                }
            }
            ASCompat.ASArray.sortOn(result, "id", ASCompat.ASArray.NUMERIC);
            return result;
        }

        function buildRuntimeAnimationSteps(steps:Array<ASAny>, speed:Float):Array<ASAny>
        {
            var result:Array<ASAny> = [];
            var step:ASObject;
            var duration:Int;
            if (steps == null)
            {
                return result;
            }
            for (_tmp_ in steps)
            {
step  = _tmp_;
                if (step != null && step.enabled != false)
                {
                    duration = Std.int(Math.max(1, ASCompat.toInt(step.durationMs)));
                    duration = Std.int(Math.max(1, Std.int(duration / speed)));
                    result.push({"sourceFrame":Math.max(0, ASCompat.toInt(step.sourceFrame)), "durationMs":duration});
                }
            }
            return result;
        }

        function buildFallbackRuntimeAsset(habbiconId:Int, definition:HabbiconDefinition):ASObject
        {
            var bitmap= this.resolvePreviewBitmap(habbiconId, false);
            var smallBitmap= this.resolvePreviewBitmap(habbiconId, true);
            if (bitmap == null)
            {
                return null;
            }
            return {"animated":false, "loop":false, "direction":definition.direction, "baseWidth":bitmap.width, "baseHeight":bitmap.height, "frames":[{"bitmap":bitmap, "smallBitmap":smallBitmap != null ? smallBitmap : bitmap, "width":bitmap.width, "height":bitmap.height}], "steps":[{"sourceFrame":0, "durationMs":0}], "playbackDurationMs":0};
        }

        function loadRuntimeAsset(habbiconId:Int, definition:HabbiconDefinition)
        {
            var root:String;
            var loader:Loader;
            if (ASCompat.thisOrDefault(definition == null || !definition.animated , this._runtimeAssetLoading[habbiconId]) || this._animatedRuntimeAssets[habbiconId] != null)
            {
                return;
            }
            root = this.refreshAssetRoot();
            if (root == null || root == "")
            {
                return;
            }
            this._runtimeAssetLoading[habbiconId] = true;
            loader = new Loader();
            loader.name = Std.string(habbiconId);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onRuntimeSheetLoaded);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onRuntimeLoadError);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onRuntimeSecurityError);
            loader.load(new URLRequest(root + ANIMATION_PATH + habbiconId + ".png"));
        }

        function onRuntimeSheetLoaded(event:Event)
        {
            var loader= ASCompat.dynamicAs(event.currentTarget.loader , Loader);
            var bitmap:Bitmap = loader != null ? Std.downcast(loader.content , Bitmap) : null;
            var habbiconId= ASCompat.toInt(loader != null ? loader.name : "0");
            var definition= ASCompat.dynamicAs(this._definitions[habbiconId] , HabbiconDefinition);
            this.removeImageLoaderListeners(loader, this.onRuntimeSheetLoaded, this.onRuntimeLoadError, this.onRuntimeSecurityError);
            this._runtimeAssetLoading.remove(habbiconId);
            if (bitmap == null || bitmap.bitmapData == null || definition == null)
            {
                return;
            }
            this._animatedRuntimeAssets[habbiconId] = this.buildAnimatedRuntimeAsset(definition, bitmap.bitmapData);
        }

        function onRuntimeLoadError(event:IOErrorEvent)
        {
            var loader= ASCompat.dynamicAs(event.currentTarget.loader , Loader);
            if (loader != null)
            {
                this.removeImageLoaderListeners(loader, this.onRuntimeSheetLoaded, this.onRuntimeLoadError, this.onRuntimeSecurityError);
                this._runtimeAssetLoading.remove(ASCompat.toInt(loader.name));
            }
            Logger.log(["[HabbiconAssetManager] Failed to load habbicon runtime asset: " + event.text]);
        }

        function onRuntimeSecurityError(event:SecurityErrorEvent)
        {
            var loader= ASCompat.dynamicAs(event.currentTarget.loader , Loader);
            if (loader != null)
            {
                this.removeImageLoaderListeners(loader, this.onRuntimeSheetLoaded, this.onRuntimeLoadError, this.onRuntimeSecurityError);
                this._runtimeAssetLoading.remove(ASCompat.toInt(loader.name));
            }
            Logger.log(["[HabbiconAssetManager] Security error while loading habbicon runtime asset: " + event.text]);
        }

        function buildAnimatedRuntimeAsset(definition:HabbiconDefinition, sheet:BitmapData):ASObject
        {
            var frames:Array<ASAny> = [];
            var frame:ASObject;
            var bitmap:BitmapData;
            var totalDuration= 0;
            var step:ASObject;
            if (definition == null || sheet == null || definition.frames == null || definition.frames.length == 0)
            {
                return null;
            }
            for (_tmp_ in definition.frames)
            {
frame  = _tmp_;
                bitmap = this.extractFrameBitmapFromSheet(sheet, frame);
                if (bitmap != null)
                {
                    frames.push({"bitmap":bitmap, "smallBitmap":resampleBitmapData(bitmap, 0.5), "width":bitmap.width, "height":bitmap.height});
                }
            }
            if (frames.length == 0)
            {
                return null;
            }
            for (_tmp_ in definition.steps)
            {
step  = _tmp_;
                totalDuration += Std.int(Math.max(1, ASCompat.toInt(step.durationMs)));
            }
            return {"animated":true, "loop":definition.loop, "direction":definition.direction, "baseWidth":definition.previewWidth, "baseHeight":definition.previewHeight, "frames":frames, "steps":definition.steps != null && definition.steps.length > 0 ? definition.steps : [{"sourceFrame":0, "durationMs":0}], "playbackDurationMs":totalDuration};
        }

        function extractFrameBitmap(frame:ASObject):BitmapData
        {
            return this.extractFrameBitmapFromSheet(this._previewSheet, frame);
        }

        function extractFrameBitmapFromSheet(sheet:BitmapData, frame:ASObject):BitmapData
        {
            var rect= this.createValidRectForSheet(sheet, ASCompat.toInt(frame.x), ASCompat.toInt(frame.y), ASCompat.toInt(frame.width), ASCompat.toInt(frame.height));
            if (rect == null)
            {
                return null;
            }
            var bitmap= new BitmapData(Std.int(rect.width), Std.int(rect.height), true, 0);
            bitmap.copyPixels(sheet, rect, new Point(0, 0), null, null, true);
            return bitmap;
        }

        function createValidRectForSheet(sheet:BitmapData, x:Int, y:Int, width:Int, height:Int):Rectangle
        {
            var rect:Rectangle;
            if (sheet == null)
            {
                return null;
            }
            rect = new Rectangle(x, sheet.height - y - height, width, height);
            if (this.isRectWithinBitmap(sheet, rect))
            {
                return rect;
            }
            rect = new Rectangle(x, y, width, height);
            if (this.isRectWithinBitmap(sheet, rect))
            {
                return rect;
            }
            return null;
        }

        function isRectWithinBitmap(sheet:BitmapData, rect:Rectangle):Bool
        {
            return sheet != null && rect.x >= 0 && rect.y >= 0 && rect.right <= sheet.width && rect.bottom <= sheet.height;
        }

        function normalizeDimension(value:ASAny, defaultValue:Int = DEFAULT_FRAME_SIZE):Int
        {
            var dimension= ASCompat.toInt(value);
            return dimension > 0 ? dimension : defaultValue;
        }

        function normalizeDirection(value:ASAny):Int
        {
            if (value == null)
            {
                return 0;
            }
            var direction= ASCompat.toInt(value);
            if (direction < 0)
            {
                return -1;
            }
            if (direction > 0)
            {
                return 1;
            }
            return 0;
        }

        function removeTextLoaderListeners(loader:URLLoader)
        {
            if (loader == null)
            {
                return;
            }
            loader.removeEventListener(Event.COMPLETE, this.onMetadataLoaded);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
        }

        function removeImageLoaderListeners(loader:Loader, complete:ASFunction = null, ioError:ASFunction = null, securityError:ASFunction = null)
        {
            if (loader == null || loader.contentLoaderInfo == null)
            {
                return;
            }
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete != null ? complete : this.onSpritesheetLoaded);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError != null ? ioError : this.onLoadError);
            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError != null ? securityError : this.onSecurityError);
        }
    }

