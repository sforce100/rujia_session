class RujiaSession::InitializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_initializer_file
    copy_file "session_database.yml", "config/session_database.yml"
  end
end
