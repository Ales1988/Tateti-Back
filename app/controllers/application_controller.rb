class ApplicationController < ActionController::Base
skip_before_action :verify_authenticity_token #linea necesaria no se porque, confio en Gaby
end
