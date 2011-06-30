package amf.model {

	import ddgame.server.IObjectDocument;
	import amf.model.DatabaseDocument;

	/**
	 *	Document données modèle d'objet
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  15.04.2011
	 */
	public class ObjectDocument extends DatabaseDocument implements IObjectDocument {

		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
		
		private var _title:String;
		private var _assets:Object;
		private var _category:String;
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;
		private var _pnj:Boolean;
		private var _ofsX:Number;
		private var _ofsY:Number;
		// résidus
		public var catid:String;

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Intitulé
		 */		
		public function get title () : String
		{
			return _title;
		}
		
		public function set title (val:String) : void
		{  _title = val; }
		
		/**
		 * Ressources graphiques
		 */
		public function get assets () : Object
		{  return _assets; }
		
		public function set assets (val:Object) : void
		{  _assets = val; }
		
		/**
		 * Nom de la classification
		 */
		public function get category () : String
		{ return _category; }
		
		public function set category (val:String) : void
		{ _category = val; }
		
		/**
		 * Largeur
		 */
		public function get width () : Number
		{ return _width; }
		
		public function set width (val:Number) : void
		{ _width = val; }
		
		/**
		 * Hauteur
		 */
		public function get height () : Number
		{ return _height; }
		
		public function set height (val:Number) : void
		{ _height = val; }
		
		/**
		 * Profondeur
		 */
		public function get depth () : Number
		{ return _depth; }
		
		public function set depth (val:Number) : void
		{ _depth = val; }
		
		/**
		 * Personnage non joueur
		 */
		public function get pnj () : Boolean
		{ return _pnj; }
		
		public function set pnj (val:Boolean) : void
		{ _pnj = val; }
		
		/**
		 * Décalage X de positionnement
		 */
		public function get ofsX () : Number
		{ return _ofsX; }
		
		public function set ofsX (val:Number) : void
		{ _ofsX = val; }
		
		/**
		 * Décalage Y de positionnement
		 */
		public function get ofsY () : Number
		{ return _ofsY; }
		
		public function set ofsY (val:Number) : void
		{ _ofsY = val; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function setBackData (data:Object) : void
		{
			// FIX propriété pnj		
			data.pnj = int(data.pnj) > 0 ? true : false;
			super.setBackData(data);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getBackData (attributes:Object = null) : Object
		{
			var res:Object;
			if (attributes)
			{
				res = {};
				for (var p:String in attributes)
					res[p] = this[p];

				// FIX Pnj
				if ("pnj" in res) res.pnj = pnj ? 1 : 0;
			}
			else
			{
				res =
				{
					category:_category,
					title:_title,
	 				assets:_assets,
					ofsX:_ofsX,
					ofsY:_ofsY,
					width:_width,
					depth:_depth,
					height:_height,
					pnj:_pnj ? 1 : 0					
				}
			}
			
			return res;
		}	
	}

}

