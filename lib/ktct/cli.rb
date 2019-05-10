require 'thor'

module Ktct
  class Cli < ::Thor
    class_option :config, aliases: ['-c'], type: :string, required: false, default: '~/.ktct.yml'

    desc 'bf <SUB_COMMAND> <OPTS>', 'crypto utils for baofu'
    subcommand :bf, Ktct::Baofu

    desc 'wjs <SUB_COMMAND> <OPTS>', 'crypto utils for wangjinshe'
    subcommand :wjs, Ktct::Wangjinshe
  end
end
