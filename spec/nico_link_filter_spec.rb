# encoding: utf-8
require 'spec_helper'

describe 'NicoLinkFilter' do
  subject do
    filter = HTML::Pipeline::NicoLinkFilter.new(text)
    filter.call.to_s
  end

  context 'sm12345' do
    let(:text) { 'sm12345' }
    it { expect(subject).to eq '<a href="http://www.nicovideo.jp/watch/sm12345">sm12345</a>' }
  end

  context 'commons.nicovideo.jp/user/123' do
    let(:text) { 'commons.nicovideo.jp/user/123' }
    it { expect(subject).to eq '<a href="http://commons.nicovideo.jp/user/123">commons.nicovideo.jp/user/123</a>' }
  end

  context 'sm12345 ar23456　td34567' do
    let(:text) { 'sm12345 ar23456　td34567' }
    it { expect(subject).to eq '<a href="http://www.nicovideo.jp/watch/sm12345">sm12345</a> <a href="http://ch.nicovideo.jp/article/ar23456">ar23456</a>　<a href="http://3d.nicovideo.jp/works/td34567">td34567</a>' }
  end

  context 'sm12345sm23456' do
    let(:text) { 'sm12345sm23456' }
    it { expect(subject).to eq 'sm12345sm23456' }
  end

  context '<b>sm</b>123' do
    let(:text) { '<b>sm</b>123' }
    it { expect(subject).to eq '<b>sm</b>123' }
  end

  context '<b>hoge</b> im5678' do
    let(:text) { '<b>hoge</b> im5678' }
    it { expect(subject).to eq '<b>hoge</b> <a href="http://seiga.nicovideo.jp/seiga/im5678">im5678</a>' }
  end

  context '<a href="http://www.nicovideo.jp/watch/sm9">http://www.nicovideo.jp/watch/sm9</a>' do
    let(:text) { '<a href="http://www.nicovideo.jp/watch/sm9">http://www.nicovideo.jp/watch/sm9</a>' }
    it { expect(subject).to eq '<a href="http://www.nicovideo.jp/watch/sm9">http://www.nicovideo.jp/watch/sm9</a>' }
  end
end
