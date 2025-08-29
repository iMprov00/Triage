class TriageParametersController < Sinatra::Base
  configure do
    set :views, 'views/triage_parameters'
    set :method_override, true
  end
  
  get '/admin/parameters' do
    @parameters = TriageParameter.ordered
    erb :index
  end
  
  get '/admin/parameters/new' do
    @parameter = TriageParameter.new
    erb :new
  end
  
  post '/admin/parameters' do
    @parameter = TriageParameter.new(params[:parameter])
    if @parameter.save
      redirect '/admin/parameters'
    else
      erb :new
    end
  end
  
  get '/admin/parameters/:id/edit' do
    @parameter = TriageParameter.find(params[:id])
    erb :edit
  end
  
  put '/admin/parameters/:id' do
    @parameter = TriageParameter.find(params[:id])
    if @parameter.update(params[:parameter])
      redirect '/admin/parameters'
    else
      erb :edit
    end
  end
  
  delete '/admin/parameters/:id' do
    @parameter = TriageParameter.find(params[:id])
    @parameter.update(active: false)
    redirect '/admin/parameters'
  end
end

