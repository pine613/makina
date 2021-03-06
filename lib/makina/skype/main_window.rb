#!/usr/bin/ruby
# -*- encoding: utf-8 -*-


require_relative './uri'
require_relative './chat'
require_relative './path'

module Makina
  module Skype
    class MainWindow
      attr_reader :skype_path, :screen, :ahk

      def initialize(skype_path = nil, log = nil)
        Makina::SikuliUtil::Loader::load
        
        @skype_path = skype_path || Makina::Skype::Path.find_exec_path
        @ahk = Makina::AHK::Skype.new
        @screen = Sikulix::Screen.new
        @log = log || Logger.new(STDOUT)
      end

      def start
        if @ahk.skype_running?
          true
        else
          @ahk.skype_start(@skype_path)
        end
      end

      def activate
        @ahk.skype_activate_main_window
        wait_visible
      end

      def wait_visible
        @log.info('Finding the Skype main window ...')
        Makina::SikuliUtil::Finder.find_any(
          @skype.screen,
          ['main_window.png', 'main_window2.png'],
          10)
      end

      def wait_active
        @log.info('Waiting for the Skype main window to become active')
        @ahk.call('WaitActiveSkypeMainWindow')
      end

      def chat(users)
        Skype::Chat.new(self, users)
      end

      def dispose
        @ahk.terminate
      end
    end
  end
end
