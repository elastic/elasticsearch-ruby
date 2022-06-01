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

namespace :automations do
  desc 'Update Stack Versions in test matrices (.github/workflows and .ci/test-matrix.yml)'
  task :update_matrices, :version do |_, args|
    @version = args[:version]
    error = 'Error: version must be passed in and needs to be a version format: 9.1.0, 8.7.15.'
    raise ArgumentError, error unless @version&.match?(/[0-9.]/)

    # Replace in test-matrix.yml
    file = File.expand_path('./.ci/test-matrix.yml')
    regex = /(STACK_VERSION:\s+- )([0-9.]+)(-SNAPSHOT)/
    replace_version(regex, file)

    # Replace in GitHub actions:
    paths = ['./.github/workflows/8.2.yml', './.github/workflows/unified-release.yml']
    paths.each do |path|
      file = File.expand_path(path)
      regex = /(stack-version: )([0-9.]+)(-SNAPSHOT)/
      replace_version(regex, file)
    end
  end

  def replace_version(regex, file)
    content = File.read(file)
    match = content.match(regex)
    content = content.gsub(regex, "#{match[1]}#{@version}#{match[3]}")
    File.open(file, 'w') { |f| f.puts content }
  end
end
