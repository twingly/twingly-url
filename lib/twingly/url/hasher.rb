require 'digest'

require_relative "../url"

module Twingly
  class URL
    module Hasher
      module_function

      # Instantiate digest classes in a thread-safe manner
      # This is important since we don't know how people will
      # use this gem (if they require it in a thread safe way)
      MD5_DIGEST = Digest(:MD5)
      SHA256_DIGEST = Digest(:SHA256)

      def taskdb_hash(url)
        MD5_DIGEST.hexdigest(url)[0..29].upcase
      end

      def blogstream_hash(url)
        MD5_DIGEST.hexdigest(url)[0..29].upcase
      end

      def documentdb_hash(url)
        SHA256_DIGEST.digest(url).unpack("L!")[0]
      end

      def autopingdb_hash(url)
        SHA256_DIGEST.digest(url).unpack("q")[0]
      end

      def pingloggerdb_hash(url)
        SHA256_DIGEST.digest(url).unpack("Q")[0]
      end
    end
  end
end
