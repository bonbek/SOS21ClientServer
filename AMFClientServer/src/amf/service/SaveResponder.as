package amf.service {

	import flash.net.Responder;

	/**
	 *	Délegation réponse à une sauvegarde
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  23.06.2011
	 */
	public class SaveResponder extends Responder {
	
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------

		public function SaveResponder (	successCallBack:Function = null,
													faultCallBack:Function = null	)
		{
			this.successCallBack = successCallBack;
			this.faultCallBack = faultCallBack;
			super(onResult, onFault);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		private var successCallBack:Function;
		private var faultCallBack:Function;

		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------

		/**
		 *	@param result Object
		 */
		private function onResult (result:Object) : void
		{
			if (!result) {
				if (faultCallBack != null)
					faultCallBack.apply(null, [result]);
			}
			else {
				if (successCallBack != null)
					successCallBack.apply(null, [result]);
			}

			successCallBack = null;
			faultCallBack = null;
		}

		/**
		 *	@param fault Object
		 */
		private function onFault (fault:Object) : void
		{ onResult(false); }
	
	}

}

