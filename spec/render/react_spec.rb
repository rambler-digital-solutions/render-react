require 'spec_helper'

describe Render::React do
  subject do
    Render::React::Config.path FIXTURES_PATH
    klass = Class.new.include(Render::React)
    klass.new
  end

  it 'evals plain js' do
    expect(
      Render::React::Compiler.cxt.eval('2*2')
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

  xit 'doesn\'t have memory leaks' do
    samples = []
    100.times do |_i|
      1000.times do |_j|
        output = Render::React::Compiler.render(
          :HelloMessage,
          name: :LeakyName
        )
      end
      GC.start
      ps = `ps ax -o rss,pid | grep " #{$$}"`.strip
      size, pid = ps.split.map(&:to_i)
      samples << size
    end
    average = samples.inject(:+).to_f / samples.size
    expect(average < samples.first).to be_truthy
  end
end
