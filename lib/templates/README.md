===============================================================================

Some setup you must do manually if you haven't yet:

  1. This authentication pattern depends on the BCrypt library for securing
     passwords. If you have not done so already, uncomment or add in

     gem 'bcrypt'

     and then run

     bundle install

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

===============================================================================
