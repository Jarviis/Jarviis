# Requires Ruby 2.x (keyword arguments)
# Released under the public domain
# Credits to @agorf - http://github.com/agorf

require 'cgi'
require 'digest'

module GravatarHelper
  def gravatar_url(email, secure: false, ext: nil, size: 48, default: 'mm')
    base_url = '%{protocol}://%{prefix}.gravatar.com' % {
      :protocol => 'http' + (secure ? 's' : ''),
      :prefix   => secure ? 'secure' : 'www'
    }
    path = '/avatar/%{id}%{ext}?s=%{size}&d=%{default}' % {
      :id      => Digest::MD5.hexdigest(email).downcase,
      :ext     => ext.blank? ? '' : '.' + ext.to_s.sub('.', ''),
      :size    => size.to_i,
      :default => CGI.escape(default)
    }
    base_url + path
  end
end