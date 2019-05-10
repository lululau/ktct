# Ktct

KT Crypto Tools

## Installation


Install it yourself as:

    $ gem install ktct

Or:

    $ sudo gem install ktct

## Usage

```
Commands:
  ktct bf <SUB_COMMAND> <OPTS>   # crypto utils for baofu  
  ktct help [COMMAND]            # Describe available commands or one specific command  
  ktct wjs <SUB_COMMAND> <OPTS>  # crypto utils for wangjinshe  

Options:  
  -c, [--config=CONFIG]  
                         # Default: ~/.ktct.yml  

bf Sub-commands:  

  ktct bf de_decrypt <DIGITAL_ENVELOP> [DATA]  # Decrypt data using specified digital envelop, DATA can also be read from STDIN. Both encrypted and unencrypted digital envelop are supported.  
  ktct bf de_encrypt <DIGITAL_ENVELOP> [DATA]  # Encrypt data using specified digital envelop, DATA can also be read from STDIN  
  ktct bf de_gen                               # Generate a random digital envelop  
  ktct bf decrypt [DATA]                       # Decrypt data using client's private key, DATA can also be read from STDIN. This command should be used for decrypting digital envelop in protocol payment API.  
  ktct bf decrypt_de <DIGITAL_ENVELOP>         # Decrypt encrypted digital envelop using client's private key  
  ktct bf encrypt [DATA]                       # Encrypt data using Baofu's public key, DATA can also be read from STDIN. This command should be used for encrypting digital envelop in protocol payment API.  
  ktct bf help [COMMAND]                       # Describe subcommands or one specific subcommand  
  ktct bf sdecrypt [DATA]                      # Decrypt data using Baofu's public key, DATA can also be read from STDIN. This command should be used for decrypting data content in batch payment API.  
  ktct bf sencrypt [DATA]                      # Encrypt data using client's private key, DATA can also be read from STDIN. This command should be used for encrypting data content in batch payment API.  
  ktct bf ssign [DATA]                         # Sign data using client's private key, DATA can also be read from STDIN. This command should be used for signning params in protocol payment API.  
  ktct bf sverify <SIGNATURE> [DATA]           # Verify signature using Baofu's public key, DATA can also be read from STDIN. This command should be used for verifying params signature in protocol payment ..  

wjs Sub-commands:  

  ktct wjs decrypt [DATA]             # Decrypt data using client's private key, DATA can also be read from STDIN  
  ktct wjs encrypt [DATA]             # Encrypt data using Wangjinshe's public key, DATA can also be read from STDIN  
  ktct wjs help [COMMAND]             # Describe subcommands or one specific subcommand  
  ktct wjs sign [DATA]                # Sign data using client's private key, DATA can also be read from STDIN  
```

## Config file Example

```
default_env: demo
demo:
  bf:
    payee-private-key-path: /my/demo/keys/client.pfx
    payee-private-key-passphrase: "12345678"
    platform-certificate-path: /my/demo/keys/server.cer
  wjs:
    server_public_key_path: /my/demo/keys/client.pkcs8
    client_private_key_path: /my/demo/keys/server.pkcs8

pro:
  bf:
    payee-private-key-path: /my/pro/keys/client.pfx
    payee-private-key-passphrase: "12345678"
    platform-certificate-path: /my/pro/keys/server.cer
  wjs:
    server_public_key_path: /my/pro/keys/client.pkcs8
    client_private_key_path: /my/pro/keys/server.pkcs8
```

Selected config environment could be specified via the `KTCT_ENV` environment variable.
If no `KTCT_ENV` specified, the value of `default_env` option in config yaml would be used.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lululau/ktct. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ktct project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lululau/ktct/blob/master/CODE_OF_CONDUCT.md).
