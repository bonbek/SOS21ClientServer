package amf.model {
	
	import com.sos21.proxy.ConfigProxy;
	import ddgame.server.IPlayerDocument;
	import amf.model.DatabaseDocument;	
	
	/**
	 *	Document de données joueur
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 */
	public class PlayerDocument extends DatabaseDocument implements IPlayerDocument {
	
	
		//---------------------------------------
		// PRIVATE VARIABLES
		//---------------------------------------
	
		private var _pseudo:String;
		private var _classe:String;
		private var _level:int;
		private var _bonus:Array;
		private var _avatarSkin:int;
		private var _homePlace:String;
		private var _globals:Object;
		private var _locals:Object;
		private var _actions:Object;
		private var _place:String;
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Retourne le pseudo du joueur
		 */
		public function get pseudo () : String
		{ return _pseudo; }
		public function set pseudo (val:String) : void
		{ _pseudo = val; }
		
		/**
		 * Retourne la classe du joueur
		 */
		public function get classe () : String
		{ return _classe; }
		
		public function set classe (val:String) : void
		{ _classe = val; }
		
		/**
		 * Niveau
		 */
		public function get level () : int
		{ return _level; }

		public function set level (val:int) : void
		{ _level = val; }
		
		/**
		 * Retourne la liste de tous les bonus
		 * par ordre d'indexation
		 */
		public function get bonus () : Array
		{ return _bonus; }

		public function set bonus (val:Array) : void
		{ _bonus = val; }
		
		/**
		 * Accesseur de l'enveloppe de l'avatar
		 * du joueur
		 * @param	val	TODO pour l'instant un objet
		 * formaté : {id:int, classDef:String nom de class}
		 */
		public function get avatarSkin () : Object
		{
			var sId:int = _avatarSkin;
			var sCd:String = ConfigProxy.getInstance().data..skin.(@id == sId)[0];

			return {id:sId, classDef:sCd};
		}

		public function set avatarSkin (val:Object) : void
		{ _avatarSkin = val.id; }
		
		public function get place () : String
		{ return _place; }

		public function set place (val:String) : void
		{ _place = val; }
		
		/**
		 * Retourne l'indentifiant de la scène
		 * "lieu de vie du joeur"
		 */
		public function get homePlace () : String
		{ return _homePlace; }
		public function set homePlace (val:String) : void
		{ _homePlace = val; }
		
		/**
		 * Flag joueur connecté
		 */
		public function get loggedOn () : Boolean
		{
			// ?
			return true;
		}
		
		/**
		 * Pointeurs / variables
		 * @return
		 */
		public function get globals () : Object
		{
			if (!_globals) _globals = {};
			return _globals;
		}
		public function set globals (val:Object) : void
		{ _globals = val; }

		public function get locals () : Object
		{
			if (!_locals) _locals = {};
			return _locals;
		}
		public function set locals (val:Object) : void
		{ _locals = val;  }
		
		public function get actions () : Object
		{
			if (!_actions) _actions = {};
			return _actions;
		}
		public function set actions (val:Object) : void
		{ _actions = val; }
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function setBackData (data:Object) : void
		{
			if ("avatarSkin" in data) data.avatarSkin = {id:data.avatarSkin};
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
				for each (var p:String in attributes)
					res[p] = this[p];
			}
			else
			{
				res =
				{
					pseudo     : _pseudo,
					classe     : _classe,
					level      : _level,
					bonus      : _bonus,
					avatarSkin : _avatarSkin,
					homePlace  : _homePlace,
					globals    : _globals,
					locals     : _locals,
					actions    : _actions
				}
			}
			
			return res;
		}
		
	}

}

