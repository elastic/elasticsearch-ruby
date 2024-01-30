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

module Elasticsearch
  module API
    # Helper with file related methods for code generation
    module DocsHelper
      def docs(name, info)
        info['type'] = 'String' if info['type'] == 'enum' # Rename 'enums' to 'strings'
        info['type'] = 'Integer' if info['type'] == 'int' # Rename 'int' to 'Integer'
        tipo = info['type'] ? info['type'].capitalize : 'String'
        description = info['description'] ? info['description'].strip : '[TODO]'
        options = info['options'] ? "(options: #{info['options'].join(', ').strip})" : nil
        required = info['required'] ? '(*Required*)' : ''
        deprecated = info['deprecated'] ? '*Deprecated*' : ''
        optionals = [required, deprecated, options].join(' ').strip

        "# @option arguments [#{tipo}] :#{name} #{description} #{optionals}\n"
      end

      def stability_doc_helper(stability)
        return if stability == 'stable'

        if stability == 'experimental'
          <<~MSG
            # This functionality is Experimental and may be changed or removed
            # completely in a future release. Elastic will take a best effort approach
            # to fix any issues, but experimental features are not subject to the
            # support SLA of official GA features.
          MSG
        elsif stability == 'beta'
          <<~MSG
            # This functionality is in Beta and is subject to change. The design and
            # code is less mature than official GA features and is being provided
            # as-is with no warranties. Beta features are not subject to the support
            # SLA of official GA features.
          MSG
        else
          <<~MSG
            # This functionality is subject to potential breaking changes within a
            # minor version, meaning that your referencing code may break when this
            # library is upgraded.
          MSG
        end
      end
    end
  end
end
