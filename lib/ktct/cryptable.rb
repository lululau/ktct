require 'zlib'
require 'base64'
require 'digest'

module Ktct
  module Cryptable
    %i[public_encrypt private_decrypt private_encrypt public_decrypt].each do |type|
      define_method type do |message|
        crypt(message, type)
      end
    end

    attr_accessor :key

    def encrypt(message)
      public_encrypt(Base64.strict_encode64(message)).unpack('H*').first
    end

    def decrypt(message)
      Base64.strict_decode64(private_decrypt([message].pack('H*')))
    end

    def sverify(signature, message)
      key.verify('sha1', [signature].pack('H*'), Digest::SHA1.hexdigest(message))
    end

    def ssign(message)
      key.sign('sha1', Digest::SHA1.hexdigest(message)).unpack('H*').first
    end

    def stupid_decrypt(message)
      Base64.decode64(public_decrypt([message].pack('H*'))).force_encoding('UTF-8')
    end

    def stupid_encrypt(message)
      private_encrypt(Base64.encode64(message)).unpack('H*').first
    end

    def stupid_decrypt_batch(message)
      Zlib.gunzip(public_decrypt([message].pack('H*'))).force_encoding('UTF-8')
    end

    def stupid_encrypt_batch(message)
      private_encrypt(Zlib.gzip(message)).unpack('H*').first
    end

    def crypt(message, type)
      bytes_array = message.unpack('C*')
      input_length = bytes_array.length

      result, offset, i = "", 0, 0
      block_size = send("max_#{type.to_s.split('_').last}_block_size")
      begin
        bytes = bytes_array[offset, block_size]
        result << key.send(type, bytes.pack("C*"))
        offset = (i += 1) * block_size
      end while input_length - offset > 0

      result
    end

    def max_encrypt_block_size
      modulus_byte_size - 11
    end

    def max_decrypt_block_size
      modulus_byte_size
    end

    def modulus_byte_size
      key.n.to_s(16).size / 2
    end

    def reset_key(key_file, passphrase=nil)
      key_file = File.expand_path(key_file)
      if key_file =~ /pfx/
        @key = OpenSSL::PKCS12.new(IO.read(key_file), passphrase).key
      else
        @key = OpenSSL::X509::Certificate.new(IO.read(key_file)).public_key
      end
    end

  end
end
