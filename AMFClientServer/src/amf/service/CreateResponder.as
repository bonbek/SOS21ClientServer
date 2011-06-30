package amf.service {

	import flash.net.Responder;
	import amf.model.DatabaseDocument;
	
	/**
	 *	Délegation réponse à une création
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  24.06.2011
	 */
	public class CreateResponder extends Responder {
	
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------

		public function CreateResponder (	document:DatabaseDocument,
														successCallBack:Function = null,
														faultCallBack:Function = null	)
		{
			this.document = document;
			this.successCallBack = successCallBack;
			this.faultCallBack = faultCallBack;
			super(onResult, onFault);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		private var document:DatabaseDocument;
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
				document.setBackData(result);
				if (successCallBack != null)
					successCallBack.apply(null, [result]);
			}

			document = null;
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

