require 'openssl'
require 'base64'
require 'securerandom'

module Ktct
  class DigitalEnvelop
    attr_accessor :aes, :algorithm, :key
    def initialize(content)
      _, @key = content.split('|')
    end

    def encrypt(content)
      @aes = OpenSSL::Cipher::AES.new(128, :CBC)
      @aes.encrypt
      @aes.padding = 0
      @aes.key = @key
      @aes.iv = @key
      (@aes.update(add_padding(Base64.encode64(content))) + @aes.final).unpack('H*').first
    end

    def decrypt(content)
      @aes = OpenSSL::Cipher::AES.new(128, :CBC)
      @aes.decrypt
      @aes.padding = 0
      @aes.key = @key
      @aes.iv = @key
      Base64.decode64((@aes.update([content].pack('H*')) + @aes.final).strip).force_encoding('UTF-8')
    end

    def add_padding(content)
      if content.bytesize % 16 == 0
        content
      else
        content + "\x00" * (16 - content.bytesize % 16)
      end
    end

    def to_s
      "01|#{@key}"
    end

    class << self
      def get
        new('01|%s' % SecureRandom.uuid.gsub(/-/, '')[0, 16])
      end
    end
  end
end
