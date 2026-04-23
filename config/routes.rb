resources :projects do
  resources :risks do
    member do
      get 'add_issue'
      post 'add_existing_issue'
      delete 'remove_issue'
    end
  end
end

resources :risk_statuses