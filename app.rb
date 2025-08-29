require 'sinatra'
require 'sinatra/activerecord'

# Подключение моделей
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |file| require file }

# Подключение контроллеров
require_relative 'controllers/patients_controller'
require_relative 'controllers/assessments_controller'

# Конфигурация БД
set :database, YAML.load(File.open('config/database.yml'))

# Главная страница
get '/' do
  redirect '/patients'
end

# Подключение маршрутов из контроллеров
use PatientsController
use AssessmentsController