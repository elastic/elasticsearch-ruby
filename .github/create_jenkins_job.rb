# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
source_branch = ARGV[0]
target_branch = ARGV[1]

def usage
  <<~USAGE

  This script creates a new Jenkins Job in .ci/jobs. It takes two parameters:
    - source branch: branch name for the job to use as a source
    - target branch: branch name for the new job
  In the new file, it is going to replace the source branch value with the target branch value and
  create a new yml file based on that.

  E.g.:
    $ #{__FILE__} 7.x 7.99
  This is going to use .ci/jobs/elastic+elasticsearch-ruby+7.x.yml as a source and create
  .ci/jobs/elastic+elasticsearch-ruby+7.99.yml and replace all the ocurrences of '7.x' with '7.99'
  in the new file.
  USAGE
end

unless source_branch && target_branch
  puts usage
  exit
end

job_file = File.expand_path("../.ci/jobs/elastic+elasticsearch-ruby+#{source_branch}.yml", __dir__)
raise ArgumentError, "cannot find file #{job_file}" unless File.exist? job_file

target_branch_file = File.expand_path("../.ci/jobs/elastic+elasticsearch-ruby+#{target_branch}.yml", __dir__)
target_branch_content = File.read(job_file).gsub(source_branch, target_branch)

begin
  File.open(target_branch_file, 'w') { |file| file.puts target_branch_content }
rescue StandardError => e
  raise e
end
