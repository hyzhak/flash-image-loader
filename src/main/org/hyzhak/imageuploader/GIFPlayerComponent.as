package org.hyzhak.imageuploader
{
    import com.worlize.gif.GIFPlayer;
    import com.worlize.gif.events.AsyncDecodeErrorEvent;
    import com.worlize.gif.events.GIFPlayerEvent;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;

    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;

    import flash.net.URLRequest;
	
	import mx.core.UIComponent;
 
	public class GIFPlayerComponent extends UIComponent
	{
        private var _gif:GIFPlayer = new GIFPlayer();
		private var _source:String = new String();
        private var _loader:URLLoader = new URLLoader();

        [Embed(source="inprogress.gif", mimeType="application/octet-stream")]
        public static const IN_PROGRESS_CLASS:Class;

		public function GIFPlayerComponent()
		{
			super();
            addChild(_gif);
            _loader.dataFormat = URLLoaderDataFormat.BINARY;
            _loader.addEventListener(Event.COMPLETE, onComplete);
            _loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            _gif.addEventListener(GIFPlayerEvent.COMPLETE, onGifDecodeComplete);
            _gif.addEventListener(GIFPlayerEvent.FRAME_RENDERED, onGifFrameRendered);
            _gif.addEventListener(AsyncDecodeErrorEvent.ASYNC_DECODE_ERROR, onAsyncDecodeError);
		}

        public function isGif():Boolean {
            return _gif.totalFrames > 0;
        }


		public function get source():String{
			return _source;
		}
		
		public function set source(value:String):void{
			if (_source == value) {
                return;
            }

			_source = value;

            if (_source != null) {
                var urlReq:URLRequest = new URLRequest(_source);
                _loader.load ( urlReq );
            } else {
                _gif.visible = false;
            }
		}

        private function onSecurityError(event:SecurityErrorEvent):void {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function onIOError(event:IOErrorEvent):void {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function onComplete(event:Event):void {
            _gif.loadBytes(event.target.data);
        }

        private function onGifDecodeComplete(event:GIFPlayerEvent):void {
            _gif.visible = true;
            _gif.play();
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function onGifFrameRendered(event:GIFPlayerEvent):void {
            //Put in a middle
            _gif.x = -0.5 * _gif.width;
            _gif.y = -0.5 * _gif.height;
        }

        private function onAsyncDecodeError(event:AsyncDecodeErrorEvent):void {

        }
    }
}