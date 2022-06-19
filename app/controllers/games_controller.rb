class GamesController < ApplicationController
    
    #callback
    
    before_action :check_token, only:[ :create, :join, :save_result] #check_token me permite recuperar el jugador que está ejecutando la request
    before_action :set_game, only:[ :show, :join, :save_result]

    #actions
    #Este action me muestra todos los games existentes si no agrego parámetros de búsqueda.
    #También puedo usarlo para mostrar todos los juegos disponibles para el join si agrego el parámetro de solicitud search= . Sin nada porque 
    #los games disponibles son aquellos sin player2_id
    #Ej. http://127.0.0.1:3000/games?search=
    def index
        if params[:search].present?
            @games = Game.where(player2_id: params[:search])
            render status: 200, json: {games: @games}
        else
            @games = Game.all
            render status: 200, json: {games: @games}
        end
    end

    def show
        render status: 200, json: {game: @game}
    end

   
    def create
        @game = Game.new() 
        @game.player1 = @player #player lo recupero en check_token
        @game.game_name = params[:game_name]
        
        game_save
    end

    #action para asignar el segundo jugador a un game
    def join
        @game.player2 = @player #player lo recupero en el before_action check_token y game lo recupero con set_game
        game_save
    end
    
    #Cada vez que en el front se marca una celda, guardo la modificaciòn. Tambien incremento de 1 el turno
    def save_result
        
        return render status: 400, json: {message: "El juego ya ha terminado!"} if @game.winner!=0 #No me deja jugar si ya hay un ganador
        return render status: 400, json: {message: "No es tu partida!"} if @player != @game.player1 && @player != @game.player2  #No deja jugar un player que no pertenece al gamerai

        @game.result=params[:result]
        @game.turn=@game.turn+1 #Incremento el turno en 1, porque marcar una celda representa un turno

        @game.winner_game #Llamo al método de instancia para ver si uno de los dos jugadores gana la partida

        

        game_save
    end
   
 
    def game_save
        if @game.save 
            
            render status: 200, json: {game: @game}
        else
            render status: 400, json: {message: @game.errors.details}
        end
    end

    def set_game
        @game=Game.find_by(id: params[:id]) 
        return if @game.present? 

        render status: 404, json: { message: "No esta #{params[:id]}"}
		false 
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
