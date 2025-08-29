class AssessmentsController < Sinatra::Base
  configure do
    set :views, 'views/assessments'
    set :method_override, true
  end

  get '/patients/:patient_id/assessments/new' do
    @patient = Patient.find(params[:patient_id])
    @assessment = Assessment.new
    erb :new
  end

  post '/patients/:patient_id/assessments' do
    @patient = Patient.find(params[:patient_id])
    @assessment = @patient.assessments.build(params[:assessment])
    
    if @assessment.save
      redirect "/patients/#{@patient.id}/assessments/#{@assessment.id}"
    else
      erb :new
    end
  end

  get '/patients/:patient_id/assessments/:id' do
    @patient = Patient.find(params[:patient_id])
    @assessment = Assessment.find(params[:id])
    @priority = @assessment.calculate_priority
    erb :show
  end

  get '/patients/:patient_id/assessments/:id/edit' do
    @patient = Patient.find(params[:patient_id])
    @assessment = Assessment.find(params[:id])
    erb :edit
  end

  put '/patients/:patient_id/assessments/:id' do
    @patient = Patient.find(params[:patient_id])
    @assessment = Assessment.find(params[:id])
    
    if @assessment.update(params[:assessment])
      redirect "/patients/#{@patient.id}/assessments/#{@assessment.id}"
    else
      erb :edit
    end
  end

  delete '/patients/:patient_id/assessments/:id' do
    @assessment = Assessment.find(params[:id])
    @assessment.destroy
    redirect "/patients/#{params[:patient_id]}"
  end
end