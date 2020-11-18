desc <<-DESC
  Update Rubygems versions in version.rb and *.gemspec files

  Example:

      $ rake update_version[5.0.0,5.0.1]
DESC
task :update_version, :old, :new do |_, args|
  require 'ansi'

  puts '[!!!] Required argument [old] missing'.ansi(:red) unless args[:old]
  puts '[!!!] Required argument [new] missing'.ansi(:red) unless args[:new]

  files = Dir['**/**/version.rb','**/**/*.gemspec']

  longest_line = files.map(&:size).max

  puts"\n", '= FILES '.ansi(:faint) + ('='*92).ansi(:faint), "\n"

  files.each do |file|
    begin
      content = File.read(file)
      if content.match Regexp.new(args[:old])
        content.gsub! Regexp.new(args[:old]), args[:new]
        puts "+ [#{file}]".ansi(:green).ljust(longest_line+20) + " [#{args[:old]}] -> [#{args[:new]}]".ansi(:green,:bold)
        File.open(file, 'w') { |f| f.puts content }
      else
        puts "- [#{file}]".ansi(:yellow).ljust(longest_line+20) + " -".ansi(:faint,:strike)
      end
    rescue Exception => e
      puts "[!!!] #{e.class} : #{e.message}".ansi(:red,:bold)
      raise e
    end
  end

  puts "\n\n", '= CHANGELOG '.ansi(:faint) + ('='*88).ansi(:faint), "\n"

  log = `git --no-pager log --reverse --no-color --pretty='* %s' HEAD --not v#{args[:old]} elasticsearch*`.split("\n")

  puts log.join("\n")

  log_entries = {}
  log_entries[:client] = log.select { |l| l =~ /\[CLIENT\]/ }
  log_entries[:api] = log.select { |l| l =~ /\[API\]/ }
  log_entries[:dsl] = log.select { |l| l =~ /\[DSL\]/ }
  log_entries[:ext] = log.select { |l| l =~ /\[EXT\]/ }
  log_entries[:xpack] = log.select { |l| l =~ /\[XPACK\]/ }

  changelog = File.read(File.open('CHANGELOG.md', 'r'))

  changelog_update = ''

  if log.any? { |l| l =~ /CLIENT|API|DSL/ }
    changelog_update << "## #{args[:new]}\n\n"
  end

  unless log_entries[:client].empty?
    changelog_update << "### Client\n\n"
    changelog_update << log_entries[:client]
                          .map { |l| l.gsub /\[CLIENT\] /, '' }
                          .map { |l| "#{l}" }
                          .join("\n")
    changelog_update << "\n\n"
  end

  unless log_entries[:api].empty?
    changelog_update << "### API\n\n"
    changelog_update << log_entries[:api]
                          .map { |l| l.gsub /\[API\] /, '' }
                          .map { |l| "#{l}" }
                          .join("\n")
    changelog_update << "\n\n"
  end

  unless log_entries[:dsl].empty?
    changelog_update << "### DSL\n\n"
    changelog_update << log_entries[:dsl]
                          .map { |l| l.gsub /\[DSL\] /, '' }
                          .map { |l| "#{l}" }
                          .join("\n")
    changelog_update << "\n\n"
  end

  unless log_entries[:client].empty?
    changelog_update << "### EXT:#{args[:new]}\n\n"
    changelog_update << log_entries[:ext]
                          .map { |l| l.gsub /\[EXT\] /, '' }
                          .map { |l| "#{l}" }
                          .join("\n")
    changelog_update << "\n\n"
  end

  unless log_entries[:xpack].empty?
    changelog_update << "### XPACK\n\n"
    changelog_update << log_entries[:xpack]
                            .map { |l| l.gsub /\[XPACK\] /, '' }
                            .map { |l| "#{l}" }
                            .join("\n")
    changelog_update << "\n\n"
  end

  File.open('CHANGELOG.md', 'w+') { |f| f.write changelog_update and f.write changelog }

  puts "\n\n", "= DIFF ".ansi(:faint) + ('='*93).ansi(:faint)

  diff = `git --no-pager diff --patch --word-diff=color --minimal elasticsearch*`.split("\n")

  puts diff
         .reject { |l| l =~ /^\e\[1mdiff \-\-git/ }
         .reject { |l| l =~ /^\e\[1mindex [a-z0-9]{7}/ }
         .reject { |l| l =~ /^\e\[1m\-\-\- i/ }
         .reject { |l| l =~ /^\e\[36m@@/ }
         .map    { |l| l =~ /^\e\[1m\+\+\+ w/ ? "\n#{l}   " + '-'*(104-l.size) : l }
         .join("\n")

  puts "\n\n", '= COMMIT '.ansi(:faint) + ('='*91).ansi(:faint), "\n"

  puts  'git add CHANGELOG.md elasticsearch*',
        "git commit --verbose --message='Release #{args[:new]}' --edit",
        'rake release',
        ''
end
