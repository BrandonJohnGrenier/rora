
task :default => :test

task :test do
  require 'rake/testtask'
  Rake::TestTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*.rb']
    t.verbose = true
  end
end

