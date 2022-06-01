class Player < ApplicationRecord

    #relaciones
    #has_many :games, inverse_of: "Player"
    #validaciones
    validates :name, presence: true

    #callback
    before_create :set_token
    #No puede ser after_create porque sino no lo guarda, porque cuando crea el token, ya se guardò la nueva instancia de player.

  
    def set_token
    self.token=SecureRandom.uuid #SecureRandom garantiza unicidad, probabilidad collisiòn muy baja
    end
end
