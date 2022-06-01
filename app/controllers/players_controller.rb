class PlayersController < ApplicationController

    #esto callback se ejectua en los actions elencado despues de only
	before_action :set_player, only:[ :show, :update, :destroy] #no me sirve identificar un
                                                                #player especifico en el index, create
    #before_action :check_token, only: [:index, :show, :update, :destroy] No lo uso porque se me complicò en el front
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

     #No tuve tiempo de implementarlo en el front
    def update
        @player.assign_attributes(player_params)
        player_save
    end

    #No tuve tiempo de implementarlo en el front
    def destroy
        if @player.destroy
            render status: 200
        else
            render status: 400, json: {message: @player.errors.details}
        end
    end


    #Empiezan mi methods
    #Sirve para que acepte solo el name y la password de una request
    def player_params
        params.require(:player).permit(:name, :password)
    end

    def set_player
        @player=Player.find_by(name: params[:id]) #Asi busco por name, pero id està fijo porque està en la ruta
        return if @player.present? #retorna inmediatamente si @player existe. Si no existe, sigue

        render status: 404, json: { message: "No esta #{params[:id]}"}
		false #el false sirve para no ir al show. Porque si player es blank, no puedo seguir
				#con mi action. Si no pongo false, despues del render sigue
    end

    #Guarda en la base de datos
    def player_save
        if @player.save #Si logra guardarlo
            render status: 200, json: {player: @player}
        else
            render status: 400, json: {message: @player.errors.dettails}
        end
    end

    #Sirve para verificar quien està haciendo la request
    def check_token
        return if request.headers["Authorization"]=="Bearer #{@player.token}"
        #dejar espacio despues de return para buena costumbre. Si la condicion de if se cumple, la 
        #funcion retorna. Sino sigue con render status
        render status: 401, json:["Token equivocado!"]
        false #false necesario para que no se ejecute el action que ha llamado check_token como callback
    end
    
end
