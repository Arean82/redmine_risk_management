resources :projects do
  resources :risks, only: [:index, :new, :create] do
    collection do
      match 'preview', via: [:get, :post]
    end
  end
  resources :risk_categories, except: [:index, :show]
  get 'risks_dashboard', to: 'risk_dashboards#show', as: 'risks_dashboard'
end

resources :risks, except: [:index, :new, :create] do
  member do
    match 'preview', via: [:get, :post]
  end
  resources :issues, controller: 'risk_issues', only: [:create, :destroy]
  collection do
    match 'bulk_edit', via: [:get, :post]
    post 'bulk_update'
    delete 'bulk_destroy'
  end
end

match '/risks_context_menu', to: 'risk_context_menus#index', as: 'risks_context_menu', via: [:get, :post]
resources :risk_statuses
