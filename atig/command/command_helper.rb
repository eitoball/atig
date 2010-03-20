#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

class FakeGateway
  attr_reader :names,:action,:filtered,:updated, :notified

  def initialize(channel)
    @channel = channel
  end

  def ctcp_action(*names, &action)
    @names  = names
    @action = action
  end

  def output_message(m); @filtered = m end

  def update_status(*args); @updated = args end

  def [](name)
    @notified = name
    @channel
  end
end

class FakeScheduler
  def initialize(api)
    @api = api
  end

  def delay(*args,&f)
    f.call @api
  end
end

module CommandHelper
  def init(klass)
    @log    = mock 'log'
    @opts   = mock 'opts'
    context = OpenStruct.new :log=>@log, :opts=>@opts

    @channel    = mock 'channel'
    @gateway    = FakeGateway.new @channel
    @api        = mock 'api'
    @statuses   = mock 'status DB'
    @followings = mock 'following DB'
    @me         = user 1,'me'
    db = OpenStruct.new :statuses=>@statuses,:followings=>@followings,:me=>@me
    @command = klass.new context, @gateway, FakeScheduler.new(@api), db
  end

  def call(channel, command, args)
    @gateway.action.call channel, "#{command} #{args.join(' ')}", command, args
  end
end
