Rails.application.routes.draw do
  devise_for :users, 
    controllers: { sessions: 'users/sessions', registrations: 'users/registrations' },
    path_names: { sign_in: 'signin', sign_up: 'signup', sign_out: 'signout' }

  root to: 'home#home'

  # PAYMENTS
  post '/new/payment/intent', to: 'paymongo#create', as: 'new_payment_intent'

  # ORGANIZATIONS
  get '/dashboard', to: 'organization#dashboard', as: 'organization_dashboard'
  get '/projects', to: 'organization#projects', as: 'organization_projects'
  get '/colleagues', to: 'organization#colleagues', as: 'orgazniation_colleagues'

  # PROJECT
  get '/projects/:pid', to: 'project#read', as: 'organization_project'
  put '/projects/:pid', to: 'project#update', as: 'organization_project_update'
  delete '/projects/:pid', to: 'project#delete', as: 'organization_project_delete'
  post '/projects/new', to: 'project#create', as: 'new_organization_project'

  # ARTIFACT
  get '/projects/:pid/artifacts', to: 'artifact#read_all', as: 'organization_project_artifacts'
  get '/projects/:pid/artifacts/:aid', to: 'artifact#read_one', as: 'organization_project_artifact'
  put '/projects/:pid/artifacts/:aid', to: 'artifact#update', as: 'organization_project_artifact_update'
  delete '/projects/:pid/artifacts/:aid', to: 'artifact#delete', as: 'organization_project_artifact_delete'
  post '/projects/:pid/artifacts/new', to: 'artifact#create', as: 'new_organization_project_artifact'

end
