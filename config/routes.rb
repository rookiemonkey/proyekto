Rails.application.routes.draw do
  devise_for :users, 
    controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords' },
    path_names: { sign_in: 'signin', sign_up: 'signup', sign_out: 'signout' }

  root to: 'home#home'

  # PAYMENTS METHODS
  scope module: :payment_methods do
    post '/new/payment/intent', to: 'paymongo#create', as: 'new_payment_intent'
  end

  # ORGANIZATIONS
  get '/dashboard', to: 'organization#dashboard', as: 'organization_dashboard'
  get '/projects', to: 'organization#projects', as: 'organization_projects'
  get '/colleagues', to: 'organization#colleagues', as: 'orgazniation_colleagues'
  get '/artifacts', to: 'organization#artifacts', as: 'orgazniation_artifacts'
  put '/plans', to: 'organization#update_plan', as: 'update_organization_plan'

  # PROJECT
  get '/projects/:pid', to: 'project#read', as: 'organization_project'
  put '/projects/:pid', to: 'project#update', as: 'organization_project_update'
  delete '/projects/:pid', to: 'project#delete', as: 'organization_project_delete'
  post '/projects/new', to: 'project#create', as: 'new_organization_project'

  # ARTIFACT
  put '/projects/:pid/artifacts/:aid', to: 'artifact#update', as: 'organization_project_artifact_update'
  delete '/projects/:pid/artifacts/:aid', to: 'artifact#delete', as: 'organization_project_artifact_delete'
  post '/projects/:pid/artifacts/new', to: 'artifact#create', as: 'new_organization_project_artifact'

  # COLLEAGUE
  get '/colleagues/new', to: 'colleague#new', as: 'new_organization_colleague'
  post '/colleagues/new', to: 'colleague#create', as: 'create_organization_colleague'
  put '/colleagues/new', to: 'colleague#accept', as: 'accept_organization_colleague'
  get '/colleagues/decline', to: 'colleague#decline', as: 'decline_organization_colleague'
end
