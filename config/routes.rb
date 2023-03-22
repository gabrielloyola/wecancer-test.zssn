Rails.application.routes.draw do
  namespace :api do
    # Survivor
    resource :survivors, only: %i[create] do
      get '/', action: :index
      get '/:survivor_id', action: :show
      patch '/:survivor_id/location', action: :update_location
    end

    # Infections
    resource :infections do
      post '/:infected_id/report', action: :report_infected
    end

    # Inventory
    resource :inventory do
      put '/:survivor_id/add', action: :add_item
      put '/:survivor_id/remove', action: :remove_item
    end
  end

  root to: redirect('/api-docs')
end
