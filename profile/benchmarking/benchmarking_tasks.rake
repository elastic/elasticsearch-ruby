# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'pry-byebug'
require_relative "../benchmarking"

namespace :benchmark do

  namespace :simple do

    desc "Run the \'ping\' benchmark test"
    task :ping do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        task = Elasticsearch::Benchmarking::Simple.new(run)
        puts "PING: #{task.run(:ping)}"
      end
    end

    desc "Run the \'create index\' benchmark test"
    task :create_index do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        task = Elasticsearch::Benchmarking::Simple.new(run)
        puts "CREATE INDEX: #{task.run(:create_index)}"
      end
    end

    desc "Run the \'index smal document\' benchmark test with patron adapter"
    task :index_document_small_patron do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        begin
          require 'patron'
        rescue LoadError
          puts "Patron not loaded, skipping test"
        else
          task = Elasticsearch::Benchmarking::Simple.new(run, :patron)
          puts "INDEX SMALL DOCUMENT, PATRON: #{task.run(:index_document_small)}"
        end
      end
    end

    desc "Run the \'index small document\' benchmark test"
    task :index_document_small do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        task = Elasticsearch::Benchmarking::Simple.new(run)
        puts "INDEX SMALL DOCUMENT: #{task.run(:index_document_small)}"
      end
    end

    desc "Run the \'index large document\' benchmark test"
    task :index_document_large do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        task = Elasticsearch::Benchmarking::Simple.new(run)
        puts "INDEX LARGE DOCUMENT: #{task.run(:index_document_large)}"
      end
    end

    desc "Run the \'get small document\' benchmark test"
    task :get_document_small do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        task = Elasticsearch::Benchmarking::Simple.new(run)
        puts "GET SMALL DOCUMENT: #{task.run(:get_document_small)}"
      end
    end

    desc "Run the \'get large document\' benchmark test"
    task :get_document_large do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        task = Elasticsearch::Benchmarking::Simple.new(run)
        puts "GET LARGE DOCUMENT: #{task.run(:get_document_large)}"
      end
    end

    desc "Run the \'search small document\' benchmark test"
    task :search_document_small do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        task = Elasticsearch::Benchmarking::Simple.new(run)
        puts "SEARCH SMALL DOCUMENT: #{task.run(:search_document_small)}"
      end
    end

    desc "Run the \'search small document\' benchmark test"
    task :search_document_large do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        task = Elasticsearch::Benchmarking::Simple.new(run)
        puts "SEARCH LARGE DOCUMENT: #{task.run(:search_document_large)}"
      end
    end

    desc "Run the \'update document\' benchmark test"
    task :update_document do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        task = Elasticsearch::Benchmarking::Simple.new(run)
        puts "UPDATE DOCUMENT: #{task.run(:update_document)}"
      end
    end

    desc "Run all simple benchmark tests"
    task :all, [:matrix] do |t, args|
      %w[ benchmark:simple:ping
          benchmark:simple:create_index
          benchmark:simple:index_document_small
          benchmark:simple:index_document_small_patron
          benchmark:simple:index_document_large
          benchmark:simple:get_document_small
          benchmark:simple:get_document_large
          benchmark:simple:search_document_small
          benchmark:simple:search_document_large
          benchmark:simple:update_document
        ].each do |task_name|
        begin
          Rake::Task[task_name].invoke(*args)
        rescue => ex
          puts "Error in task [#{task_name}], #{ex.inspect}"
          next
        end
      end
    end

    # namespace :noop do
    #
    #   desc "Run the \'search small document\' benchmark test with the noop plugin"
    #   task :search_document_small do
    #     puts "SIMPLE REQUEST BENCHMARK:: SEARCH SMALL DOCUMENT WITH NOOP PLUGIN"
    #     Elasticsearch::Benchmarking::Simple.new.run(:search_document_small, noop: true)
    #   end
    # end
  end

  namespace :complex do

    desc "Run the \'index documents\' benchmark test"
    task :index_documents do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        task = Elasticsearch::Benchmarking::Complex.new(run)
        puts "INDEX DOCUMENTS: #{task.run(:index_documents)}"
      end
    end

    desc "Run the \'search documents\' benchmark test"
    task :search_documents do
      Elasticsearch::Benchmarking.each_run(ENV['matrix']) do |run|
        task = Elasticsearch::Benchmarking::Complex.new(run)
        puts "SEARCH DOCUMENTS: #{task.run(:search_documents)}"
      end
    end

    desc "Run all complex benchmark test"
    task :all do
      %w[ benchmark:complex:index_documents
        ].each do |task_name|
        Rake::Task[task_name].invoke
      end
    end
  end
end
