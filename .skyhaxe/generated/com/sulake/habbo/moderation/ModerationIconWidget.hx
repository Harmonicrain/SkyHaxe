package com.sulake.habbo.moderation
;
	import com.sulake.core.runtime.IDisposable;
	import com.sulake.core.window.IWindowContainer;
	import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
	 class ModerationIconWidget implements IDisposable
	{
		var _moderationManager:ModerationManager;
		var _frame:IWindowContainer;
		
		var _disposed:Bool = false;
		
		public function new(moderationManager:ModerationManager)
		{
			this._moderationManager = moderationManager;
		}
		
		public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._moderationManager = null;
                if (this._frame != null)
                {
                    this._frame.dispose();
                    this._frame = null;
                }
            }
        }
		
		public function show(visible:Bool)
        {
            if (this._frame == null)
            {
                this._frame = cast(this._moderationManager.getXmlWindow("moderation_icon"), IWindowContainer);
                this._frame.addEventListener(WindowMouseEvent.CLICK, this.onClickHandler);
            }
			
			if (this._frame != null)
			{
				this._frame.visible = false;//visible;
			}
		}
		
		public function onClickHandler(event:WindowEvent)
		{
			this._moderationManager.setVisible(true);
		}
	}

