require 'thor'
require 'openssl'

module Ktct
  class Baofu < ::Thor

    include Ktct::Config
    include Ktct::Cryptable

    no_commands do
      alias_method :original_decrypt, :decrypt
    end

    desc 'encrypt [DATA]', "Encrypt data using Baofu's public key, DATA can also be read from STDIN"
    def encrypt(data=nil)
      reset_key(config['platform-certificate-path'])
      puts super(data || STDIN.read)
    end

    desc 'decrypt [DATA]', "Decrypt data using client's private key, DATA can also be read from STDIN"
    def decrypt(data=nil)
      reset_key(config['payee-private-key-path'], config['payee-private-key-passphrase'])
      puts super(data || STDIN.read)
    end

    desc 'sencrypt [DATA]', "Encrypt data using client's private key, DATA can also be read from STDIN"
    def sencrypt(data=nil)
      reset_key(config['payee-private-key-path'], config['payee-private-key-passphrase'])
      puts stupid_encrypt(data || STDIN.read)
    end

    desc 'sdecrypt [DATA]', "Decrypt data using Baofu's public key, DATA can also be read from STDIN"
    def sdecrypt(data=nil)
      reset_key(config['platform-certificate-path'])
      puts stupid_decrypt(data || STDIN.read)
    end

    desc 'ssign [DATA]', "Sign data using client's private key, DATA can also be read from STDIN"
    def ssign(data=nil)
      reset_key(config['payee-private-key-path'], config['payee-private-key-passphrase'])
      puts super(data || STDIN)
    end

    desc 'sverify <SIGNATURE> [DATA]', "Verify signature using Baofu's public key, DATA can also be read from STDIN"
    def sverify(signature, data=nil)
      reset_key(config['platform-certificate-path'])
      puts super(signature, data || STDIN.read)
    end

    desc 'de_encrypt <DIGITAL_ENVELOP> [DATA]',  "Encrypt data using specified digital envelop, DATA can also be read from STDIN"
    def de_encrypt(digital_envelop, data=nil)
      puts DigitalEnvelop.new(digital_envelop).encrypt(data || STDIN.read)
    end

    desc 'de_decrypt <DIGITAL_ENVELOP> [DATA]',  "Decrypt data using specified digital envelop, DATA can also be read from STDIN"
    def de_decrypt(digital_envelop, data=nil)
      digital_envelop = decrypt_digital_envelop(digital_envelop)
      puts DigitalEnvelop.new(digital_envelop).decrypt(data || STDIN.read)
    end

    desc 'de_gen', "Generate a random digital envelop"
    def de_gen
      original = DigitalEnvelop.get
      puts "Original:  #{original}"
      print "Encrypted: "
      encrypted = encrypt(original.to_s)
    end

    desc 'decrypt_de <DIGITAL_ENVELOP>',  "Decrypt encrypted digital envelop using client's private key"
    def decrypt_de(digital_envelop)
      decrypt(digital_envelop)
    end

    no_commands do

      def config
        super['bf']
      end

      def decrypt_digital_envelop(raw)
        raw = raw.chomp.strip
        if raw.size == 19 && raw[2] == '|'
          raw
        else
          reset_key(config['payee-private-key-path'], config['payee-private-key-passphrase'])
          original_decrypt(raw)
        end
      end
    end
  end
end
