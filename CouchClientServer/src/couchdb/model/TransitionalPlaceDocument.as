package couchdb.model {

	import couchdb.model.ITransitionalDocument;
	import amf.model.PlaceDocument;

	/**
	 *	Document transitiion des données lieu.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  29.06.2011
	 */
	public class TransitionalPlaceDocument extends PlaceDocument implements ITransitionalDocument {
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
	
		protected var _couchId:String;
		public function get couchId () : String
		{ return _couchId; }
		public function set couchId (val:String) : void
		{ _couchId = val; }
		
		protected var _rev:String;
		public function get rev () : String
		{ return _rev; }
		public function set rev (val:String) : void
		{ _rev = val; }
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		public function getCouchData () : Object
		{
			var res:Object =
			{
				title        : this.title,
				hidden       : this.hidden,
				background   : this.background,
				foreground   : this.foreground,
				music        : this.music,
				cellsNumber  : this.cellsNumber,
				cellsSize    : this.cellsSize,
				camera       : this.camera,
				entrance     : this.entrance,
				collisions   : this.collisions,
				objectsModels: this.objectsModels,
				objects      : this.objects,
				actions      : this.actions,
				location     : this.location,
				variables    : this.variables
			}
			
			return res;
		}
		
		/**
		 * @inheritDoc
		 * On passe l'identifiant / revision document couchDB
		 */
		override public function getBackData (attributes:Object = null) : Object
		{
			var res:Object = super.getBackData(attributes);

			if (_rev && _couchId)
			{
				res.couchId = _couchId;
				res.rev = _rev;				
			}
			
			return res;
		}
	
	}

}

