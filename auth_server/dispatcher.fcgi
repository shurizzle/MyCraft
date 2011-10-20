#!/usr/bin/env ruby

# require rack fastcgi {{{
require 'rack/handler/fastcgi'

# support for ruby 1.9.x {{{
class FCGI; class ValuesRecord
  def self::read_length(buf)
    if buf.getbyte(0) >> 7 == 0
      buf.slice!(0, 1).getbyte(0)
    else
      buf.slice!(0, 4).unpack('N')[0] & ((1 << 31) - 1)
    end
  end
end; end
# }}}
# }}}

# Magic things {{{
module Kernel
  def suppress_warnings
    tmp, $VERBOSE = $VERBOSE, nil
    result = yield
    $VERBOSE = tmp
    return result
  end
end
# }}}

Kernel.suppress_warnings { # because rack redefine some constants
  require ::File.expand_path('../config/boot.rb', __FILE__)
}

# Correcting dumbness {{{
module Padrino; class Router
  alias __real_call__ call
  def call(env)
    self.__real_call__(env.merge!(
      'SCRIPT_NAME' => "",
      'PATH_INFO'   => File.join(env['SCRIPT_NAME'], env['PATH_INFO'].to_s)
    ))
  end
end; end
# }}}

Rack::Handler::FastCGI.run(Padrino.application)
