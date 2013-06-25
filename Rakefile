require 'pathname'

subprojects = %w| elasticsearch elasticsearch-client elasticsearch-api |
__current__ = Pathname( File.expand_path('..', __FILE__) )

task :default do
  system "rake --tasks"
end

namespace :test do
  desc "Run unit tests in all subprojects"
  task :unit do
    subprojects.each do |project|
      sh "cd #{__current__.join(project)} && rake test:unit"
      puts '-'*80
    end
  end
end

desc "Generate documentation for all subprojects"
task :doc do
  subprojects.each do |project|
    sh "cd #{__current__.join(project)} && rake doc"
    puts '-'*80
  end
end
