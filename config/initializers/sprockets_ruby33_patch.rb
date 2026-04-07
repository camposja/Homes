# Patch Sprockets 4.2.2 for Ruby 3.3 compatibility.
# Sprockets-rails passes Regexp objects from assets.precompile into resolve(),
# but multiple methods (valid_asset_uri?, absolute_path?, etc.) call String
# methods that don't exist on Regexp. Filter non-String paths early.
if Gem::Version.new(Sprockets::VERSION) <= Gem::Version.new("4.2.2")
  module Sprockets
    module Resolve
      alias_method :original_resolve, :resolve

      def resolve(path, **kargs)
        return nil, Set.new unless path.is_a?(String)
        original_resolve(path, **kargs)
      end
    end
  end
end
