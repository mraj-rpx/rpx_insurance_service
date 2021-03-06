Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: "sessions"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :insurance_services do
    collection do
      get :select_form
    end

    member do
      get :form_xml_content
      get :download_pdf
    end
  end

  resources :companies, only: [:index]

  scope 'admin', as: 'admin' do
    resources :insurance_applications
  end
  root to: 'insurance_services#index'
end
