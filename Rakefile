def clean
  Dir['cim_attributes-*.gem'].each{|f| File.unlink(f)}
end

def build
  `gem build cim_attributes.gemspec`
end

def publish_local
  dir = '~/Development/Gems/'
  `cp cim_attributes-*.gem #{dir}/gems/`
  `gem generate_index --update --modern -d #{dir}`
end

def publish_remote
  `gem push cim_attributes-*.gem`
end

def uninstall
  `sudo gem uninstall cim_attributes`
end

def install_local
  install('http://localhost/Gems/')
end

def install_remote
  install
end

def install(source=nil)
  cmd = 'sudo gem install cim_attributes'
  if !source.nil?
    cmd << " --source #{source}"
  end
  `#{cmd}`
end

def run_tests(gem=true)
  cmd = "ruby test/cim_attributes_test.rb"
  if gem 
    cmd << ' gem'
  end
  puts `#{cmd}`
end

def test
  clean
  uninstall
  build
  publish_local
  install_local
  run_tests
end

def publish
  clean
  uninstall
  build
  publish_remote
  install_remote
  run_tests
end

namespace :gem do 
  task(:clean){clean}
  task(:build){build}
  task(:uninstall){uninstall}
  task(:install_local){install_local}
  task(:install_remote){install_remote}
  task(:publish_local){publish_local}
  task(:publish_remote){publish_remote}
  task(:run_tests){run_tests}
  task(:test){test}
  task(:publish){publish}
end
