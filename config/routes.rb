Rails.application.routes.draw do
  namespace :api do
    # Survivor
    resource :survivors, only: %i[create] do
      get '/', action: :index
      get '/:survivor_id', action: :show
      patch '/:survivor_id/location', action: :update_location
    end

    # Infections
    resource :infections, only: %i[create]
  end

  root to: redirect('/api-docs')
end
