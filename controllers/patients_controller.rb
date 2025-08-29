class PatientsController < Sinatra::Base
  configure do
    set :views, 'views/patients'
    set :method_override, true
  end

  get '/patients' do
    # Всегда загружаем всех пациентов, сортировка от новых к старым
    @patients = Patient.all.order(created_at: :desc)
    erb :index
  end

  get '/patients/new' do
    @patient = Patient.new
    erb :new
  end

  post '/patients' do
    @patient = Patient.new(params[:patient])
    if @patient.save
      redirect "/patients/#{@patient.id}"
    else
      erb :new
    end
  end

  get '/patients/:id' do
    @patient = Patient.find(params[:id])
    @assessments = @patient.assessments
    erb :show
  end

  get '/patients/:id/edit' do
    @patient = Patient.find(params[:id])
    erb :edit
  end

  put '/patients/:id' do
    @patient = Patient.find(params[:id])
    if @patient.update(params[:patient])
      redirect "/patients/#{@patient.id}"
    else
      erb :edit
    end
  end

  delete '/patients/:id' do
    @patient = Patient.find(params[:id])
    @patient.destroy
    redirect '/patients'
  end
end