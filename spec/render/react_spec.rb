require 'spec_helper'

describe Render::React do
  before :each do
    Render::React::Config.path FIXTURES_PATH
    Render::React::Compiler.bootstrap
  end

  subject do
    klass = Class.new.include(Render::React)
    klass.new
  end

  it 'evals plain js' do
    expect(
      Render::React::Compiler.evaljs('2*2')
    ).to eq(4)
  end

  it 'renders simple component' do
    name = 'Frank'
    output = subject.render_react(
      :HelloMessage,
      name: name
    )
    expect(output).to include('data-reactid')
    expect(output).to include(name)
  end

  it 'doesn\'t have memory leaks' do
    require 'objspace'
    samples = []
    10.times do |_i|
      100.times do |_j|
        output = Render::React::Compiler.render(
          :HelloMessage,
          name: :LeakyName
        )
      end
      ps = `ps ax -o rss,pid | grep " #{$$}"`.strip
      size, pid = ps.split.map(&:to_i)
      samples << size
      while !V8::C::V8::IdleNotification(); end
    end
    average = samples.inject(:+).to_f / samples.size
    expect(average < samples.first).to be_truthy
  end
end
