class User < ActiveRecord::Base
    self.abstract_class = true #important!
    establish_connection(YAML.load_file("#{Rails.root}/config/session_database.yml")[Rails.env])
end