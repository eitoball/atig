#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-
require 'atig/ifilter/strip'
require 'atig/twitter_struct'
require 'atig/spec_helper'

describe Atig::IFilter::Strip do
  before do
    @ifilter = Atig::IFilter::Strip.new %w(*tw* _)
  end

  it "should strip *tw*" do
    @ifilter.call(status("hoge *tw*")).should be_text("hoge")
  end

  it "should strip _" do
    @ifilter.call(status("hoge _")).should be_text("hoge")
  end

  it "should strip white-space" do
    @ifilter.call(status("  hoge  ")).should be_text("hoge")
  end
end
