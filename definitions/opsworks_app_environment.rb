define :opsworks_app_environment, :app_name => nil, :release_path => nil do
  app_name = params[:app_name]
  release_path = params[:release_path]

  Chef::Log.debug('Starting opsworks_app_environment')
  Chef::Log.debug("app_name = #{app_name}") rescue nil
  Chef::Log.debug("release_path = #{release_path}") rescue nil

  app_vars = node[:env_vars][app_name] rescue {}

  if app_vars && !app_vars.empty?
    app_vars.each do |environment, vars|
      Chef::Log.debug("Installing env file for #{environment}")
      template "#{release_path}/.env.#{environment}" do
        cookbook "opsworks_app_environment"
        source "env.erb"
        mode "0660"
        owner node[:deploy][app_name][:user]
        group node[:deploy][app_name][:group]
        variables(:env_vars => vars)
      end
    end
  end
end
