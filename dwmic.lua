--DWMIC: Una solución para los pesados --

-- //////////////////
-- // dwmic_OnLoad //
-- //////////////////
function dwmic_OnLoad()
	-- Procesos previos: Encender y cargar las slash.
	dwmic_EN = true; -- Encendido.
	dwmic_WH = {}; -- Lista de whispers recibidos.
	dwmic_WHi = 0; -- Cuenta los whispers.
	SLASH_DWMIC1 = "/dwmic"; -- Prompt de funciones variadas.
	SlashCmdList["DWMIC"] = dwmic_DWMIC; 
	
	-- Mensajes
	
	if (GetLocale() == "esES") then
		msg1 = "[DWMIC] Ahora mismo estoy ocupado en un combate. En cuanto que pueda atenderte, te susurraré. Esto es una autorrespuesta";
		msg2 = "[DWMIC] DWMIC cargado y funcionando. Para ayuda, escribe /dwmic help o /dwmic info";
		msg3 = "[DWMIC] DWMIC desactivado. Para activarlo, escribe /dwmic toggle";
		msg4 = "[DWMIC] DWMIC activado. Para desactivarlo, escribe /dwmic toggle";
		msg5 = "[DWMIC] Para activar/desactivar DWMIC, escribe /dwmic toggle. \n Para personalizar el mensaje, escribe /dwmic seguido de un espacio y tu mensaje personalizado.\n Para devolver el mensaje a su valor de incio, escribe /dwmic reset.";
		msg6 = "[DWMIC] Para personalizar el texto de autorrespuesta, escriba /dwmic y el texto que desee mostrar";
		msg7 = "[DWMIC] DWMIC restaurado a su mensaje por defecto";
		msg8 = "[DWMIC] Addon para evitar susurros en combate. Creado por Elæsandrøs@C'Thun-Eu";
		msg9 = "[DWMIC] ¡Mensaje personalizado!";
		msg10 = "[DWMIC] Mientras estabas en combate te susurró";
	elseif (GetLocale() == "frFR") then
		msg1 = "[DWMIC] Je suis juste occupé en ce moment dans un combat. Merci, d'attendre jusqu'à ce que je puisse te parler. Ceci est une réponse automatique";
		msg2 = "[DWMIC] DWMIC chargé et en cours d'exécution. Écrire /dwmic aide ou /dwmic info pour de l'aide";
		msg3 = "[DWMIC] DWMIC a été désactivé. Pour activer, écrire /dwminc toggle";
		msg4 = "[DWMIC] DWMIC a été activée. Pour désactiver, écrire /dwmic toggle";
		msg5 = "[DWMIC] Pour activer/désactiver DWMIC, écrire /dwmic toggle. \n Afin de personnaliser la réponse automatique, écrire /dwmic suivi d'un espace et votre message personnalisé. \n In afin de réinitialiser le message, écrire /dwmic reset";
		msg6 = "[DWMIC] Afin de personnaliser le texte pour votre réponse automatique, écrire / dwmic et le texte que vous voulez montrer";
		msg7 = "[DWMIC] DWMIC Remettre le message par d'origine";
		msg8 = "[DWMIC] Addon créé dans le but d'éviter des chuchotements alors que vous êtes en combat. Créé par Elæsandrøs@C'Thun-Eu";
		msg9 = "[DWMIC] Message personnalisé!";	
		msg10 = "[DWMIC] En attendant tu étais dans un combat il t'a chuchoté";
	else
		msg1 = "[DWMIC] I'm busy right now in a combat. Please, wait until I can talk to you. This is an automatic answer";
		msg2 = "[DWMIC] DWMIC loaded and working. Write /dwmic help or /dwmic info for help";
		msg3 = "[DWMIC] DWMIC has been turned off. To turn on, write /dwminc toggle";
		msg4 = "[DWMIC] DWMIC has been turned on. To turn off, write /dwmic toggle";
		msg5 = "[DWMIC] In order to turn on/off DWMIC, write /dwmic toggle. \n In order to personalize the automatic answer, write /dwmic followed by a space and your personalized message. \n In order to reset the message, write /dwmic reset";
		msg6 = "[DWMIC] In order to personalize the text of the automatic answer, write /dwmic and the text you want to show";
		msg7 = "[DWMIC] DWMIC restored to its original message";
		msg8 = "[DWMIC] Addon created in order to avoid the whispers while you are in combat. Created by Elæsandrøs@C'Thun-Eu";
		msg9 = "[DWMIC] Message personalized!";
		msg10 = "[DMIW] While you were in combat, you have been whispered by";
	end
	
	if (DWMIC_MSG == nil) then -- La primera vez que logueas te pone el mensaje de default
		DWMIC_MSG = msg1;
	end
	
	if (dwmic_EN == true) then -- Si está encendido
		if (DEFAULT_CHAT_FRAME) then --Si existe el chat
			DEFAULT_CHAT_FRAME:AddMessage(msg2); -- Mensaje de inicio.
		end
	end
end

-- ///////////////////
-- // dwmic_OnEvent //
-- ///////////////////
function dwmic_OnEvent()
	if (dwmic_EN == true) then
		if (event == "PLAYER_REGEN_DISABLED") then -- Al entrar en combate
			dwmic_WH = {}; -- La lista de nombres vacía.
			dwmic_WHi = 0;	-- Contador de la lista a 0.
		end
		if (event == "CHAT_MSG_WHISPER") then -- Si me wispean. 
			local nombre = arg2 --El nombre de quien me wsipea
			if (UnitAffectingCombat("player") == 1) then --Si además estoy en combate
				SendChatMessage(DWMIC_MSG,"WHISPER",nil,arg2); -- Envia el mensaje predefinido.
				local auxlista = true; -- El auxiliar de control de nombre repetidos
				for i = 0, dwmic_WHi do -- Recorremos todos los nombres almacenados hasta el momento
					if (dwmic_WH[i]==nombre) then-- Si se repite en alguno
						auxlista = false; -- Es que está repe (obvious troll is obvious)
					end
				end
				if (auxlista == true) then-- Si no está repe.
					dwmic_WHi++; -- Incrementamos el contador del array (no queremos pisar el último)
					dwmic_WH[dwmic_WHi] = nombre; -- Y guardamos el nuevo nombre.
				end
			end
		end
		if (event == "PLAYER_REGEN_ENABLED") then-- Una vez acaba el combate.
			local whispers = msg10; -- Cogemos el mensaje por defecto.
			for i=0, dwmic_WHi do -- Recorremos el array de nombres
				whispers = whispers.." "..dwmic_WH[i]; -- Y le añadimos los nombres de los whispers.
			end
			DEFAULT_CHAT_FRAME:AddMessage(whispers); -- Y lo soltamos.
		end
	end
end

-- //////////////////
-- // dwmic_TOGGLE //
-- //////////////////
function dwmic_TOGGLE() --Activar o desactivar el addon.
	if (dwmic_EN == true) then -- Si está encendido
		dwmic_EN = false; -- Apagalo
		DEFAULT_CHAT_FRAME:AddMessage(msg3); -- y avisame
	elseif (dwmic_EN == false) then -- Si está apagado
		dwmic_EN = true; -- Enciendelo
		DEFAULT_CHAT_FRAME:AddMessage(msg4); -- y avisame
	end
end

-- ////////////////
-- // dwmic_INFO //
-- ////////////////
function dwmic_INFO() -- Información sobre el addon.
	DEFAULT_CHAT_FRAME:AddMessage(msg5);
end

-- /////////////////
-- // dwmic_DWMIC //
-- /////////////////
function dwmic_DWMIC(msg, editbox)
	if (msg == "") then -- Si no hay nada escrito
		DEFAULT_CHAT_FRAME:AddMessage(msg6);
	elseif (msg == "reset") then -- Si es reset
		DWMIC_MSG = msg1;
		DEFAULT_CHAT_FRAME:AddMessage(msg7);	
	elseif (msg == "on" or msg == "off" or msg == "toggle") then --Toggle
		dwmic_TOGGLE();
	elseif (msg == "help" or msg == "info" or msg == "ayuda" or msg == "aide") then -- Ayuda
		dwmic_INFO();
	elseif (msg == "about") then -- About
		DEFAULT_CHAT_FRAME:AddMessage(msg8);
	elseif (msg == "Ghostcrawler") then -- -huevo de pascua xD
		DEFAULT_CHAT_FRAME:AddMessage("GHOSTCRAWLER PROMISED ME A PONY!!1!");
	else --Cualquier otra cosa
		DWMIC_MSG = "[DWMIC] "..msg;
		DEFAULT_CHAT_FRAME:AddMessage(msg9);
	end
end