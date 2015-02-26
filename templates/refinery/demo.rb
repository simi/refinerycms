require 'rbconfig'

# We want to ensure that you have an ExecJS runtime available!
begin
  require 'execjs'
rescue LoadError
  abort "ExecJS is not installed. Please re-start the installer after running:\ngem install execjs"
end

if File.read("#{destination_root}/Gemfile") !~ /assets.+coffee-rails/m
  gem "coffee-rails", :group => :assets
end

append_file 'Gemfile' do
"
gem 'refinerycms', git: 'https://github.com/refinery/refinerycms', branch: 'master'

# Add support for refinerycms-wymeditor
gem 'refinerycms-wymeditor', ['~> 1.0', '>= 1.0.6']

gem 'seo_meta', git: 'https://github.com/parndt/seo_meta', branch: 'master'

# track deployed git SHA in HTTP header
gem 'sha_header', github: 'simi/sha_header'
"
end

begin
  require 'execjs'
  ::ExecJS::Runtimes.autodetect
rescue
  gsub_file 'Gemfile', "# gem 'therubyracer'", "gem 'therubyracer'"
end

run 'bundle install'

rake 'db:create'
generate "refinery:cms --fresh-installation #{ARGV.join(' ')}"

rake 'db:migrate'
rake 'db:seed'

say <<-SAY
  ============================================================================
    Your new Refinery CMS application is now running on edge and mounted to /.
  ============================================================================
SAY
