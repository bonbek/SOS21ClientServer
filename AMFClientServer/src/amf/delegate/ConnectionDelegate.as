package amf.delegate {

	import flash.net.*;
	import com.sos21.net.*;
	import amf.model.User;

	/**
	 *	Service de connection.
	 * Renvoi un Objet User.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  15.04.2011
	 */
	public class ConnectionDelegate {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function ConnectionDelegate (service:Service)
		{
			this.service = service;
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		private var service:Service;
		private var successCallBack:Function;
		private var faultCallBack:Function;		

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		/**
		 *	@param key String
		 *	@param successCallBack Function
		 *	@param faultCallBack Function
		 */
		public function connect (	credentials:Object,
											successCallBack:Function = null,
											faultCallBack:Function = null	) : void
		{
			this.successCallBack = successCallBack;
			this.faultCallBack = faultCallBack;
			
			if (credentials)
			{
				// On sera en mode utilisateur
				service.setCredentials(credentials.login, credentials.password);
				// Recup data user
				service.call(	"getUserData", new Responder(onUserLoaded, onFault),
									credentials.login, credentials.password, true	);
			}
			else
			{
				// On sera en mode invité
				service.setCredentials("guest", "35675e68f4b5af7b995d9205ad0fc43842f16450");
				// check si ce visiteur est déjà venue
				var so:SharedObject = SharedObject.getLocal("sos21guest");
				if (so.data.id)
				{
					// Déjà venu
					successCallBack.apply(null, [new User(true, so.data.id)]);
					dispose();
				}
				else
				{
					// Première venue, on crée un player
					var dataPlayer:Object =
					{
						linkToUser:false,
						pseudo:"Visiteur",
						avatarSkin:4,
						level:1,
						classe:"Yakafokeu",
						bonus:[0,20,20,20]
					}
					service.call(	"Players", new Responder(onGuestCreated, onFault),
										"create", dataPlayer	);
				}
			}
		}

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		/**
		 * Réception data utilisateur
		 *	@param result Object
		 */
		private function onUserLoaded (result:Object) : void
		{
			if (!result)
			{
				onFault(result);
			}
			else
			{
				successCallBack.apply(null, [new User(false, result.current_player)]);
				dispose();
			}			
		}
		
		/**
		 * Réception d'un nouveau joueur invité
		 *	@param result Object
		 */
		private function onGuestCreated (result:Object) : void
		{
			if (!result)
			{
				onFault(false);
			}
			else {
				// On stoque l'identifiant joueur
				var so:SharedObject = SharedObject.getLocal("sos21guest");
				var playerId:String = so.data.id = result.id;
				so.flush();
				
				// On renvoie l'utilisateur invité avec son nouveau
				// player créé.
				successCallBack.apply(null, [new User(true, playerId)]);
				dispose();
			}
		}

		/**
		 *	@param fault Object
		 */
		private function onFault (fault:Object) : void
		{
			faultCallBack.apply(null, [false]);
			dispose();
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 */
		private function dispose () : void
		{
			successCallBack = null;
			faultCallBack = null;
			service = null;
		}
		
	}

}

