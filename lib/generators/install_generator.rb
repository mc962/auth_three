module AuthThree
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include AuthThree::Generators::OrmHelpers
      include AuthThree::Generators::ControllerHelpers
      source_root File.expand_path("../../templates", __FILE__)
      class_option :namespace, type: :string, description: "Namespace your controllers"

      def generate_db_content
        invoke "active_record:model", ['user'], migration: true
      end

      def inject_create_users_migration_content
        content = migration_data
        indent_depth = 0
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"
        index_content = migration_index_data
        require create_users_migration_file
        insert_into_file(create_users_migration_file, content, after: ":users do |t|\n")
        insert_into_file(create_users_migration_file, index_content, after: "t.timestamps\n    end")
      end

      def migrate_users_data
        rake "db:migrate"
      end

      def inject_user_model_content
        content = model_contents

        indent_depth = 0
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class("#{model_path}/user.rb", User, content)
      end

      def copy_application_controller
        copy_file(controller_source("application_controller.rb"), "#{File.join("app", "controllers")}/application_controller.rb", force: true)
      end

      def generate_user_controllers
        controller_names = ['users', 'sessions']
        controller_names.each do |name|
          if options[:namespace]
            generate "controller", "#{options[:namespace]}/#{name} --no-helper --no-assets"
            content = send("namespace_#{name}_contents".to_sym, options[:namespace])
            indent_depth = 0
            content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"
            inject_into_class("#{controllers_path}/#{name}_controller.rb", ("#{options[:namespace]}::".camelcase + "#{name}_controller".camelcase).constantize, content)
          else
            generate "controller", "#{name} --no-helper --no-assets"
            content = send("#{name}_controller_contents".to_sym)
            indent_depth = 0
            content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"
            inject_into_class("#{controllers_path}/#{name}_controller.rb", "#{name}_controller".camelcase.constantize, content)
          end
        end
      end

      def generate_routes
        if options[:namespace]
          content = router_contents(options[:namespace])
          indent_depth = 0
          content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

          route(content)
        else
          route "resources :users"
          route "resource :session"
        end
      end


      def further_instructions
        readme "README.md"
      end
      private

      def controllers_path
        if options[:namespace]
          File.join("app", "controllers", "#{options[:namespace]}")
        else
          File.join("app", "controllers")
        end
      end

      def controller_source(controller_name)
        if options[:namespace]
          File.expand_path("../../templates/json_controllers/#{controller_name}", __FILE__)
        else
          File.expand_path("../../templates/html_controllers/#{controller_name}", __FILE__)
        end
      end

      def migration_path
        @migration_path ||= File.join("db", "migrate")
      end

      def create_users_migration_file
        Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_create_users.rb$/).first
      end

      def model_path
        @model_path ||= File.join("app", "models")
      end


    end
  end
end
