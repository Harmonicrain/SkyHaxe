package com.sulake.core.utils.profiler
;
    import flash.text.TextField;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IProfiler;
    import flash.text.TextFormat;

     class ProfilerViewer extends TextField implements IDisposable 
    {
        var _disposed:Bool = false;
        var _profiler:IProfiler;

        public function new(k:IProfiler)
        {
            var _local_2= new TextFormat("Courier New", 8);
            defaultTextFormat = _local_2;
            setTextFormat(_local_2);
            textColor = 0xFFFFFF;
            width = 10;
            height = 10;
            autoSize = "left";
            mouseEnabled = false;
            selectable = false;
            super();
            if (k != null)
            {
                this._profiler = k;
                this._profiler.addStopEventListener(this.refresh);
            }
        }

        static function padAlign(k:String, _arg_2:Int, _arg_3:String=" ", _arg_4:Bool=false):String
        {
            var _local_5= (_arg_2 - k.length);
            if (_local_5 <= 0)
            {
                return k.substring(0, _arg_2);
            }
            var _local_6= "";
            var _local_7 = 0;
            while (_local_7 < _local_5)
            {
                _local_6 = (_local_6 + _arg_3);
                _local_7++;
            }
            return _arg_4 ? (_local_6 + k) : (k + _local_6);
        }


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var profiler(get,set):IProfiler;
public function  set_profiler(k:IProfiler):IProfiler        {
            if (((!(this._profiler != null)) && (k != null)))
            {
                this._profiler = k;
                this._profiler.addStopEventListener(this.refresh);
            }
return k;
        }
public function  get_profiler():IProfiler
        {
            return this._profiler;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (parent != null)
                {
                    parent.removeChild(this);
                }
                if (this._profiler != null)
                {
                    this._profiler.removeStopEventListener(this.refresh);
                    this._profiler = null;
                }
                this._disposed = true;
            }
        }

        public function refresh()
        {
            text = (((((((((((((((((((padAlign("task", 30) + "|") + padAlign("#rounds", 10, " ", true)) + "|") + padAlign("latest ms", 10, " ", true)) + "|") + padAlign("average ms", 10, " ", true)) + "|") + padAlign("total ms", 10, " ", true)) + "|\r") + padAlign("", 30, "-")) + "|") + padAlign("", 10, "-")) + "|") + padAlign("", 10, "-")) + "|") + padAlign("", 10, "-")) + "|") + padAlign("", 10, "-")) + "|\r");
            var k= this._profiler.getProfilerAgentsInArray();
            while (k.length > 0)
            {
                this.recursiveUpdate(k.pop(), 0);
            }
            if (parent != null)
            {
                parent.swapChildren(this, parent.getChildAt((parent.numChildren - 1)));
            }
        }

        function recursiveUpdate(task:ProfilerAgentTask, taskNumber:UInt)
        {
            text = (text + (((((((((padAlign(task.name, 30) + "|") + padAlign(Std.string(task.rounds), 10)) + "|") + padAlign(Std.string(task.latest), 10)) + "|") + padAlign(Std.string(task.average), 10)) + "|") + padAlign(Std.string(task.total), 10)) + "|\r"));
            var index:UInt = 0;
            while (index < task.numSubTasks)
            {
                this.recursiveUpdate(task.getSubTaskAt(index), (taskNumber + 1));
                index++;
            }
        }
    }

