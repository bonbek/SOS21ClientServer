package amf.model {
	
	import ddgame.server.IUser;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  15.04.2011
	 */
	public class User implements IUser {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function User (isGuest:Boolean, playerId:String)
		{
			_isGuest = isGuest;
			_playerId = playerId;
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _isGuest:Boolean;
		private var _playerId:String;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Etat invité
		 */
		public function get isGuest () : Boolean
		{ return _isGuest; }
		
		/**
		 * Identifiant du joueur attaché à
		 * cet utilistateur
		 */
		public function get playerId () : String
		{ return _playerId; }
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}

