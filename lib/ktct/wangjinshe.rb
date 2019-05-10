require 'thor'
require 'open-uri'

module Ktct
  class Wangjinshe < ::Thor
    include Ktct::Config
    include Ktct::Cryptable

    no_commands do
      alias_method :original_decrypt, :decrypt
    end

    desc 'encrypt [DATA]', "Encrypt data using Wangjinshe's public key, DATA can also be read from STDIN"
    def encrypt(data = nil)
      reset_key(config['server_public_key_path'])
      puts URI::encode_www_form_component(Base64.strict_encode64(public_encrypt(data || STDIN.read)).scan(/.{1,76}/).join("\n"))
    end

    desc 'decrypt [DATA]', "Decrypt data using client's private key, DATA can also be read from STDIN"
    def decrypt(data = nil)
      reset_key(config['client_private_key_path'])
      puts private_decrypt(Base64.strict_decode64((data || STDIN.read).gsub(/\n/, '')))
    end

    desc 'sign [DATA]', "Sign data using client's private key, DATA can also be read from STDIN"
    def sign(data = nil)
      reset_key(config['client_private_key_path'])
      puts URI::encode_www_form_component(Base64.strict_encode64(key.sign('sha1', data || STDIN.read)).scan(/.{1,76}/).join("\n"))
    end

    # desc 'verify <SIGNATURE> [DATA]', "Verify signature using Wangjinshe's public key, DATA can also be read from STDIN"
    # def verify(signature, data = nil)
    #   reset_key(config['server_public_key_path'])
    #   puts key.verify('sha1', Base64.strict_decode64(signature), data || STDIN.read)
    # end

    no_commands do
      def config
        super['wjs']
      end

      def reset_key(key_file)
        @key = OpenSSL::PKey::RSA.new(IO.read(File.expand_path(key_file)))
      end
    end
  end
end
