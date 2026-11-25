resources :projects do
  resources :risks, only: [:index, :new, :create]
  resources :risk_categories, except: [:index, :show]
end

resources :risks, except: [:index, :new, :create] do
  collection do
    match 'bulk_edit', via: [:get, :post]
    post 'bulk_update'
    delete 'bulk_destroy'
  end
end

match '/risks_context_menu', to: 'risk_context_menus#index', as: 'risks_context_menu', via: [:get, :post]
resources :risk_statuses
