require 'json'

namespace :deploy do
  desc 'pushes the couch couchapp'
  task :couch do
    if File.exists?('couch/.couchapprc')
      `cd couch && couchapp push prod`
    else
      raise 'Please create a .couchapprc file in the couch directory that looks like this: http://gist.github.com/227484'
    end
  end

  desc 'pushes the ui part of the application'
  task :ui do
    info = JSON.parse(File.read('config.json'))
    to_path = "#{info['admin']}@#{info['prod']['couch']['host']}:/var/poeticc/app"
    tmp_dir = "/tmp/sammy"

    puts "copying things to " + to_path
  end
end
