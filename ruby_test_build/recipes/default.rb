if node['os'] == 'windows'
  powershell_script 'Disable password complexity requirements' do
    code <<-EOH
      secedit /export /cfg $env:temp/export.cfg
      ((get-content $env:temp/export.cfg) -replace ('PasswordComplexity = 1', 'PasswordComplexity = 0')) | Out-File $env:temp/export.cfg
      secedit /configure /db $env:windir/security/new.sdb /cfg $env:temp/export.cfg /areas SECURITYPOLICY
    EOH
  end

  include_recipe 'omnibus'

  powershell_script 'copy elsewhere' do
    code 'Copy-Item -Recurse /home/vagrant/ruby-test /Users/vagrant/ruby-test'
  end
else
  include_recipe 'omnibus'
end

omnibus_build 'ruby-test' do
  project_dir '/Users/vagrant/ruby-test'
  log_level :internal
end
