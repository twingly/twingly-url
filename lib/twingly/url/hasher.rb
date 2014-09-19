require 'digest/md5'
require 'digest/sha2'

module Twingly
  module URL
    module Hasher
      module_function

      def taskdb_hash(url)
        Digest::MD5.hexdigest(url)[0..29].upcase
      end

      def blogstream_hash(url)
        Digest::MD5.hexdigest(url)[0..29].upcase
      end

      def documentdb_hash(url)
        Digest::SHA256.digest(url).unpack("L!")[0]
      end

      def autopingdb_hash(url)
        Digest::SHA256.digest(url).unpack("q")[0]
      end
    end
  end
end
