module Applidget
  module Oauth2
    module Rails
      class Routes
        module Helper
          def applidget_accounts(options = {}, &block)
            Applidget::Oauth2::Rails::Routes.new(self, &block).generate_routes!(options)
          end
        end

        def generate_routes!(options)
          
