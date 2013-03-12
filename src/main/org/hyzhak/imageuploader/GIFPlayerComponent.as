package org.hyzhak.imageuploader
{
    import com.worlize.gif.GIFPlayer;
    import com.worlize.gif.events.GIFPlayerEvent;

    import flash.events.Event;

    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;

    import flash.net.URLRequest;
	
	import mx.core.UIComponent;
 
	public class GIFPlayerComponent extends UIComponent
	{
		//private var _gif:GIFPlayer = new GIFPlayer();
        private var _gif:GIFPlayer = new GIFPlayer();
		private var _source:String = new String();
        private var loader:URLLoader = new URLLoader();
		public function GIFPlayerComponent()
		{
			super();
            addChild(_gif);
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(Event.COMPLETE, onComplete);
            _gif.addEventListener(GIFPlayerEvent.COMPLETE, onGifDecodeComplete);
			//addChild(_gif);
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

                loader.load ( urlReq );
                //_gif.load(urlReq);
            } else {
                //_gif.visible = false;
            }
		}

        private function onComplete(event:Event):void {
            _gif.loadBytes(event.target.data);
        }

        private function onGifDecodeComplete(event:GIFPlayerEvent):void {
            _gif.play();
        }
	}
}