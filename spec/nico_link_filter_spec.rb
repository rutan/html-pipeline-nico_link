# frozen_string_literal: true

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

  context 'ch.nicovideo.jp/kmmk' do
    let(:text) { 'ch.nicovideo.jp/kmmk' }
    it { expect(subject).to eq '<a href="http://ch.nicovideo.jp/kmmk">ch.nicovideo.jp/kmmk</a>' }
  end

  context 'ch.nicovideo.jp/kmmk' do
    let(:text) { 'ch.nicovideo.jp/kmmk' }
    it { expect(subject).to eq '<a href="http://ch.nicovideo.jp/kmmk">ch.nicovideo.jp/kmmk</a>' }
  end

  context 'jps156' do
    let(:text) { 'jps156' }
    it { expect(subject).to eq '<a href="http://jpstore.dwango.jp/products/detail.php?product_id=156">jps156</a>' }
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

  context 'all stars' do
    let :text do
      %w[
        sm123 watch/5321 co9999 ch1414 ar56789 td3232 nc9284 dw111 lv8864 sg9123 bk1313 im58
        commons.nicovideo.jp/user/1 niconicommons.jp/user/2
        user/illust/3 clip/555 ch.nicovideo.jp/h-p
        jps1111 gm54321 nq2525
      ].join(' ')
    end
    it { expect(subject).to eq '<a href="http://www.nicovideo.jp/watch/sm123">sm123</a> <a href="http://www.nicovideo.jp/watch/5321">watch/5321</a> <a href="http://com.nicovideo.jp/co9999">co9999</a> <a href="http://ch.nicovideo.jp/ch1414">ch1414</a> <a href="http://ch.nicovideo.jp/article/ar56789">ar56789</a> <a href="http://3d.nicovideo.jp/works/td3232">td3232</a> <a href="http://commons.nicovideo.jp/material/nc9284">nc9284</a> <a href="http://ichiba.nicovideo.jp/item/dw111">dw111</a> <a href="http://live.nicovideo.jp/watch/lv8864">lv8864</a> <a href="http://seiga.nicovideo.jp/watch/sg9123">sg9123</a> <a href="http://seiga.nicovideo.jp/watch/bk1313">bk1313</a> <a href="http://seiga.nicovideo.jp/seiga/im58">im58</a> <a href="http://commons.nicovideo.jp/user/1">commons.nicovideo.jp/user/1</a> <a href="http://www.niconicommons.jp/user/2">niconicommons.jp/user/2</a> <a href="http://seiga.nicovideo.jp/user/illust/3">user/illust/3</a> <a href="http://seiga.nicovideo.jp/clip/555">clip/555</a> <a href="http://ch.nicovideo.jp/h-p">ch.nicovideo.jp/h-p</a> <a href="http://jpstore.dwango.jp/products/detail.php?product_id=1111">jps1111</a> <a href="https://game.nicovideo.jp/atsumaru/games/gm54321">gm54321</a> <a href="https://q.nicovideo.jp/watch/nq2525">nq2525</a>' }
  end
end
