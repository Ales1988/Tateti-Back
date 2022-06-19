class PlayersController < ApplicationController

    #esto callback se ejectua en los actions elencado despues de only
	before_action :check_token, only: [ :show]
    
    def index
        @players = Player.all
        render status: 200, json: {players: @players}
    end

    def show
        render status: 200, json: {player: @player}
    end

    def create
        @player = Player.new(player_params) #el new no guarda en la base de datos. El save si
        player_save
    end

    #En el login el usuario introduce nombre y contraseña para recuperar el token que se guarda en la sesión del front
    #Ej request http://127.0.0.1:3000/players/Ale/login?password=ale
    def login
         @player=Player.where(name: params[:id], password: params[:password])
         if @player.present?
            render status: 200, json: {player: @player}
         else
            render status: 404, json: {message: "No existe el jugador o la contraseña es incorrecta."}
         end
    end

    #Empiezan mi methods
    #Sirve para que acepte solo el name y la password de una request
    def player_params
        params.require(:player).permit(:name, :password)
    end

    #Guarda en la base de datos
    def player_save
        if @player.save #Si logra guardarlo
            render status: 200, json: {player: @player}
        else
            render status: 400, json: {message: @player.errors.dettails}
        end
    end

    #Verifica la identidad del usuario a través del token que envía el front (después de haberlo guardado gracias al login)
    #Esto hace innecesario un método set_user
    def check_token
        token = request.headers["Authorization"].split(" ") #Tengo que usar split porque el front envía "Bearer token" y solo necesito el token.
        @player=Player.find_by(token: token[1])#En token[0] queda "Bearer"

        return if @player.present?
        #dejar espacio despues de return para buena costumbre. Si la condicion de if se cumple, la 
        #funcion retorna. Sino sigue con render status
        render status: 401, json:{message: "Debe iniciar sesión con un usuario válido"}#Si llega a esta línea de código, significa que se ha introducido manualmente un token incorrecto en el front en lugar de seguir el procedimiento normal de inicio de sesión
        false #false necesario para que no se ejecute el action que ha llamado check_token como callback
    end
    
end
