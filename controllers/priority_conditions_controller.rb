# controllers/priority_conditions_controller.rb
class PriorityConditionsController < Sinatra::Base
  configure do
    set :views, 'views/priority_conditions'
    set :method_override, true
  end
  
  get '/admin/conditions' do
    @conditions = PriorityCondition.ordered
    @parameters = TriageParameter.active.ordered
    erb :index
  end
  
  get '/admin/conditions/new' do
    @condition = PriorityCondition.new
    @parameters = TriageParameter.active.ordered
    erb :new
  end
  
  post '/admin/conditions' do
    @condition = PriorityCondition.new(params[:condition])
    if @condition.save
      redirect '/admin/conditions'
    else
      @parameters = TriageParameter.active.ordered
      erb :new
    end
  end
  
  get '/admin/conditions/:id/edit' do
    @condition = PriorityCondition.find(params[:id])
    @parameters = TriageParameter.active.ordered
    erb :edit
  end
  
  put '/admin/conditions/:id' do
    @condition = PriorityCondition.find(params[:id])
    if @condition.update(params[:condition])
      redirect '/admin/conditions'
    else
      @parameters = TriageParameter.active.ordered
      erb :edit
    end
  end
  
  delete '/admin/conditions/:id' do
    @condition = PriorityCondition.find(params[:id])
    @condition.update(active: false)
    redirect '/admin/conditions'
  end
end