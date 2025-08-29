
require 'sinatra'
require 'sinatra/activerecord'
# Подключение новых контроллеров
require_relative 'controllers/triage_parameters_controller'
require_relative 'controllers/priority_conditions_controller'


# Подключение моделей
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |file| require file }

# Подключение контроллеров
require_relative 'controllers/patients_controller'
require_relative 'controllers/assessments_controller'

# Конфигурация БД
set :database, YAML.load(File.open('config/database.yml'))

# Простой flash механизм
helpers do
  def flash
    @flash ||= session.delete(:flash) || {}
  end
  
  def set_flash(type, message)
    session[:flash] ||= {}
    session[:flash][type] = message
  end
end

enable :sessions

# Главная страница
get '/' do
  redirect '/patients'
end

# Подключение маршрутов из контроллеров
use PatientsController
use AssessmentsController


# Использование контроллеров
use TriageParametersController
use PriorityConditionsController