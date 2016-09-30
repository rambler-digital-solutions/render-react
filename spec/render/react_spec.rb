require 'spec_helper'

describe Render::React do
  before :each do
    Render::React::Config.path FIXTURES_PATH
  end

  subject do
    klass = Class.new.include(Render::React)
    klass.new
  end

  it 'evals plain js' do
    Render::React::Compiler.bootstrap
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

  it 'recreates itself when durability is <= 0' do
    Render::React::Compiler.instance_variable_set(:@durability, 1)
    2.times do
      output = subject.render_react(
        :HelloMessage,
        name: 'Frank'
      )
    end
    expect(
      Render::React::Compiler.instance_variable_get(:@durability)
    ).to eq(Render::React::Config.durability - 1)
  end

  it 'doesn\'t have memory leaks' do
    Render::React::Compiler.bootstrap
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
      until V8::C::V8::IdleNotification(); end
    end
    average = samples.inject(:+).to_f / samples.size
    expect(average < samples.first).to be_truthy
  end
end
