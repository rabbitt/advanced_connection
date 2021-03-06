#
# Copyright (C) 2016 Finalsite, LLC
# Copyright (C) 2016 Carl P. Corliss <carl.corliss@finalsite.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'active_record/connection_adapters/abstract_adapter'

module AdvancedConnection
  module ActiveRecordExt
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :AbstractAdapter
      autoload :ConnectionPool
      autoload :WithoutConnection
    end

    included do
      ActiveRecord::ConnectionAdapters::AbstractAdapter.instance_exec do
        include AbstractAdapter
      end

      ActiveRecord::ConnectionAdapters::ConnectionPool.instance_exec do
        include ConnectionPool::IdleManager if AdvancedConnection.enable_idle_connection_manager
        include ConnectionPool::WithoutConnection
      end

      ActiveRecord::Base.instance_exec do
        extend ActiveRecordExt::WithoutConnection
      end
    end
  end
end
