namespace :deploy do
  desc 'pushes the couch couchapp'
  task :couch do
    if File.exists?('couch/.couchapprc')
      `cd couch && couchapp push prod`
    else
      raise 'Please create a .couchapprc file in the couch directory that looks like this: http://gist.github.com/227484'
    end
  end  
end
