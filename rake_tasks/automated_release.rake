GEMS = [
  'elasticsearch',
  'elasticsearch-transport',
  'elasticsearch-api',
  'elasticsearch-xpack'
].freeze

namespace :unified_release do
  CURRENT_DIR = Dir.pwd
  desc 'Build and publish gems'
  task :publish do
    GEMS.each do |gem|
      remove_built_gems(gem)
      build_gem(gem)
    end

    GEMS.each do |gem|
      publish(gem)
      # github_tag(gem)
    end
  end

  def remove_built_gems(dir)
    Dir.glob("#{dir}/*.gem").each do |file|
      puts "Removing #{file}"
      File.delete(file) if File.exist?(file)
    end
  end

  def build_gem(gem)
    Dir.chdir gem
    sh "gem build #{gem}.gemspec"
    puts '------------------------------------------------------------'
    puts "Built gems: #{Dir.glob('*.gem')}"
    puts '------------------------------------------------------------'
    Dir.chdir CURRENT_DIR
  end

  def publish(gem)
    auth_key = ENV['RUBYGEMS_AUTH_KEY']
    raise ArgumentError, 'ENV[RUBYGEMS_AUTH_KEY] is not set' unless auth_key

    Dir.chdir gem
    built_gem_file = "#{gem}-#{version}.gem"
    puts("curl --data-binary @#{built_gem_file} \\
        -H 'Authorization:#{auth_key}' \\
        https://rubygems.org/api/v1/gems")

    Dir.chdir CURRENT_DIR
  end

  def github_tag(gem); end

  def version
    Elasticsearch::VERSION
  end
end
