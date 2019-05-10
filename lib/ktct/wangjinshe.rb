require 'thor'

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
      puts super(data || STDIN.read)
    end

    desc 'decrypt [DATA]', "Decrypt data using client's private key, DATA can also be read from STDIN"
    def decrypt(data = nil)
      reset_key(config['client_private_key_path'])
      puts super(data || STDIN.read)
    end

    desc 'sign [DATA]', "Sign data using client's private key, DATA can also be read from STDIN"
    def sign(data = nil)
      reset_key(config['client_private_key_path'])
      puts super(data || STDIN)
    end

    desc 'verify <SIGNATURE> [DATA]', "Verify signature using Wangjingshe's public key, DATA can also be read from STDIN"
    def verify(signature, data = nil)
      reset_key(config['server_public_key_path'])
      puts super(signature, data || STDIN.read)
    end

    no_commands do
      def config
        super['wjs']
      end
    end
  end
end
