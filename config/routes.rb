Rails.application.routes.draw do
  namespace :api do
    # Survivor
    resource :survivors, only: %i[create] do
      get '/', action: :index
      get '/:survivor_id', action: :show
      patch '/:survivor_id/location', action: :update_location
    end

    # Infections
    namespace :infections do
      post '/:infected_id/report', action: :report_infected
    end

    # Inventory
    namespace :inventories do
      put '/:survivor_id/add', action: :add_item
      put '/:survivor_id/remove', action: :remove_item
      post '/exchange', action: :exchange_items
    end

    # Reports
    get '/statistics', to: 'statistics#generate'
  end

  root to: redirect('/api-docs')
end
